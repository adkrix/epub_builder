import 'package:epub_builder/src/epub_defs.dart';
import 'package:xml/xml.dart' as xml;

import '../model/model.dart';

class NavigationBuilder {
  final EpubBook book;
  late final xml.XmlBuilder builder;

  NavigationBuilder(this.book) {
    builder = xml.XmlBuilder();
    builder.processing('xml', 'version="1.0"');
  }

  xml.XmlBuilder build() {
    builder.element(
      'html',
      namespaces: {
        'http://www.w3.org/1999/xhtml': null,
        'http://www.idpf.org/2007/ops': 'epub',
      },
      nest: () {
        builder.element(
          'head',
          nest: () {
            builder.element('meta', attributes: {'charset': 'utf-8'});
            builder.element('link', attributes: {'rel': 'stylesheet', 'href': EpubDefs.cssHref});
            builder.element('title', nest: book.title);
          },
        );
        builder.element(
          'body',
          nest: () {
            builder.element(
              'nav',
              // role="doc-toc" ??
              attributes: {'epub:type': 'toc', 'id': 'toc'},
              nest: () {
                if (book.navigationTitle is String &&
                    book.navigationTitle!.trim() != '') {
                  builder.element(
                    'h1',
                    attributes: {'class': 'title'},
                    nest: 'Table of Contents',
                  );
                }

                // outside ol
                chapterList(book.chapters);
              },
            );
          },
        );
      },
    );

    return builder;
  }

  void chapterList(List<EpubChapter> chapters) {
    builder.element(
      'ol',
      nest: () {
        for (var chapter in chapters) {
          listItem(chapter);
        }
      },
    );
  }

  void listItem(EpubChapter chapter) {
    builder.element(
      'li',
      nest: () {
        linkItem(chapter.hrefAnchor, chapter.title);

        if (chapter.anchors.isNotEmpty) {
          builder.element(
            'ol',
            nest: () {
              for (final anchor in chapter.anchors) {
                if (anchor.isEmpty) continue;
                builder.element(
                  'li',
                  nest: () {
                    linkItem('${chapter.href}#${anchor.hash}', anchor.title);
                  },
                );
              }
            },
          );
        }

        if (chapter.children.isNotEmpty) {
          chapterList(chapter.children);
        }
      },
    );
  }

  void linkItem(String href, String title) {
    builder.element('a', attributes: {'href': href}, nest: title);
  }
}
