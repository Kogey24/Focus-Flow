package com.example.focus_flow

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import com.tom_roush.pdfbox.android.PDFBoxResourceLoader
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    companion object {
        private const val REQUEST_MEDIA_FOLDER = 40021
    }

    private val backgroundExecutor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())
    private var pendingMediaFolderResult: MethodChannel.Result? = null
    private var pendingMediaExtensions: Set<String> = emptySet()
    private var pendingMediaType: String = ""

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        PDFBoxResourceLoader.init(applicationContext)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "focus_flow/pdf_outline"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "extractTableOfContents" -> {
                    val filePath = call.argument<String>("filePath")
                    if (filePath.isNullOrBlank()) {
                        result.error("invalid_args", "filePath is required", null)
                        return@setMethodCallHandler
                    }

                    backgroundExecutor.execute {
                        try {
                            val outline = PdfTableOfContentsExtractor.extract(filePath)
                            mainHandler.post {
                                result.success(outline)
                            }
                        } catch (error: Exception) {
                            mainHandler.post {
                                result.error("toc_extract_failed", error.message, null)
                            }
                        }
                    }
                }

                else -> result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "focus_flow/media_folder"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "pickMediaFolder" -> {
                    if (pendingMediaFolderResult != null) {
                        result.error("already_active", "A folder picker is already active.", null)
                        return@setMethodCallHandler
                    }

                    val rawExtensions = call.argument<List<String>>("allowedExtensions").orEmpty()
                    val mediaType = call.argument<String>("mediaType")
                    if (mediaType.isNullOrBlank()) {
                        result.error("invalid_args", "mediaType is required.", null)
                        return@setMethodCallHandler
                    }
                    pendingMediaExtensions = rawExtensions.map { it.lowercase() }.toSet()
                    pendingMediaType = mediaType.lowercase()
                    pendingMediaFolderResult = result
                    val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).apply {
                        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                        addFlags(Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
                        addFlags(Intent.FLAG_GRANT_PREFIX_URI_PERMISSION)
                    }
                    startActivityForResult(intent, REQUEST_MEDIA_FOLDER)
                }

                else -> result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == REQUEST_MEDIA_FOLDER) {
            val result = pendingMediaFolderResult
            pendingMediaFolderResult = null

            if (result == null) {
                super.onActivityResult(requestCode, resultCode, data)
                return
            }

            if (resultCode != Activity.RESULT_OK) {
                result.success(null)
                return
            }

            val uri = data?.data
            if (uri == null) {
                result.error("media_folder_import_failed", "No folder was selected.", null)
                return
            }

            persistFolderPermission(uri, data)
            importSelectedMediaFolder(uri, result)
            return
        }

        super.onActivityResult(requestCode, resultCode, data)
    }

    private fun persistFolderPermission(uri: Uri, data: Intent?) {
        val grantedFlags = (data?.flags ?: 0) and
            (Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
        try {
            contentResolver.takePersistableUriPermission(uri, grantedFlags)
        } catch (_: SecurityException) {
            // Some providers do not offer persistable permissions; transient access is still enough.
        }
    }

    private fun importSelectedMediaFolder(
        uri: Uri,
        result: MethodChannel.Result,
    ) {
        val allowedExtensions = pendingMediaExtensions
        val mediaType = pendingMediaType
        backgroundExecutor.execute {
            try {
                val payload = MediaFolderImporter.importFromTree(
                    context = applicationContext,
                    treeUri = uri,
                    allowedExtensions = allowedExtensions,
                    mediaType = mediaType,
                )
                mainHandler.post {
                    result.success(payload)
                }
            } catch (error: Exception) {
                mainHandler.post {
                    result.error("media_folder_import_failed", error.message, null)
                }
            }
        }
    }

    override fun onDestroy() {
        backgroundExecutor.shutdown()
        super.onDestroy()
    }
}
