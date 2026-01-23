class ManifestItem {
  final String id;
  final String href;
  final String mediaType;
  final String? mediaOverlay;
  final String? fallback;
  final String? properties;

  const ManifestItem({
    required this.id,
    required this.href,
    required this.mediaType,
    this.mediaOverlay,
    this.fallback,
    this.properties,
  });

  /// return attributes in building xml
  Map<String, String> get attributes {
    return {
      'id': id,
      'href': href,
      'media-type': mediaType,
      if (mediaOverlay != null) 'media-overlay': mediaOverlay!,
      if (fallback != null) 'fallback': fallback!,
      if (properties != null) 'properties': properties!,
    };
  }

  @override
  String toString() => 'ManifestItem($id, $mediaType, $href)';
}
