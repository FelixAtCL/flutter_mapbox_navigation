part of mapbox_navigation_flutter;

class Location {
  /// Constructor for [Location].
  Location({
    required this.coordinate,
    required this.course,
    required this.horizontalAccuracy,
    this.headingDirection,
    this.heading,
  });

  late Coordinate coordinate;
  late Heading? heading;
  late double course;
  late double horizontalAccuracy;
  late double? headingDirection;

  /// Creates a [Location] object from a JSON object
  Location.fromJson(Map<String, dynamic> json) {
    coordinate =
        Coordinate.fromJson(json['coordinate'] as Map<String, dynamic>);
    heading = json['heading'] != null
        ? Heading.fromJson(json['heading'] as Map<String, dynamic>)
        : null;
    course = json['course'] as double;
    horizontalAccuracy = json['horizontalAccuracy'] as double;
    headingDirection = json['headingDirection'] as double?;
  }
}
