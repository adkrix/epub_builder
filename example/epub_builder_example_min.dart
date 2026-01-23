import 'package:epub_builder/epub_builder.dart';

import 'utils.dart';

const destPath = 'example_out/new-min.epub';
const srcDir = 'demo_book_src';
const manifestPath = '$srcDir/manifest.yaml';
const coverImagePath = '$srcDir/cover.jpeg';

void main(List<String> args) {
  final manifest = loadManifest(srcDir);

  final book = EpubBook.create(
    title: manifest.title,
    authors: manifest.authors,
  );

  final list = loadChaptersSrc(srcDir);

  final chapters = list
      .map((src) => EpubChapter.fromBodyHtml(src.title, src.content))
      .toList();

  for (var chapter in chapters) {
    book.addChapter(chapter);
  }

  final bytes = EpubBuilder(book).encode();
  saveResult(destPath, bytes);
}
