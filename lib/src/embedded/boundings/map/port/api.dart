part of mapbox_navigation_flutter;

/// Interface for managing camera of the `map`.
class MapAPI {
  /// Constructor for [MapAPI].
  MapAPI(int id) {
    _methodChannel = MethodChannel(
      'flutter_mapbox_navigation/map/$id',
      const StandardMethodCodec(MapAPICodec()),
    );
    _methodChannel.setMethodCallHandler(_handleMethod);
  }

  late MethodChannel _methodChannel;

  /// Calculates a `screen coordinate` that corresponds to a geographical coordinate
  /// (i.e., longitude-latitude pair).
  ///
  /// The `screen coordinate` is in `logical pixels` relative to the top left corner
  /// of the map (not of the whole screen).
  ///
  /// @param coordinate A geographical `coordinate` on the map to convert to a `screen coordinate`.
  ///
  /// @return A `screen coordinate` on the screen in `logical pixels`.
  Future<ScreenCoordinate> pixelForCoordinate(
    double argLatitude,
    double argLongitude,
  ) async {
    final args = <String, dynamic>{};
    args['latitude'] = argLatitude;
    args['longitude'] = argLongitude;
    final result =
        await _methodChannel.invokeMethod('pixelForCoordinate', args);
    if (result is! ScreenCoordinate) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Queries the map for source features.
  ///
  /// @param sourceId The style source identifier used to query for source features.
  /// @param options The `source query options` for querying source features.
  /// @param completion The `query features completion` called when the query completes.
  Future<List<QueriedFeature?>> queryRenderedFeatures(
    RenderedQueryGeometry argGeometry,
    RenderedQueryOptions argOptions,
  ) async {
    final args = <String, dynamic>{};
    args['geometry'] = argGeometry;
    args['options'] = argOptions;
    final result =
        await _methodChannel.invokeMethod('queryRenderedFeatures', args);
    if (result is! List) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result.cast<QueriedFeature?>();
  }

  /// Generic Handler for Messages sent from the Platform
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'sendFromNative':
        final text = call.arguments as String?;
        return Future.value('Text from native: $text');
    }
  }
}
