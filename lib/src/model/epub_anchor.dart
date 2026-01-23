class EpubAnchor {
  late final String _hash;
  late final String _title;
  EpubAnchor({required String hash, required String title}) {
    _hash = hash.trim();
    _title = title.trim();
  }
  String get hash => _hash;
  String get title => _title;
  bool get isEmpty => _hash.isEmpty || _title.isEmpty;
  bool get isNotEmpty => !isEmpty;
}
