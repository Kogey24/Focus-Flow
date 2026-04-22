package com.example.focus_flow

import android.content.Context
import android.net.Uri
import androidx.documentfile.provider.DocumentFile
import java.io.File
import java.io.FileOutputStream

object MediaFolderImporter {
    fun importFromTree(
        context: Context,
        treeUri: Uri,
        allowedExtensions: Set<String>,
        mediaType: String,
    ): Map<String, Any> {
        val root = DocumentFile.fromTreeUri(context, treeUri)
            ?: throw IllegalStateException("Unable to open the selected folder.")
        val folderName = sanitizeSegment(root.name ?: "Imported folder")
        val sessionRoot = File(
            context.cacheDir,
            "folder_imports/${System.currentTimeMillis()}/$folderName"
        )
        if (!sessionRoot.exists()) {
            sessionRoot.mkdirs()
        }

        val copiedFiles = mutableListOf<String>()
        var totalFiles = 0
        copyMatchingFiles(
            context = context,
            current = root,
            targetRoot = sessionRoot,
            relativeParent = "",
            allowedExtensions = allowedExtensions.map { it.lowercase() }.toSet(),
            mediaType = mediaType.lowercase(),
            copiedFiles = copiedFiles,
            onFileEncountered = { totalFiles++ },
        )

        return mapOf(
            "folderName" to folderName,
            "rootPath" to sessionRoot.absolutePath,
            "files" to copiedFiles,
            "ignoredFilesCount" to (totalFiles - copiedFiles.size),
        )
    }

    private fun copyMatchingFiles(
        context: Context,
        current: DocumentFile,
        targetRoot: File,
        relativeParent: String,
        allowedExtensions: Set<String>,
        mediaType: String,
        copiedFiles: MutableList<String>,
        onFileEncountered: () -> Unit,
    ) {
        for (child in current.listFiles()) {
            val childName = sanitizeSegment(child.name ?: continue)
            val childRelativePath =
                if (relativeParent.isEmpty()) childName else "$relativeParent/$childName"

            when {
                child.isDirectory -> copyMatchingFiles(
                    context = context,
                    current = child,
                    targetRoot = targetRoot,
                    relativeParent = childRelativePath,
                    allowedExtensions = allowedExtensions,
                    mediaType = mediaType,
                    copiedFiles = copiedFiles,
                    onFileEncountered = onFileEncountered,
                )

                child.isFile -> {
                    onFileEncountered()
                    if (!isAllowedFile(
                            context = context,
                            uri = child.uri,
                            fileName = childName,
                            allowedExtensions = allowedExtensions,
                            mediaType = mediaType,
                        )
                    ) {
                        continue
                    }

                    val outputFile = File(targetRoot, childRelativePath)
                    outputFile.parentFile?.mkdirs()
                    val inputStream = context.contentResolver.openInputStream(child.uri) ?: continue
                    inputStream.use { input ->
                        FileOutputStream(outputFile).use { output ->
                            input.copyTo(output)
                        }
                    }
                    copiedFiles.add(outputFile.absolutePath)
                }
            }
        }
    }

    private fun isAllowedFile(
        context: Context,
        uri: Uri,
        fileName: String,
        allowedExtensions: Set<String>,
        mediaType: String,
    ): Boolean {
        val extension = fileName.substringAfterLast('.', "").lowercase()
        if (extension.isNotEmpty() && extension in allowedExtensions) {
            return true
        }

        val mimeType = context.contentResolver.getType(uri)?.lowercase() ?: return false
        return mimeType.startsWith("$mediaType/")
    }

    private fun sanitizeSegment(segment: String): String {
        return segment.replace('/', '_').replace('\\', '_')
    }
}
