part of mapbox_navigation_flutter;

/// Interface for managing the Location of the `map`.
class LocationAPI {
  /// Constructor for [LocationAPI].
  LocationAPI(int id) {
    _methodChannel = MethodChannel(
      'flutter_mapbox_navigation/location/$id',
      const StandardMethodCodec(LocationAPICodec()),
    );
    _methodChannel.setMethodCallHandler(_handleMethod);
  }

  final List<LocationListener> _listeners = [];
  late MethodChannel _methodChannel;

  /// Retrieves the Location settings from the API.
  ///
  /// Returns a [Future] that resolves to a [LocationComponentSettings] object.
  /// Throws a [PlatformException] if there is an error establishing the connection on the channel.
  Future<LocationComponentSettings> getSettings() async {
    final result = await _methodChannel.invokeMethod('getSettings', null);
    if (result is! LocationComponentSettings) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Updates the settings for the Location.
  ///
  /// The [argSettings] parameter is used to specify the new Location settings.
  /// The Location settings are passed as a [LocationComponentSettings] object.
  ///
  /// Throws a [PlatformException] if there is an error establishing the connection on the channel.
  Future<void> updateSettings(LocationComponentSettings argSettings) async {
    final args = <String, dynamic>{};
    args['settings'] = argSettings;
    final result = await _methodChannel.invokeMethod('updateSettings', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Adds a [LocationListener] to the list of listeners.
  ///
  /// The [listener] will be notified whenever a location update occurs.
  void listen(LocationListener listener) {
    _listeners.add(listener);
  }

  /// Removes the specified [listener] from the list of location listeners.
  void remove(LocationListener listener) {
    _listeners.remove(listener);
  }

  void _notify(Location location) {
    for (final listener in _listeners) {
      listener(location);
    }
  }

  /// Generic Handler for Messages sent from the Platform
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onLocationChanged':
        final location =
            Location.fromJson(call.arguments as Map<String, dynamic>);
        _notify(location);
        return null;
      case 'sendFromNative':
        final text = call.arguments as String?;
        return Future.value('Text from native: $text');
    }
  }
}
