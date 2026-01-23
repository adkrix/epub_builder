import 'dart:io';
import 'package:markdown/markdown.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

const srcDir = 'demo_book_src';
const manifestPath = '$srcDir/manifest.yaml';
const coverImagePath = '$srcDir/cover.jpeg';

class SrcManifest {
  final String title;
  final List<String> authors;
  SrcManifest({required this.title, required this.authors});
  Map<String, dynamic> toJson() => {'title': title, 'authors': authors};
}

SrcManifest loadManifest(String path) {
  final yamlStr = File('$path/manifest.yaml').readAsStringSync();

  final manifest = loadYaml(yamlStr) as YamlMap;
  if (manifest.isEmpty) {
    throw ArgumentError('Manifest must be Map<String, String>');
  }
  final authors = manifest['authors'] as YamlList;
  return SrcManifest(
    title: manifest['title'] ?? '',
    authors: authors.map((author) => author.toString()).toList(),
  );
}

class SrcContent {
  final String title;
  final String content;
  SrcContent({required this.title, required this.content});
}

List<SrcContent> loadChaptersSrc(String path) {
  final directory = Directory(path);
  final list = directory.listSync();
  list.sort((a, b) {
    return a.path.compareTo(b.path);
  });

  final List<SrcContent> chapterList = [];
  for (var fl in list) {
    print(fl.path);
    String title = '';
    String content = '';

    if (extension(fl.path) != '.md') continue;
    final mdFile = File(fl.path);
    final mdLines = mdFile.readAsStringSync().trim().split('\n');

    if (mdLines[0].substring(0, 2) == '# ') {
      title = mdLines[0].substring(2);
      content = markdownToHtml(mdLines.skip(1).join('\n'));
    } else {
      title = '***';
      content = markdownToHtml(mdLines.join('\n'));
    }

    chapterList.add(SrcContent(title: title, content: content));
  }
  return chapterList;
}

void saveResult(String destPath, List<int>? bytes) {
  if (bytes != null) {
    final file = File('../$destPath');
    file.writeAsBytesSync(bytes);
    print('\n-->\n$destPath');
  } else {
    print('Empty result');
  }
}
