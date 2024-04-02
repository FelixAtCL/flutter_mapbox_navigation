part of mapbox_navigation_flutter;

/// Represents the heading of the device.
class Heading {
  /// Constructor for [Heading].
  Heading({
    required this.trueHeading,
    required this.magneticHeading,
    required this.headingAccuracy,
  });

  /// Creates a [Heading] object from a JSON object
  Heading.fromJson(Map<String, dynamic> json) {
    trueHeading = json['trueHeading'] as double;
    magneticHeading = json['magneticHeading'] as double;
    headingAccuracy = json['headingAccuracy'] as double;
  }

  late double trueHeading;
  late double magneticHeading;
  late double headingAccuracy;
}
