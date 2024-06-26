// This file is generated.
part of '../../../../../../mapbox_navigation_flutter.dart';

/// An image data source.
/// @see [The online documentation](https://docs.mapbox.com/mapbox-gl-js/style-spec/sources/#image)
class ImageSource extends Source {
  ImageSource({
    required super.id,
    String? url,
    List<List<double?>?>? coordinates,
    double? prefetchZoomDelta,
  }) {
    _url = url;
    _coordinates = coordinates;
    _prefetchZoomDelta = prefetchZoomDelta;
  }

  @override
  String getType() => 'image';

  String? _url;

  /// URL that points to an image.
  Future<String?> get url async {
    return _style?.getStyleSourceProperty(id, 'url').then((value) {
      if (value.value != '<null>') {
        return value.value;
      } else {
        return null;
      }
    });
  }

  List<List<double?>?>? _coordinates;

  /// Corners of image specified in longitude, latitude pairs.
  Future<List<List<double?>?>?> get coordinates async {
    return _style?.getStyleSourceProperty(id, 'coordinates').then((value) {
      if (value.value != '<null>') {
        return (json.decode(value.value) as List).cast<List<double>>();
      } else {
        return null;
      }
    });
  }

  double? _prefetchZoomDelta;

  /// When loading a map, if PrefetchZoomDelta is set to any number greater than 0, the map will first request a tile at zoom level lower than zoom - delta, but so that the zoom level is multiple of delta, in an attempt to display a full map at lower resolution as quick as possible. It will get clamped at the tile source minimum zoom. The default delta is 4.
  Future<double?> get prefetchZoomDelta async {
    return _style
        ?.getStyleSourceProperty(id, 'prefetch-zoom-delta')
        .then((value) {
      if (value.value != '<null>') {
        return double.parse(value.value);
      } else {
        return null;
      }
    });
  }

  /// Updates the image of an image style source.
  ///
  /// See [https://docs.mapbox.com/mapbox-gl-js/style-spec/#sources-image](https://docs.mapbox.com/mapbox-gl-js/style-spec/#sources-image)
  ///
  /// @param image Pixel data of the image.
  Future<void>? updateImage(MbxImage image) {
    return _style?.updateStyleImageSourceImage(id, image);
  }

  @override
  String _encode(bool volatile) {
    final properties = <String, dynamic>{};

    if (volatile) {
      if (_prefetchZoomDelta != null) {
        properties['prefetch-zoom-delta'] = _prefetchZoomDelta;
      }
    } else {
      properties['id'] = id;
      properties['type'] = getType();
      if (_url != null) {
        properties['url'] = _url;
      }
      if (_coordinates != null) {
        properties['coordinates'] = _coordinates;
      }
    }

    return json.encode(properties);
  }
}

// End of generated file.
