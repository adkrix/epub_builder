import 'package:xml/xml.dart' as xml;

import '../epub_defs.dart';
import '../util.dart';
import '../model/model.dart';

/// Package opf xml file builder
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
      attributes: {'version': '3.0', 'unique-identifier': 'pub-identifier'},
      nest: () {
        const dcUri = 'http://purl.org/dc/elements/1.1/';
        builder.element(
          'metadata',
          nest: () {
            builder.namespace(dcUri, 'dc');
            builder.element(
              'identifier',
              namespace: dcUri,
              attributes: {'id': 'pub-identifier'},
              nest: uid,
            );
            builder.element('title', namespace: dcUri, nest: book.title);
            if (book.description != null) {
              builder.element(
                'description',
                namespace: dcUri,
                nest: book.description,
              );
            }

            builder.element('language', namespace: dcUri, nest: book.language);

            for (final author in book.authors) {
              builder.element('creator', namespace: dcUri, nest: author);
            }

            final now = DateTime.now().toUtc();

            if (book.published != null) {
              builder.element('date', namespace: dcUri, nest: book.published);
            }

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
          builder.element('item', attributes: item.attributes);
        }
      },
    );
  }

  // ----------------

  void spine() {
    builder.element(
      'spine',
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
