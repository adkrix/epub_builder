import 'manifest_item.dart';
import 'epub_chapter.dart';
import 'epub_image.dart';
import 'spine_item.dart';
import 'metadata.dart';

class EpubBook {
  final List<ManifestItem> manifest;
  final Metadata metadata;
  final List<SpineItem> spine;
  final List<EpubChapter> chapters;
  final String? navigationTitle;
  final String cssContent;
  final EpubImage? coverImage;
  final bool navigationInSpine;

  EpubBook({
    required this.manifest,
    required this.metadata,
    required this.spine,
    required this.chapters,
    this.navigationTitle,
    this.cssContent = '',
    this.coverImage,
    this.navigationInSpine = false,
  });

  /// Create an empty book
  factory EpubBook.create({
    required String title,
    required List<String> authors,
    String cssContent = '',
    EpubImage? coverImage,
    String? navigationTitle,
    bool navigationInSpine = false,
  }) {
    return EpubBook(
      manifest: <ManifestItem>[],
      metadata: Metadata.create(title, authors),
      spine: <SpineItem>[],
      chapters: <EpubChapter>[],
      cssContent: cssContent,
      coverImage: coverImage,
      navigationTitle: navigationTitle,
      navigationInSpine: navigationInSpine,
    );
  }

  void addChapter(EpubChapter chapter) {
    chapters.add(chapter);
    manifest.addAll(chapter.manifestItems);
  }

  String get identifier => metadata.identifier;
  String get title => metadata.title;
  List<String> get authors => metadata.creators;
}
