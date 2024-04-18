part of mapbox_navigation_flutter;

class Intersection {
  final double latitude;
  final double longitude;
  final List<int> headings;
  final List<IntersectionLane?> lanes;

  const Intersection._({
    required this.latitude,
    required this.longitude,
    required this.headings,
    required this.lanes,
  });

  static Intersection? fromAndroid(Map<String, dynamic>? json) => json != null
      ? Intersection._(
          latitude: double.parse(
            ((json['location'] as Map<String, dynamic>)['coordinates'] as List)
                .skip(1)
                .first
                .toString(),
          ),
          longitude: double.parse(
            ((json['location'] as Map<String, dynamic>)['coordinates'] as List)
                .first
                .toString(),
          ),
          headings: (json['bearings'] as List).cast<int>(),
          lanes: (json['lanes'] as List)
              .map(
                (lane) =>
                    IntersectionLane.fromAndroid(lane as Map<String, dynamic>?),
              )
              .toList(),
        )
      : null;

  static Intersection? fromIOS(Map<String, dynamic>? json) {
    if (json == null) return null;
    final innerLanes = <IntersectionLane?>[];

    final usableApproachLaneIndices =
        (json['usableApproachLanes'] as List).cast<int>();

    final approachLines = json['approachLanes'] as List;
    for (var index = 0; index < approachLines.length; index++) {
      final isActive = usableApproachLaneIndices.contains(index);
      innerLanes.add(
        IntersectionLane.fromIOS(
            approachLines[index] as Map<String, dynamic>?, isActive),
      );
    }

    Intersection._(
        latitude: double.parse(
          (json['coordinate'] as Map<String, dynamic>)['latitude'].toString(),
        ),
        longitude: double.parse(
          (json['coordinate'] as Map<String, dynamic>)['longitude'].toString(),
        ),
        headings: (json['headings'] as List).cast<int>(),
        lanes: innerLanes);
  }
}
