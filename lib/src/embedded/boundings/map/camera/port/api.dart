part of mapbox_navigation_flutter;

/// Interface for managing camera of the `map`.
class CameraAPI {
  /// Constructor for [CameraAPI].
  CameraAPI(int id) {
    _methodChannel = MethodChannel('mapbox_navigation_flutter/camera/$id');
    _methodChannel.setMethodCallHandler(_handleMethod);

    _eventChannel = EventChannel('mapbox_navigation_flutter/camera/$id/events');
  }

  late MethodChannel _methodChannel;
  late EventChannel _eventChannel;

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
    Map<String?, Object?> argCoordinate,
  ) async {
    final args = <String, dynamic>{};
    args['coordinate'] = argCoordinate;
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

  /// Generic Handler for Messages sent from the Platform
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'sendFromNative':
        final text = call.arguments as String?;
        return Future.value('Text from native: $text');
    }
  }
}
