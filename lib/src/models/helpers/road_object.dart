part of mapbox_navigation_flutter;

class RoadObject {
  final String id;
  final double length;
  final String kind;
  final bool isUrban;
  final Geometry? geometry;

  const RoadObject._({
    required this.id,
    required this.length,
    required this.geometry,
    required this.isUrban,
    required this.kind,
  });

  static RoadObject? fromAndroid(Map<String, dynamic>? json) => json != null
      ? RoadObject._(
          id: json['id'] as String,
          length: double.parse(json['length'].toString()),
          kind: json['objectType'] as String,
          isUrban: bool.parse(json['isUrban'].toString()),
          geometry: Geometry.fromAndroid(['location'] as Map<String, dynamic>),
        )
      : null;

  static RoadObject? fromIOS(Map<String, dynamic>? json) => json != null
      ? RoadObject._(
          id: json['identifier'] as String,
          length: double.parse(json['length'].toString()),
          kind: json['kind'] as String,
          isUrban: bool.parse(json['isUrban'].toString()),
          geometry: Geometry.fromIOS(json['location'] as Map<String, dynamic>),
        )
      : null;
}
