package com.example.focus_flow

import androidx.activity.result.contract.ActivityResultContracts
import android.os.Handler
import android.os.Looper
import com.tom_roush.pdfbox.android.PDFBoxResourceLoader
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private val backgroundExecutor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())
    private var pendingMediaFolderResult: MethodChannel.Result? = null
    private var pendingMediaExtensions: Set<String> = emptySet()
    private var pendingMediaType: String = ""
    private val mediaFolderPicker =
        registerForActivityResult(ActivityResultContracts.OpenDocumentTree()) { uri ->
            val result = pendingMediaFolderResult ?: return@registerForActivityResult
            pendingMediaFolderResult = null

            if (uri == null) {
                result.success(null)
                return@registerForActivityResult
            }

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
                    mediaFolderPicker.launch(null)
                }

                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        backgroundExecutor.shutdown()
        super.onDestroy()
    }
}
