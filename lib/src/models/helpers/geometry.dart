part of mapbox_navigation_flutter;

class Geometry {
  final String type;
  final dynamic data;

  const Geometry._({required this.type, required this.data});

  static Geometry? fromAndroid(Map<String, dynamic>? json) => json != null
      ? Geometry._(type: json['type'] as String, data: json['geometry'])
      : null;

  static Geometry? fromIOS(Map<String, dynamic>? json) {
    print("This is the json for ios geometry: $json");
    throw Exception('Not implemented yet!');
  }
}
