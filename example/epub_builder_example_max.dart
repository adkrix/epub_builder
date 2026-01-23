import 'dart:io';

import 'package:epub_builder/epub_builder.dart';
import 'utils.dart';

const destPath = 'example_out/new-max.epub';
const srcDir = 'demo_book_src';
const manifestPath = '$srcDir/manifest.yaml';
const coverImagePath = '$srcDir/cover.jpeg';

List<EpubChapter> loadRichChapters(String path) {
  final list = loadChaptersSrc(path);

  return list.map((src) {
    final anchorHash = Object.hash(
      src.title.substring(1),
      src.content,
    ).toRadixString(16);
    final anchorTitle = 'Sub ${src.title}';
    final richContent =
        '''
    ${src.content}
    <!-- page-break -->
    <h2 id="$anchorHash" style="page-break-before: always">$anchorTitle</h2>
    ${src.content}
    ''';

    final chapter = EpubChapter.fromBodyHtml(src.title, richContent);
    chapter.addAnchor(title: anchorTitle, hash: anchorHash);
    return chapter;
  }).toList();
}

void main(List<String> args) {
  final manifest = loadManifest(srcDir);
  final cssContent = '''
  /* In navigation page: ordered list item with roman numbers */
  #toc ol {list-style-type: upper-roman;}
  #toc ol ol {list-style-type: lower-alpha;}
  /* all ordered list item - bold */
  ol li { font-weight:bold; }
  
  ''';

  final imageBytes = File(coverImagePath).readAsBytesSync();

  final book = EpubBook.create(
    title: manifest.title,
    authors: manifest.authors,
    cssContent: cssContent,
    coverImage: EpubImage(bytes: imageBytes, type: ImageMimeType.jpeg),
    navigationInSpine: true,
    navigationTitle: 'table of contents',
  );

  final chapters = loadRichChapters(srcDir);

  for (var chapter in chapters) {
    book.addChapter(chapter);
  }

  final bytes = EpubBuilder(book).encode();
  saveResult(destPath, bytes);
}
