part of mapbox_navigation_flutter;

class RouteOptions {
  final double maximumHeight;
  final double maximumWidth;
  final double maximumWeight;

  final DateTime? arriveBy;
  final DateTime? departAt;

  const RouteOptions._({
    required this.maximumHeight,
    required this.maximumWeight,
    required this.maximumWidth,
    this.arriveBy,
    this.departAt,
  });

  static RouteOptions? fromAndroid(Map<String, dynamic>? json) => json != null
      ? RouteOptions._(
          arriveBy: DateTime.tryParse(json['arriveBy'] as String),
          departAt: DateTime.tryParse(json['departAt'] as String),
          maximumHeight: double.parse(json['maxHeight'].toString()),
          maximumWidth: double.parse(json['maxWidth'].toString()),
          maximumWeight: double.parse(json['maxWeight'].toString()),
        )
      : null;

  static RouteOptions? fromIOS(Map<String, dynamic>? json) => json != null
      ? RouteOptions._(
          arriveBy: DateTime.tryParse(json['arriveBy'] as String),
          departAt: DateTime.tryParse(json['departAt'] as String),
          maximumHeight: double.parse(json['maximumHeight'].toString()),
          maximumWidth: double.parse(json['maximumWidth'].toString()),
          maximumWeight: double.parse(json['maximumWeight'].toString()),
        )
      : null;
}
