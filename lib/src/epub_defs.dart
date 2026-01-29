import 'dart:convert';
import 'dart:math' as math;

class EpubDefs {
  /// Open Packaging Format namespace
  static const opfNS = 'http://www.idpf.org/2007/opf';

  /// Container file name
  static const containerPath = 'META-INF/container.xml';

  /// content root directory
  static const root = 'EPUB';

  /// opf file name
  static const opfArchPath = '$root/package.opf';

  static const navHref = 'nav.xhtml';
  static const cssHref = 'styles.css';
  static String textHref(String base) => 'xhtml/$base.xhtml';
  static String imageHref(String path) => 'images/$path';
  static String coverHref(String extension) => imageHref('cover.$extension');

  static const navArchPath = '$root/$navHref';
  static const cssArchPath = '$root/$cssHref';
  static String textArchPath(String base) => '$root/${textHref(base)}';
  static String imageArchPath(String path) => '$root/${imageHref(path)}';
  static String coverArchPath(String extension) =>
      '$root/${coverHref(extension)}';

  /// Container content
  static const containerContent =
      '''<?xml version="1.0" encoding="UTF-8"?>
<container xmlns="urn:oasis:names:tc:opendocument:xmlns:container" version="1.0">
   <rootfiles>
      <rootfile full-path="$opfArchPath" media-type="application/oebps-package+xml"/>
   </rootfiles>
</container>''';

  static int padNum(int length) => (math.log(length) / math.ln10).ceil();

  static String chapterName(int index, int width) =>
      '$index'.padLeft(width, '0');

  // transform text to XHTML
  static String textToBodyHtml(String text) {
    return text
        .split('\n')
        .map((line) => '<p>${HtmlEscape().convert(line.trim())}</p>')
        .join('\n\n');
  }

  // transform body Html content to XHTML file
  static String bodyToXhtml({
    required String title,
    required String body,
    String? id,
  }) {
    final idAttr = id != null ? ' id="$id"' : '';
    return '''<?xml version="1.0" encoding="utf-8"?>
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  <meta charset="utf-8"/>
  <title>$title</title>
  <link rel="stylesheet" href="../$cssHref">
</head>
<body>
  <h1$idAttr>$title</h1>
  $body
</body>
</html>
''';
  }
}
