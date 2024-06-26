// This file is generated.
part of '../../../../../../mapbox_navigation_flutter.dart';

/// A raster tile source.
/// @see [The online documentation](https://docs.mapbox.com/mapbox-gl-js/style-spec/sources/#raster)
class RasterSource extends Source {
  RasterSource({
    required super.id,
    String? url,
    List<String?>? tiles,
    List<double?>? bounds,
    double? minzoom,
    double? maxzoom,
    double? tileSize,
    Scheme? scheme,
    String? attribution,
    bool? volatile,
    double? prefetchZoomDelta,
    double? minimumTileUpdateInterval,
    double? maxOverscaleFactorForParentTiles,
    double? tileRequestsDelay,
    double? tileNetworkRequestsDelay,
  }) {
    _url = url;
    _tiles = tiles;
    _bounds = bounds;
    _minzoom = minzoom;
    _maxzoom = maxzoom;
    _tileSize = tileSize;
    _scheme = scheme;
    _attribution = attribution;
    _volatile = volatile;
    _prefetchZoomDelta = prefetchZoomDelta;
    _minimumTileUpdateInterval = minimumTileUpdateInterval;
    _maxOverscaleFactorForParentTiles = maxOverscaleFactorForParentTiles;
    _tileRequestsDelay = tileRequestsDelay;
    _tileNetworkRequestsDelay = tileNetworkRequestsDelay;
  }

  @override
  String getType() => 'raster';

  String? _url;

  /// A URL to a TileJSON resource. Supported protocols are `http:`, `https:`, and `mapbox://<Tileset ID>`.
  Future<String?> get url async {
    return _style?.getStyleSourceProperty(id, 'url').then((value) {
      if (value.value != '<null>') {
        return value.value;
      } else {
        return null;
      }
    });
  }

  List<String?>? _tiles;

  /// An array of one or more tile source URLs, as in the TileJSON spec.
  Future<List<String?>?> get tiles async {
    return _style?.getStyleSourceProperty(id, 'tiles').then((value) {
      if (value.value != '<null>') {
        return (json.decode(value.value) as List).cast<String>();
      } else {
        return null;
      }
    });
  }

  List<double?>? _bounds;

  /// An array containing the longitude and latitude of the southwest and northeast corners of the source's bounding box in the following order: `[sw.lng, sw.lat, ne.lng, ne.lat]`. When this property is included in a source, no tiles outside of the given bounds are requested by Mapbox GL.
  Future<List<double?>?> get bounds async {
    return _style?.getStyleSourceProperty(id, 'bounds').then((value) {
      if (value.value != '<null>') {
        if (Platform.isIOS) {
          return (json.decode(value.value) as List)
              .cast<int>()
              .map((e) => e.toDouble())
              .toList();
        } else {
          return (json.decode(value.value) as List).cast<double>();
        }
      } else {
        return null;
      }
    });
  }

  double? _minzoom;

  /// Minimum zoom level for which tiles are available, as in the TileJSON spec.
  Future<double?> get minzoom async {
    return _style?.getStyleSourceProperty(id, 'minzoom').then((value) {
      if (value.value != '<null>') {
        return double.parse(value.value);
      } else {
        return null;
      }
    });
  }

  double? _maxzoom;

  /// Maximum zoom level for which tiles are available, as in the TileJSON spec. Data from tiles at the maxzoom are used when displaying the map at higher zoom levels.
  Future<double?> get maxzoom async {
    return _style?.getStyleSourceProperty(id, 'maxzoom').then((value) {
      if (value.value != '<null>') {
        return double.parse(value.value);
      } else {
        return null;
      }
    });
  }

  double? _tileSize;

  /// The minimum visual size to display tiles for this layer. Only configurable for raster layers.
  Future<double?> get tileSize async {
    return _style?.getStyleSourceProperty(id, 'tileSize').then((value) {
      if (value.value != '<null>') {
        return double.parse(value.value);
      } else {
        return null;
      }
    });
  }

  Scheme? _scheme;

  /// Influences the y direction of the tile coordinates. The global-mercator (aka Spherical Mercator) profile is assumed.
  Future<Scheme?> get scheme async {
    return _style?.getStyleSourceProperty(id, 'scheme').then((value) {
      if (value.value != '<null>') {
        return Scheme.values.firstWhere((e) =>
            e.toString().split('.').last.toLowerCase().contains(value.value));
      } else {
        return null;
      }
    });
  }

  String? _attribution;

  /// Contains an attribution to be displayed when the map is shown to a user.
  Future<String?> get attribution async {
    return _style?.getStyleSourceProperty(id, 'attribution').then((value) {
      if (value.value != '<null>') {
        return value.value;
      } else {
        return null;
      }
    });
  }

  bool? _volatile;

  /// A setting to determine whether a source's tiles are cached locally.
  Future<bool?> get volatile async {
    return _style?.getStyleSourceProperty(id, 'volatile').then((value) {
      if (value.value != '<null>') {
        if (Platform.isIOS) {
          return value.value.toLowerCase() == '1';
        } else {
          return value.value.toLowerCase() == 'true';
        }
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

  double? _minimumTileUpdateInterval;

  /// Minimum tile update interval in seconds, which is used to throttle the tile update network requests. If the given source supports loading tiles from a server, sets the minimum tile update interval. Update network requests that are more frequent than the minimum tile update interval are suppressed.
  Future<double?> get minimumTileUpdateInterval async {
    return _style
        ?.getStyleSourceProperty(id, 'minimum-tile-update-interval')
        .then((value) {
      if (value.value != '<null>') {
        return double.parse(value.value);
      } else {
        return null;
      }
    });
  }

  double? _maxOverscaleFactorForParentTiles;

  /// When a set of tiles for a current zoom level is being rendered and some of the ideal tiles that cover the screen are not yet loaded, parent tile could be used instead. This might introduce unwanted rendering side-effects, especially for raster tiles that are overscaled multiple times. This property sets the maximum limit for how much a parent tile can be overscaled.
  Future<double?> get maxOverscaleFactorForParentTiles async {
    return _style
        ?.getStyleSourceProperty(id, 'max-overscale-factor-for-parent-tiles')
        .then((value) {
      if (value.value != '<null>') {
        return double.parse(value.value);
      } else {
        return null;
      }
    });
  }

  double? _tileRequestsDelay;

  /// For the tiled sources, this property sets the tile requests delay. The given delay comes in action only during an ongoing animation or gestures. It helps to avoid loading, parsing and rendering of the transient tiles and thus to improve the rendering performance, especially on low-end devices.
  Future<double?> get tileRequestsDelay async {
    return _style
        ?.getStyleSourceProperty(id, 'tile-requests-delay')
        .then((value) {
      if (value.value != '<null>') {
        return double.parse(value.value);
      } else {
        return null;
      }
    });
  }

  double? _tileNetworkRequestsDelay;

  /// For the tiled sources, this property sets the tile network requests delay. The given delay comes in action only during an ongoing animation or gestures. It helps to avoid loading the transient tiles from the network and thus to avoid redundant network requests. Note that tile-network-requests-delay value is superseded with tile-requests-delay property value, if both are provided.
  Future<double?> get tileNetworkRequestsDelay async {
    return _style
        ?.getStyleSourceProperty(id, 'tile-network-requests-delay')
        .then((value) {
      if (value.value != '<null>') {
        return double.parse(value.value);
      } else {
        return null;
      }
    });
  }

  @override
  String _encode(bool volatile) {
    final properties = <String, dynamic>{};

    if (volatile) {
      if (_prefetchZoomDelta != null) {
        properties['prefetch-zoom-delta'] = _prefetchZoomDelta;
      }
      if (_minimumTileUpdateInterval != null) {
        properties['minimum-tile-update-interval'] = _minimumTileUpdateInterval;
      }
      if (_maxOverscaleFactorForParentTiles != null) {
        properties['max-overscale-factor-for-parent-tiles'] =
            _maxOverscaleFactorForParentTiles;
      }
      if (_tileRequestsDelay != null) {
        properties['tile-requests-delay'] = _tileRequestsDelay;
      }
      if (_tileNetworkRequestsDelay != null) {
        properties['tile-network-requests-delay'] = _tileNetworkRequestsDelay;
      }
    } else {
      properties['id'] = id;
      properties['type'] = getType();
      if (_url != null) {
        properties['url'] = _url;
      }
      if (_tiles != null) {
        properties['tiles'] = _tiles;
      }
      if (_bounds != null) {
        properties['bounds'] = _bounds;
      }
      if (_minzoom != null) {
        properties['minzoom'] = _minzoom;
      }
      if (_maxzoom != null) {
        properties['maxzoom'] = _maxzoom;
      }
      if (_tileSize != null) {
        properties['tileSize'] = _tileSize;
      }
      if (_scheme != null) {
        properties['scheme'] = _scheme.toString().split('.').last.toLowerCase();
      }
      if (_attribution != null) {
        properties['attribution'] = _attribution;
      }
      if (_volatile != null) {
        properties['volatile'] = _volatile;
      }
    }

    return json.encode(properties);
  }
}

// End of generated file.
