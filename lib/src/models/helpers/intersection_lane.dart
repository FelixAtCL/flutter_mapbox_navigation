part of mapbox_navigation_flutter;

class IntersectionLane {
  final bool isActive;
  final List<String> indications;

  const IntersectionLane._({
    required this.isActive,
    required this.indications,
  });

  static IntersectionLane? fromAndroid(Map<String, dynamic>? json) =>
      json != null
          ? IntersectionLane._(
              isActive: bool.parse(json['active'].toString()),
              indications: (json['indications'] as List).cast<String>(),
            )
          : null;

  static IntersectionLane? fromIOS(Map<String, dynamic>? json, bool isActive) =>
      json != null
          ? IntersectionLane._(
              isActive: isActive,
              indications: [json['description'] as String],
            )
          : null;
}
