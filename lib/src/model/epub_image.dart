import 'const.dart';

class EpubImage {
  final List<int> bytes;
  final ImageMimeType type;
  final String? name;

  EpubImage({required this.bytes, required this.type, this.name});

  String get id => Object.hash(name, bytes).toRadixString(16);
  String get filename => '${name ?? id}.${type.extension}';
}
