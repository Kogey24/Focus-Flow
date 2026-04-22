package com.example.focus_flow

import com.tom_roush.pdfbox.pdmodel.PDDocument
import com.tom_roush.pdfbox.text.PDFTextStripper
import com.tom_roush.pdfbox.text.TextPosition
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.OutputStreamWriter
import kotlin.math.abs

object PdfTableOfContentsExtractor {
    private val tocLinePattern = Regex(
        pattern = """^(.*?)(?:\s+|\.{2,})([0-9]+|[ivxlcdm]+)$""",
        options = setOf(RegexOption.IGNORE_CASE)
    )
    private val tocHeadingPattern = Regex(
        pattern = """^(contents|table of contents)\b""",
        options = setOf(RegexOption.IGNORE_CASE)
    )
    private val partPattern = Regex(
        pattern = """^part\b""",
        options = setOf(RegexOption.IGNORE_CASE)
    )
    private val chapterPattern = Regex(
        pattern = """^chapter\b""",
        options = setOf(RegexOption.IGNORE_CASE)
    )
    private val prefixPattern = Regex(
        pattern = """^(part|chapter|appendix|section)\s+[a-z0-9ivxlcdm._-]+\s*[:.-]?\s*""",
        options = setOf(RegexOption.IGNORE_CASE)
    )

    fun extract(filePath: String): List<Map<String, Any>> {
        PDDocument.load(File(filePath)).use { document ->
            val stripper = PositionedPageStripper()
            val scannedPages = (1..minOf(document.numberOfPages, 30))
                .map { pageIndex ->
                    ExtractedPage(
                        pageIndex = pageIndex,
                        lines = stripper.extract(document, pageIndex)
                    )
                }

            val tocPages = detectTocPages(scannedPages)
            if (tocPages.isEmpty()) return emptyList()

            val rawEntries = parseTocEntries(tocPages.flatMap { it.lines })
            if (rawEntries.isEmpty()) return emptyList()

            val searchStartPage = tocPages.last().pageIndex + 1
            if (searchStartPage > document.numberOfPages) return emptyList()

            val searchPages = (searchStartPage..document.numberOfPages)
                .map { pageIndex ->
                    val lines = stripper.extract(document, pageIndex)
                    PageSearchText(
                        pageIndex = pageIndex,
                        topText = normalize(lines.take(18).joinToString(" ") { it.text }),
                        fullText = normalize(lines.joinToString(" ") { it.text })
                    )
                }

            val resolvedEntries = resolvePageStarts(rawEntries, searchPages).toMutableList()
            fillParentPageStarts(resolvedEntries)

            return resolvedEntries
                .filter { it.pageStart != null }
                .map { entry ->
                    hashMapOf(
                        "title" to entry.title,
                        "level" to entry.level,
                        "pageStart" to entry.pageStart!!
                    )
                }
        }
    }

    private fun detectTocPages(pages: List<ExtractedPage>): List<ExtractedPage> {
        val tocPages = mutableListOf<ExtractedPage>()
        var started = false

        for (page in pages) {
            val candidateLines = page.lines.count { isTocLine(it.text) }
            val hasHeading = page.lines.any { tocHeadingPattern.containsMatchIn(it.text.trim()) }
            val looksLikeToc = hasHeading || candidateLines >= 5

            if (!started) {
                if (looksLikeToc) {
                    started = true
                    tocPages.add(page)
                }
                continue
            }

            if (candidateLines >= 3 || hasHeading) {
                tocPages.add(page)
            } else {
                break
            }
        }

        return tocPages
    }

    private fun parseTocEntries(lines: List<ExtractedLine>): List<ParsedTocEntry> {
        val anchors = mutableListOf<Float>()
        val entries = mutableListOf<ParsedTocEntry>()

        for (line in lines.sortedWith(compareBy({ it.pageIndex }, { it.y }, { it.x }))) {
            val match = tocLinePattern.find(line.text.trim()) ?: continue
            val title = match.groupValues[1]
                .replace(Regex("""\.{2,}"""), " ")
                .replace(Regex("""\s+"""), " ")
                .trim()

            if (title.length < 2 || tocHeadingPattern.containsMatchIn(title)) {
                continue
            }

            val indent = anchorIndent(anchors, line.x)
            val level = when {
                partPattern.containsMatchIn(title) -> 0
                chapterPattern.containsMatchIn(title) -> if (entries.any { partPattern.containsMatchIn(it.title) }) 1 else 0
                else -> inferLevel(entries, indent)
            }

            entries.add(
                ParsedTocEntry(
                    title = title,
                    level = level,
                    indent = indent
                )
            )
        }

        val firstMainIndex = entries.indexOfFirst { entry ->
            partPattern.containsMatchIn(entry.title) || chapterPattern.containsMatchIn(entry.title)
        }

        return if (firstMainIndex > 0) {
            entries.subList(firstMainIndex, entries.size)
        } else {
            entries
        }
    }

    private fun anchorIndent(anchors: MutableList<Float>, x: Float): Float {
        val existing = anchors.firstOrNull { abs(it - x) <= 12f }
        if (existing != null) return existing

        anchors.add(x)
        anchors.sort()
        return x
    }

    private fun inferLevel(entries: List<ParsedTocEntry>, indent: Float): Int {
        val parent = entries.asReversed().firstOrNull { it.indent + 6f < indent }
        return (parent?.level ?: -1) + 1
    }

    private fun resolvePageStarts(
        entries: List<ParsedTocEntry>,
        pages: List<PageSearchText>
    ): List<ResolvedTocEntry> {
        val resolved = mutableListOf<ResolvedTocEntry>()
        var searchStartIndex = 0

        for (entry in entries) {
            val terms = buildSearchTerms(entry.title)
            var matchedPage: Int? = null

            for (pageIndex in searchStartIndex until pages.size) {
                val page = pages[pageIndex]
                if (terms.any { term -> page.topText.contains(term) || page.fullText.contains(term) }) {
                    matchedPage = page.pageIndex
                    searchStartIndex = pageIndex
                    break
                }
            }

            resolved.add(
                ResolvedTocEntry(
                    title = entry.title,
                    level = entry.level,
                    pageStart = matchedPage
                )
            )
        }

        return resolved
    }

    private fun fillParentPageStarts(entries: MutableList<ResolvedTocEntry>) {
        for (index in entries.indices.reversed()) {
            if (entries[index].pageStart != null) continue

            for (cursor in index + 1 until entries.size) {
                val candidate = entries[cursor]
                if (candidate.level <= entries[index].level) break
                if (candidate.pageStart != null) {
                    entries[index].pageStart = candidate.pageStart
                    break
                }
            }
        }
    }

    private fun buildSearchTerms(title: String): List<String> {
        val rawTerms = listOf(
            title,
            title.replace(prefixPattern, ""),
            title.replace(Regex("""[:?!.]"""), " ")
        )

        return rawTerms
            .map(::normalize)
            .filter { it.length >= 4 }
            .distinct()
    }

    private fun isTocLine(text: String): Boolean {
        return tocLinePattern.containsMatchIn(text.trim())
    }

    private fun normalize(text: String): String {
        return text
            .lowercase()
            .replace(Regex("""[^a-z0-9\s]"""), " ")
            .replace(Regex("""\s+"""), " ")
            .trim()
    }
}

private class PositionedPageStripper : PDFTextStripper() {
    private val segments = mutableListOf<TextSegment>()

    init {
        sortByPosition = true
    }

    fun extract(document: PDDocument, pageIndex: Int): List<ExtractedLine> {
        segments.clear()
        startPage = pageIndex
        endPage = pageIndex
        writeText(document, OutputStreamWriter(ByteArrayOutputStream()))

        val sorted = segments.sortedWith(compareBy<TextSegment> { it.y }.thenBy { it.x })
        val lineGroups = mutableListOf<MutableList<TextSegment>>()

        for (segment in sorted) {
            val group = lineGroups.lastOrNull()
            if (group != null && abs(group.first().y - segment.y) <= 3.5f) {
                group.add(segment)
            } else {
                lineGroups.add(mutableListOf(segment))
            }
        }

        return lineGroups
            .map { group ->
                val ordered = group.sortedBy { it.x }
                ExtractedLine(
                    pageIndex = pageIndex,
                    text = ordered.joinToString(" ") { it.text }
                        .replace(Regex("""\s+"""), " ")
                        .trim(),
                    x = ordered.minOf { it.x },
                    y = ordered.minOf { it.y }
                )
            }
            .filter { it.text.isNotBlank() }
    }

    override fun writeString(text: String, textPositions: MutableList<TextPosition>) {
        val cleaned = text.replace(Regex("""\s+"""), " ").trim()
        if (cleaned.isBlank() || textPositions.isEmpty()) return

        segments.add(
            TextSegment(
                text = cleaned,
                x = textPositions.minOf { it.xDirAdj },
                y = textPositions.minOf { it.yDirAdj }
            )
        )
    }
}

private data class TextSegment(
    val text: String,
    val x: Float,
    val y: Float
)

private data class ExtractedLine(
    val pageIndex: Int,
    val text: String,
    val x: Float,
    val y: Float
)

private data class ExtractedPage(
    val pageIndex: Int,
    val lines: List<ExtractedLine>
)

private data class PageSearchText(
    val pageIndex: Int,
    val topText: String,
    val fullText: String
)

private data class ParsedTocEntry(
    val title: String,
    val level: Int,
    val indent: Float
)

private data class ResolvedTocEntry(
    val title: String,
    val level: Int,
    var pageStart: Int?
)
