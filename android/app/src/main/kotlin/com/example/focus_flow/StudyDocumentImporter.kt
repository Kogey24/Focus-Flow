package com.example.focus_flow

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.OpenableColumns
import androidx.documentfile.provider.DocumentFile
import java.io.File
import java.io.FileOutputStream

object StudyDocumentImporter {
    private val videoExtensions = setOf(
        "mp4",
        "mkv",
        "mov",
        "avi",
        "webm",
        "m4v",
        "3gp",
        "mpeg",
        "mpg",
        "ts",
    )

    private val audioExtensions = setOf(
        "mp3",
        "aac",
        "wav",
        "m4a",
        "flac",
        "ogg",
        "opus",
        "wma",
    )

    private val mimeTypesByExtension = mapOf(
        "pdf" to "application/pdf",
        "docx" to "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    )

    fun collectDocumentUris(data: Intent?): List<Uri> {
        if (data == null) return emptyList()

        val uris = mutableListOf<Uri>()
        data.data?.let(uris::add)
        val clipData = data.clipData
        if (clipData != null) {
            for (index in 0 until clipData.itemCount) {
                clipData.getItemAt(index).uri?.let(uris::add)
            }
        }
        return uris.distinct()
    }

    fun mimeTypesForExtensions(allowedExtensions: Set<String>): List<String> {
        return when {
            allowedExtensions.isEmpty() -> listOf("*/*")
            allowedExtensions.all { it in videoExtensions } -> listOf("video/*")
            allowedExtensions.all { it in audioExtensions } -> listOf("audio/*")
            else -> allowedExtensions.mapNotNull { mimeTypesByExtension[it] }.ifEmpty { listOf("*/*") }
        }
    }

    fun importFromDocuments(
        context: Context,
        documentUris: List<Uri>,
        allowedExtensions: Set<String>,
    ): Map<String, Any> {
        val sessionRoot = File(
            context.cacheDir,
            "study_file_imports/${System.currentTimeMillis()}"
        )
        if (!sessionRoot.exists()) {
            sessionRoot.mkdirs()
        }

        val copiedPaths = mutableListOf<String>()
        var ignoredFilesCount = 0

        documentUris.forEachIndexed { index, uri ->
            val displayName = resolveDisplayName(context, uri, index)
            if (!isAllowedFile(context, uri, displayName, allowedExtensions)) {
                ignoredFilesCount++
                return@forEachIndexed
            }

            val outputFile = uniqueOutputFile(
                directory = sessionRoot,
                requestedName = sanitizeFileName(displayName),
            )

            val inputStream = context.contentResolver.openInputStream(uri)
            if (inputStream == null) {
                ignoredFilesCount++
                return@forEachIndexed
            }

            inputStream.use { input ->
                FileOutputStream(outputFile).use { output ->
                    input.copyTo(output)
                }
            }
            copiedPaths.add(outputFile.absolutePath)
        }

        return mapOf(
            "paths" to copiedPaths,
            "ignoredFilesCount" to ignoredFilesCount,
        )
    }

    private fun isAllowedFile(
        context: Context,
        uri: Uri,
        displayName: String,
        allowedExtensions: Set<String>,
    ): Boolean {
        val extension = displayName.substringAfterLast('.', "").lowercase()
        if (extension.isNotEmpty() && extension in allowedExtensions) {
            return true
        }

        val mimeType = context.contentResolver.getType(uri)?.lowercase() ?: return false
        return when {
            allowedExtensions.all { it in videoExtensions } -> mimeType.startsWith("video/")
            allowedExtensions.all { it in audioExtensions } -> mimeType.startsWith("audio/")
            else -> mimeType in mimeTypesForExtensions(allowedExtensions)
        }
    }

    private fun resolveDisplayName(
        context: Context,
        uri: Uri,
        index: Int,
    ): String {
        val documentName = DocumentFile.fromSingleUri(context, uri)?.name
        if (!documentName.isNullOrBlank()) {
            return documentName
        }

        context.contentResolver.query(
            uri,
            arrayOf(OpenableColumns.DISPLAY_NAME),
            null,
            null,
            null,
        )?.use { cursor ->
            val nameIndex = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
            if (nameIndex >= 0 && cursor.moveToFirst()) {
                val displayName = cursor.getString(nameIndex)
                if (!displayName.isNullOrBlank()) {
                    return displayName
                }
            }
        }

        return "document_${index + 1}"
    }

    private fun sanitizeFileName(fileName: String): String {
        val sanitized = fileName
            .replace('/', '_')
            .replace('\\', '_')
            .trim()
        return if (sanitized.isEmpty()) "document" else sanitized
    }

    private fun uniqueOutputFile(directory: File, requestedName: String): File {
        var candidate = File(directory, requestedName)
        if (!candidate.exists()) {
            return candidate
        }

        val baseName = requestedName.substringBeforeLast('.', requestedName)
        val extension = requestedName.substringAfterLast('.', "")
        var counter = 2
        while (candidate.exists()) {
            val nextName = if (extension.isEmpty()) {
                "${baseName}_$counter"
            } else {
                "${baseName}_$counter.$extension"
            }
            candidate = File(directory, nextName)
            counter++
        }
        return candidate
    }
}
