import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:xml/xml.dart' as xml;

import 'builders/builders.dart';
import 'epub_defs.dart';
import 'model/model.dart';

///
class EpubBuilder {
  final EpubBook book;
  final bool pretty;
  const EpubBuilder(this.book, {this.pretty = true});

  List<int>? encode() {
    final archive = Archive();
    _write(archive);
    return ZipEncoder().encode(archive);
  }

  void _write(Archive archive) {
    //   mimetype
    archive.addFile(_mimetype());

    // META-INF/container.xml
    archive.addFile(
      ArchiveFile.string(EpubDefs.containerPath, EpubDefs.containerContent),
    );

    ///   EPUB/nav.xhtml
    final nav = ManifestItem(
      id: 'nav',
      href: EpubDefs.navHref,
      mediaType: 'application/xhtml+xml',
      properties: 'nav',
    );
    book.manifest.add(nav);

    /// css
    _anifestCss();

    /// cover-image
    final coverImageFiles = _addCoverImage();

    // EPUB/package.opf
    archive.addFile(
      _xmlFile(EpubDefs.opfArchPath, PackageBuilder(book).build()),
    );

    // EPUB/xhtml/*
    final fileNameSet = <String>{};
    for (var ch in book.chapters) {
      _writeChapter(archive, ch, fileNameSet);
    }

    archive.addFile(ArchiveFile.string(EpubDefs.cssArchPath, book.cssContent));

    for (final archFile in coverImageFiles) {
      archive.addFile(archFile);
    }

    archive.addFile(
      _xmlFile(EpubDefs.navArchPath, NavigationBuilder(book).build()),
    );
  }

  ArchiveFile _mimetype() {
    return ArchiveFile.noCompress(
      'mimetype',
      20,
      utf8.encode('application/epub+zip'),
    );
  }

  void _writeChapter(
    Archive archive,
    EpubChapter chapter,
    Set<String> fileNameSet,
  ) {
    final fileHref = chapter.manifestItem.href;
    if (!fileNameSet.contains(fileHref)) {
      archive.addFile(ArchiveFile.string(chapter.archpath, chapter.html));
      fileNameSet.add(fileHref);
    }

    for (var subChapter in chapter.children) {
      _writeChapter(archive, subChapter, fileNameSet);
    }
  }

  ArchiveFile _xmlFile(String name, xml.XmlBuilder builder) {
    final bytes = utf8.encode(
      builder.buildDocument().toXmlString(pretty: pretty),
    );
    return ArchiveFile(name, bytes.length, bytes);
  }

  void _anifestCss() {
    final css = ManifestItem(
      id: 'css',
      href: EpubDefs.cssHref,
      mediaType: 'text/css',
    );
    book.manifest.add(css);
  }

  List<ArchiveFile> _addCoverImage() {
    final coverImage = book.coverImage;
    if (coverImage == null) return [];
    final coverManifestItem = ManifestItem(
      id: 'cover-image',
      href: EpubDefs.coverHref(coverImage.type.extension),
      mediaType: coverImage.type.mimeType,
      properties: 'cover-image',
    );

    final coverPageManifestItem = ManifestItem(
      id: 'cover-image-page',
      href: EpubDefs.textHref('00-title'),
      mediaType: 'application/xhtml+xml',
    );

    book.spine.add(SpineItem(idref: coverPageManifestItem.id));

    book.manifest.add(coverManifestItem);

    book.manifest.add(coverPageManifestItem);

    return [
      ArchiveFile.bytes(
        EpubDefs.coverArchPath(coverImage.type.extension),
        coverImage.bytes,
      ),
      ArchiveFile.string(
        EpubDefs.textArchPath('00-title'),
        EpubDefs.bodyToXhtml(
          title: '',
          body:
              '''<img src="../${coverManifestItem.href}" alt="Cover image"/>
          <h1>${book.title}</h1>
          ${book.authors.map((author) => '<h2>$author</h2>').join()}
          ''',
        ),
      ),
    ];
  }
}
