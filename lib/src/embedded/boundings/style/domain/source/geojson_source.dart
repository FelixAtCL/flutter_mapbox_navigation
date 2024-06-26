// This file is generated.
part of '../../../../../../mapbox_navigation_flutter.dart';

/// A GeoJSON data source.
/// @see [The online documentation](https://docs.mapbox.com/mapbox-gl-js/style-spec/sources/#geojson)
/// A source that loads GeoJSON data.
class GeoJsonSource extends Source {
  /// Creates a new instance of the [GeoJsonSource] class.
  ///
  /// The [id] parameter is required and specifies the unique identifier for the source.
  /// The [data] parameter is an optional string that represents the GeoJSON data.
  /// The [maxzoom] parameter is an optional double that specifies the maximum zoom level at which to display the source.
  /// The [attribution] parameter is an optional string that represents the attribution for the source.
  /// The [buffer] parameter is an optional double that specifies the buffer size in pixels.
  /// The [tolerance] parameter is an optional double that specifies the simplification tolerance in pixels.
  /// The [cluster] parameter is an optional boolean that indicates whether clustering is enabled.
  /// The [clusterRadius] parameter is an optional double that specifies the cluster radius in pixels.
  /// The [clusterMaxZoom] parameter is an optional double that specifies the maximum zoom level at which to cluster points.
  /// The [clusterProperties] parameter is an optional map that represents the cluster properties.
  /// The [lineMetrics] parameter is an optional boolean that indicates whether line metrics are enabled.
  /// The [generateId] parameter is an optional boolean that indicates whether to generate feature IDs.
  /// The [prefetchZoomDelta] parameter is an optional double that specifies the zoom delta for prefetching tiles.
  GeoJsonSource({
    required super.id,
    String? data,
    double? maxzoom,
    String? attribution,
    double? buffer,
    double? tolerance,
    bool? cluster,
    double? clusterRadius,
    double? clusterMaxZoom,
    Map<String, dynamic>? clusterProperties,
    bool? lineMetrics,
    bool? generateId,
    double? prefetchZoomDelta,
  }) {
    _data = data;
    _maxzoom = maxzoom;
    _attribution = attribution;
    _buffer = buffer;
    _tolerance = tolerance;
    _cluster = cluster;
    _clusterRadius = clusterRadius;
    _clusterMaxZoom = clusterMaxZoom;
    _clusterProperties = clusterProperties;
    _lineMetrics = lineMetrics;
    _generateId = generateId;
    _prefetchZoomDelta = prefetchZoomDelta;
  }

  @override
  String getType() => "geojson";

  String? _data;

  /// A URL to a GeoJSON file, or inline GeoJSON.
  Future<String?> get data async {
    return _style?.getStyleSourceProperty(id, 'data').then((value) {
      if (value.value != '<null>') {
        return value.value;
      } else {
        return null;
      }
    });
  }

  double? _maxzoom;

  /// Maximum zoom level at which to create vector tiles (higher means greater detail at high zoom levels).
  Future<double?> get maxzoom async {
    return _style?.getStyleSourceProperty(id, 'maxzoom').then((value) {
      if (value.value != '<null>') {
        return double.parse(value.value);
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

  double? _buffer;

  /// Size of the tile buffer on each side. A value of 0 produces no buffer. A value of 512 produces a buffer as wide as the tile itself. Larger values produce fewer rendering artifacts near tile edges and slower performance.
  Future<double?> get buffer async {
    return _style?.getStyleSourceProperty(id, 'buffer').then((value) {
      if (value.value != '<null>') {
        return double.parse(value.value);
      } else {
        return null;
      }
    });
  }

  double? _tolerance;

  /// Douglas-Peucker simplification tolerance (higher means simpler geometries and faster performance).
  Future<double?> get tolerance async {
    return _style?.getStyleSourceProperty(id, 'tolerance').then((value) {
      if (value.value != '<null>') {
        return double.parse(value.value);
      } else {
        return null;
      }
    });
  }

  bool? _cluster;

  /// If the data is a collection of point features, setting this to true clusters the points by radius into groups. Cluster groups become new `Point` features in the source with additional properties:
  ///  * `cluster` Is `true` if the point is a cluster
  ///  * `cluster_id` A unqiue id for the cluster to be used in conjunction with the cluster inspection methods
  ///  * `point_count` Number of original points grouped into this cluster
  ///  * `point_count_abbreviated` An abbreviated point count
  Future<bool?> get cluster async {
    return _style?.getStyleSourceProperty(id, 'cluster').then((value) {
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

  double? _clusterRadius;

  /// Radius of each cluster if clustering is enabled. A value of 512 indicates a radius equal to the width of a tile.
  Future<double?> get clusterRadius async {
    return _style?.getStyleSourceProperty(id, 'clusterRadius').then((value) {
      if (value.value != '<null>') {
        return double.parse(value.value);
      } else {
        return null;
      }
    });
  }

  double? _clusterMaxZoom;

  /// Max zoom on which to cluster points if clustering is enabled. Defaults to one zoom less than maxzoom (so that last zoom features are not clustered). Clusters are re-evaluated at integer zoom levels so setting clusterMaxZoom to 14 means the clusters will be displayed until z15.
  Future<double?> get clusterMaxZoom async {
    return _style?.getStyleSourceProperty(id, 'clusterMaxZoom').then((value) {
      if (value.value != '<null>') {
        return double.parse(value.value);
      } else {
        return null;
      }
    });
  }

  Map<String, dynamic>? _clusterProperties;

  /// An object defining custom properties on the generated clusters if clustering is enabled, aggregating values from clustered points. Has the form `{"property_name": [operator, map_expression]}`. `operator` is any expression function that accepts at least 2 operands (e.g. `"+"` or `"max"`) — it accumulates the property value from clusters/points the cluster contains; `map_expression` produces the value of a single point.
  ///
  /// Example: `{"sum": ["+", ["get", "scalerank"]]}`.
  ///
  /// For more advanced use cases, in place of `operator`, you can use a custom reduce expression that references a special `["accumulated"]` value, e.g.:
  /// `{"sum": [["+", ["accumulated"], ["get", "sum"]], ["get", "scalerank"]]}`
  Future<Map<String, dynamic>?> get clusterProperties async {
    return _style
        ?.getStyleSourceProperty(id, 'clusterProperties')
        .then((value) {
      if (value.value != '<null>') {
        return json.decode(value.value) as Map<String, dynamic>?;
      } else {
        return null;
      }
    });
  }

  bool? _lineMetrics;

  /// Whether to calculate line distance metrics. This is required for line layers that specify `line-gradient` values.
  Future<bool?> get lineMetrics async {
    return _style?.getStyleSourceProperty(id, 'lineMetrics').then((value) {
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

  bool? _generateId;

  /// Whether to generate ids for the geojson features. When enabled, the `feature.id` property will be auto assigned based on its index in the `features` array, over-writing any previous values.
  Future<bool?> get generateId async {
    return _style?.getStyleSourceProperty(id, 'generateId').then((value) {
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

  /// Update this GeojsonSource with a URL to a GeoJSON file, or inline GeoJSON.
  Future<void>? updateGeoJSON(String geoJson) async {
    return _style?.setStyleSourceProperty(id, 'data', geoJson);
  }

  @override
  String _encode(bool volatile) {
    var properties = <String, dynamic>{};

    if (volatile) {
      if (_prefetchZoomDelta != null) {
        properties["prefetch-zoom-delta"] = _prefetchZoomDelta;
      }
    } else {
      properties["id"] = id;
      properties["type"] = getType();
      if (_data != null) {
        properties["data"] = _data;
      }
      if (_maxzoom != null) {
        properties["maxzoom"] = _maxzoom;
      }
      if (_attribution != null) {
        properties["attribution"] = _attribution;
      }
      if (_buffer != null) {
        properties["buffer"] = _buffer;
      }
      if (_tolerance != null) {
        properties["tolerance"] = _tolerance;
      }
      if (_cluster != null) {
        properties["cluster"] = _cluster;
      }
      if (_clusterRadius != null) {
        properties["clusterRadius"] = _clusterRadius;
      }
      if (_clusterMaxZoom != null) {
        properties["clusterMaxZoom"] = _clusterMaxZoom;
      }
      if (_clusterProperties != null) {
        properties["clusterProperties"] = _clusterProperties;
      }
      if (_lineMetrics != null) {
        properties["lineMetrics"] = _lineMetrics;
      }
      if (_generateId != null) {
        properties["generateId"] = _generateId;
      }
    }

    return json.encode(properties);
  }
}

// End of generated file.
