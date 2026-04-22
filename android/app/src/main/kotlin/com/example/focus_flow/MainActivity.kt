package com.example.focus_flow

import com.tom_roush.pdfbox.android.PDFBoxResourceLoader
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
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

                    try {
                        result.success(PdfTableOfContentsExtractor.extract(filePath))
                    } catch (error: Exception) {
                        result.error("toc_extract_failed", error.message, null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}
