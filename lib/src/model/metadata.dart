import 'package:uuid/uuid.dart';

class Metadata {
  final String title;
  late final List<String> creators;
  late final String _identifier;
  final String language;
  String? description;
  String? published;

  Metadata({
    required this.title,
    this.description,
    this.published,
    required List<String> authors,
    String? identifier,
    required this.language,
  }) {
    _identifier = identifier ?? 'urn:uuid:${Uuid().v4()}';
    creators = authors.isNotEmpty ? authors : ['Epub Builder'];
  }
  String get identifier => _identifier;

  factory Metadata.create(
    String title,
    List<String> authors, {
    String? description,
    String? published,
    String? identifier,
    String language = 'en',
  }) {
    final metadata = Metadata(
      title: title,
      authors: authors,
      description: description,
      published: published,
      identifier: identifier, // or your code
      language: language,
    );
    return metadata;
  }
}
