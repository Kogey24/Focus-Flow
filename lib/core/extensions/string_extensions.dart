extension StringExtensions on String {
  String toTitleCase() {
    if (trim().isEmpty) return this;
    return split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map((word) {
          final lower = word.toLowerCase();
          return '${lower[0].toUpperCase()}${lower.substring(1)}';
        })
        .join(' ');
  }

  String filenameLabel() {
    return replaceAll(RegExp(r'[_\-]+'), ' ')
        .replaceAll(RegExp(r'\.[A-Za-z0-9]+$'), '')
        .toTitleCase();
  }
}
