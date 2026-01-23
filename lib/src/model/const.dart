enum EpubVersion {
  /// epub2 2.0 2.0.1
  epub2,

  /// epub3 3.0 3.0.1 3.2
  epub3,
}

enum ImageMimeType {
  gif(extension: 'gif', mimeType: 'image/gif'),
  jpeg(extension: 'jpeg', mimeType: 'image/jpeg'),
  text(extension: 'png', mimeType: 'image/png'),
  textZip(extension: 'svg', mimeType: 'image/svg+xml'),
  html(extension: 'webp', mimeType: 'image/webp');

  final String mimeType;
  final String extension;
  const ImageMimeType({required this.mimeType, required this.extension});
}
