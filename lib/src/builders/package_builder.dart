import 'package:xml/xml.dart' as xml;

import '../epub_defs.dart';
import '../util.dart';
import '../model/model.dart';

class PackageBuilder {
  final EpubBook book;
  late final xml.XmlBuilder builder;

  PackageBuilder(this.book) {
    builder = xml.XmlBuilder();
    builder.processing('xml', 'version="1.0"');
  }

  xml.XmlBuilder build() {
    final uid = book.metadata.identifier;
    builder.element(
      'package',
      namespaces: {EpubDefs.opfNS: null},
      attributes: {'version': '3.0', 'unique-identifier': uid}, // [1]
      nest: () {
        const dcUri = 'http://purl.org/dc/elements/1.1/';
        builder.element(
          'metadata',
          nest: () {
            builder.namespace(dcUri, 'dc');
            builder.element(
              'identifier',
              namespace: dcUri,
              attributes: {'id': uid},
            );
            builder.element('title', namespace: dcUri, nest: book.title);
            builder.element('language', namespace: dcUri, nest: 'en');

            for (final author in book.authors) {
              builder.element('creator', namespace: dcUri, nest: author);
            }

            final now = DateTime.now().toUtc();
            builder.element(
              'meta',
              attributes: {'property': 'dcterms:modified'},
              nest: now.toIsoString(),
            );
          },
        );
        manifest();
        spine();
      },
    );
    return builder;
  }

  // ----------------
  void manifest() {
    builder.element(
      'manifest',
      nest: () {
        for (var item in book.manifest) {
          print(item.id);
          builder.element('item', attributes: item.attributes);
        }
      },
    );
  }

  // ----------------

  void spine() {
    builder.element(
      'spine',
      attributes: {'toc': 'ncx'},
      nest: () {
        for (var i in book.spine) {
          builder.element('itemref', attributes: i.attributes);
        }

        for (var chapter in book.chapters) {
          spineItem(chapter);
        }
        if (book.navigationInSpine) {
          builder.element('itemref', attributes: {'idref': 'nav'});
        }
      },
    );
  }

  void spineItem(EpubChapter chapter) {
    final manifestItem = chapter.manifestItem;
    builder.element('itemref', attributes: {'idref': manifestItem.id});

    for (final child in chapter.children) {
      spineItem(child);
    }
  }
}
