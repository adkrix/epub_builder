import 'package:uuid/uuid.dart';

class Metadata {
  final String title;
  late final List<String> creators;
  late final String identifier;
  late final String language;

  Metadata(
    Map<dynamic, dynamic> map, {
    required this.title,
    required List<String> authors,
  }) {
    identifier = 'urn:uuid:${Uuid().v4()}';
    creators = authors.isNotEmpty ? authors : ['Epub Builder'];
  }

  factory Metadata.create(String title, List<String> authors) {
    final metadata = Metadata({}, title: title, authors: authors);
    return metadata;
  }
}
