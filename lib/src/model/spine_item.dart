/// Spine ItemRef
class SpineItem {
  final String idref;
  final bool? linear;
  const SpineItem({required this.idref, this.linear});

  /// return attributes in building xml
  Map<String, String> get attributes {
    return {
      if (linear != null) 'linear': linear! ? 'yes' : 'no',
      'idref': idref,
    };
  }
}
