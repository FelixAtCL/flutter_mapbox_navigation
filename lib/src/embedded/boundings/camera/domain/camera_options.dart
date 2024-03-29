part of mapbox_navigation_flutter;

/// Various options for describing the viewpoint of a camera. All fields are
/// optional.
///
/// Anchor and center points are mutually exclusive, with preference for the
/// center point when both are set.
class CameraOptions {
  CameraOptions({
    this.center,
    this.padding,
    this.anchor,
    this.zoom,
    this.bearing,
    this.pitch,
  });

  /// Coordinate at the center of the camera.
  Map<String?, Object?>? center;

  /// Padding around the interior of the view that affects the frame of
  /// reference for `center`.
  MbxEdgeInsets? padding;

  /// Point of reference for `zoom` and `angle`, assuming an origin at the
  /// top-left corner of the view.
  ScreenCoordinate? anchor;

  /// Zero-based zoom level. Constrained to the minimum and maximum zoom
  /// levels.
  double? zoom;

  /// Bearing, measured in degrees from true north. Wrapped to [0, 360).
  double? bearing;

  /// Pitch toward the horizon measured in degrees.
  double? pitch;

  Object encode() {
    return <Object?>[
      center,
      padding?.encode(),
      anchor?.encode(),
      zoom,
      bearing,
      pitch,
    ];
  }

  static CameraOptions decode(Object result) {
    result as List<Object?>;
    return CameraOptions(
      center: (result[0] as Map<Object?, Object?>?)?.cast<String?, Object?>(),
      padding: result[1] != null
          ? MbxEdgeInsets.decode(result[1]! as List<Object?>)
          : null,
      anchor: result[2] != null
          ? ScreenCoordinate.decode(result[2]! as List<Object?>)
          : null,
      zoom: result[3] as double?,
      bearing: result[4] as double?,
      pitch: result[5] as double?,
    );
  }
}
