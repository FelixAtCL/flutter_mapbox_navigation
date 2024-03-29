part of mapbox_navigation_flutter;

/// Describes the coordinate on the screen, measured from top to bottom and from left to right.
/// Note: the `map` uses screen coordinate units measured in `logical pixels`.
class ScreenCoordinate {
  ScreenCoordinate({
    required this.x,
    required this.y,
  });

  /// A value representing the x position of this coordinate.
  double x;

  /// A value representing the y position of this coordinate.
  double y;

  Object encode() {
    return <Object?>[
      x,
      y,
    ];
  }

  static ScreenCoordinate decode(Object result) {
    result as List<Object?>;
    return ScreenCoordinate(
      x: result[0]! as double,
      y: result[1]! as double,
    );
  }
}
