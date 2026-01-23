import 'package:epub_builder/src/model/epub_anchor.dart';

import '../epub_defs.dart';
import 'manifest_item.dart';

class EpubChapter {
  String? _base;
  final String title;
  final String content;
  final List<EpubChapter> children;
  final List<EpubAnchor> anchors;

  String get html => EpubDefs.bodyToXhtml(title: title, body: content, id: id);
  String get _hash => Object.hash(title, content).toRadixString(16);
  String get id => 'ch_${_base ?? _hash}';
  set base(String val) => _base = val;
  String get base => _base ?? _hash;
  String get href => EpubDefs.textHref(base);
  String get hrefAnchor => '$href#$id';
  String get archpath => EpubDefs.textArchPath(base);

  int get childrenCount =>
      children.fold<int>(children.length, (prev, c) => prev + c.childrenCount);

  EpubChapter({
    required this.title,
    required this.content,
    this.children = const [],
    this.anchors = const [],
  });

  factory EpubChapter.fromBodyHtml(String title, String body) {
    return EpubChapter(title: title, content: body, anchors: [], children: []);
  }

  factory EpubChapter.fromBodyText(String title, String text) {
    final content = EpubDefs.textToBodyHtml(text);
    return EpubChapter(
      title: title,
      content: content,
      anchors: [],
      children: [],
    );
  }

  void addAnchor({required String title, required String hash}) {
    anchors.add(EpubAnchor(hash: hash, title: title));
  }

  /// Generate a manifest item if [EpubChapter] has content
  ManifestItem get manifestItem {
    return ManifestItem(id: id, href: href, mediaType: 'application/xhtml+xml');
  }

  List<ManifestItem> get manifestItems {
    final manifestItemList = <ManifestItem>[];
    final item = manifestItem;
    manifestItemList.add(item);

    for (var child in children) {
      manifestItemList.addAll(child.manifestItems);
    }
    return manifestItemList;
  }

  @override
  String toString() => 'Chapter($title, $href, $children)';
}
