# PdfBox-Android references a JPEG2000 decoder that is optional for our use.
# Release shrinking fails without suppressing that optional class warning.
-dontwarn com.gemalto.jp2.JP2Decoder
