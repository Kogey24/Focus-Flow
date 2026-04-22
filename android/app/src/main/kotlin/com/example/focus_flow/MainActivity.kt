package com.example.focus_flow

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
    }

    override fun onDestroy() {
        backgroundExecutor.shutdown()
        super.onDestroy()
    }
}
