// This file is generated.
part of mapbox_navigation_flutter;

/// Location Indicator layer.
class LocationIndicatorLayer extends Layer {
  LocationIndicatorLayer({
    required super.id,
    super.visibility,
    super.minZoom,
    super.maxZoom,
    this.bearingImage,
    this.shadowImage,
    this.topImage,
    this.accuracyRadius,
    this.accuracyRadiusBorderColor,
    this.accuracyRadiusColor,
    this.bearing,
    this.bearingImageSize,
    this.emphasisCircleColor,
    this.emphasisCircleRadius,
    this.imagePitchDisplacement,
    this.location,
    this.perspectiveCompensation,
    this.shadowImageSize,
    this.topImageSize,
  });

  @override
  String getType() => "location-indicator";

  /// Name of image in sprite to use as the middle of the location indicator.
  String? bearingImage;

  /// Name of image in sprite to use as the background of the location indicator.
  String? shadowImage;

  /// Name of image in sprite to use as the top of the location indicator.
  String? topImage;

  /// The accuracy, in meters, of the position source used to retrieve the position of the location indicator.
  double? accuracyRadius;

  /// The color for drawing the accuracy radius border. To adjust transparency, set the alpha component of the color accordingly.
  int? accuracyRadiusBorderColor;

  /// The color for drawing the accuracy radius, as a circle. To adjust transparency, set the alpha component of the color accordingly.
  int? accuracyRadiusColor;

  /// The bearing of the location indicator.
  double? bearing;

  /// The size of the bearing image, as a scale factor applied to the size of the specified image.
  double? bearingImageSize;

  /// The color of the circle emphasizing the indicator. To adjust transparency, set the alpha component of the color accordingly.
  int? emphasisCircleColor;

  /// The radius, in pixel, of the circle emphasizing the indicator, drawn between the accuracy radius and the indicator shadow.
  double? emphasisCircleRadius;

  /// The displacement off the center of the top image and the shadow image when the pitch of the map is greater than 0. This helps producing a three-dimensional appearence.
  double? imagePitchDisplacement;

  /// An array of [latitude, longitude, altitude] position of the location indicator.
  List<double?>? location;

  /// The amount of the perspective compensation, between 0 and 1. A value of 1 produces a location indicator of constant width across the screen. A value of 0 makes it scale naturally according to the viewing projection.
  double? perspectiveCompensation;

  /// The size of the shadow image, as a scale factor applied to the size of the specified image.
  double? shadowImageSize;

  /// The size of the top image, as a scale factor applied to the size of the specified image.
  double? topImageSize;

  @override
  String _encode() {
    var layout = {};
    if (visibility != null) {
      layout["visibility"] =
          visibility?.toString().split('.').last.toLowerCase();
    }
    if (bearingImage != null) {
      layout["bearing-image"] = bearingImage;
    }
    if (shadowImage != null) {
      layout["shadow-image"] = shadowImage;
    }
    if (topImage != null) {
      layout["top-image"] = topImage;
    }
    var paint = {};
    if (accuracyRadius != null) {
      paint["accuracy-radius"] = accuracyRadius;
    }
    if (accuracyRadiusBorderColor != null) {
      paint["accuracy-radius-border-color"] =
          accuracyRadiusBorderColor?.toRGBA();
    }
    if (accuracyRadiusColor != null) {
      paint["accuracy-radius-color"] = accuracyRadiusColor?.toRGBA();
    }
    if (bearing != null) {
      paint["bearing"] = bearing;
    }
    if (bearingImageSize != null) {
      paint["bearing-image-size"] = bearingImageSize;
    }
    if (emphasisCircleColor != null) {
      paint["emphasis-circle-color"] = emphasisCircleColor?.toRGBA();
    }
    if (emphasisCircleRadius != null) {
      paint["emphasis-circle-radius"] = emphasisCircleRadius;
    }
    if (imagePitchDisplacement != null) {
      paint["image-pitch-displacement"] = imagePitchDisplacement;
    }
    if (location != null) {
      paint["location"] = location;
    }
    if (perspectiveCompensation != null) {
      paint["perspective-compensation"] = perspectiveCompensation;
    }
    if (shadowImageSize != null) {
      paint["shadow-image-size"] = shadowImageSize;
    }
    if (topImageSize != null) {
      paint["top-image-size"] = topImageSize;
    }
    var properties = {
      "id": id,
      "type": getType(),
      "layout": layout,
      "paint": paint,
    };
    if (minZoom != null) {
      properties["minzoom"] = minZoom!;
    }
    if (maxZoom != null) {
      properties["maxzoom"] = maxZoom!;
    }

    return json.encode(properties);
  }

  static LocationIndicatorLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return LocationIndicatorLayer(
      id: map["id"] as String? ?? '',
      minZoom: (map["minzoom"] as num?)?.toDouble(),
      maxZoom: (map["maxzoom"] as num?)?.toDouble(),
      visibility: map["layout"]["visibility"] == null
          ? Visibility.VISIBLE
          : Visibility.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["layout"]["visibility"] as String)),
      bearingImage: map["layout"]["bearing-image"] is String?
          ? map["layout"]["bearing-image"] as String?
          : null,
      shadowImage: map["layout"]["shadow-image"] is String?
          ? map["layout"]["shadow-image"] as String?
          : null,
      topImage: map["layout"]["top-image"] is String?
          ? map["layout"]["top-image"] as String?
          : null,
      accuracyRadius: map["paint"]["accuracy-radius"] is num?
          ? (map["paint"]["accuracy-radius"] as num?)?.toDouble()
          : null,
      accuracyRadiusBorderColor:
          (map["paint"]["accuracy-radius-border-color"] as List?)?.toRGBAInt(),
      accuracyRadiusColor:
          (map["paint"]["accuracy-radius-color"] as List?)?.toRGBAInt(),
      bearing: map["paint"]["bearing"] is num?
          ? (map["paint"]["bearing"] as num?)?.toDouble()
          : null,
      bearingImageSize: map["paint"]["bearing-image-size"] is num?
          ? (map["paint"]["bearing-image-size"] as num?)?.toDouble()
          : null,
      emphasisCircleColor:
          (map["paint"]["emphasis-circle-color"] as List?)?.toRGBAInt(),
      emphasisCircleRadius: map["paint"]["emphasis-circle-radius"] is num?
          ? (map["paint"]["emphasis-circle-radius"] as num?)?.toDouble()
          : null,
      imagePitchDisplacement: map["paint"]["image-pitch-displacement"] is num?
          ? (map["paint"]["image-pitch-displacement"] as num?)?.toDouble()
          : null,
      location: (map["paint"]["location"] as List?)
          ?.map<double?>((e) => (e as num).toDouble())
          .toList(),
      perspectiveCompensation: map["paint"]["perspective-compensation"] is num?
          ? (map["paint"]["perspective-compensation"] as num?)?.toDouble()
          : null,
      shadowImageSize: map["paint"]["shadow-image-size"] is num?
          ? (map["paint"]["shadow-image-size"] as num?)?.toDouble()
          : null,
      topImageSize: map["paint"]["top-image-size"] is num?
          ? (map["paint"]["top-image-size"] as num?)?.toDouble()
          : null,
    );
  }
}

// End of generated file.
