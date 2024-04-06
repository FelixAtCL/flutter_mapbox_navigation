part of mapbox_navigation_flutter;

/// Interface for managing the logo of the `map`.
class CompassAPI {
  /// Constructor for [CompassAPI].
  CompassAPI(int id) {
    _methodChannel = MethodChannel(
      'flutter_mapbox_navigation/compass/$id',
      const StandardMethodCodec(CompassAPICodec()),
    );
    _methodChannel.setMethodCallHandler(_handleMethod);
  }

  late MethodChannel _methodChannel;

  /// Retrieves the logo settings from the API.
  ///
  /// Returns a [Future] that resolves to a [CompassSettings] object.
  /// Throws a [PlatformException] if there is an error establishing the connection on the channel.
  Future<CompassSettings> getSettings() async {
    final result = await _methodChannel.invokeMethod('getSettings', null);
    if (result is! CompassSettings) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel. $result',
      );
    }
    return result;
  }

  /// Updates the settings for the logo.
  ///
  /// The [argSettings] parameter is used to specify the new logo settings.
  /// The logo settings are passed as a [CompassSettings] object.
  ///
  /// Throws a [PlatformException] if there is an error establishing the connection on the channel.
  Future<void> updateSettings(CompassSettings argSettings) async {
    final args = <String, dynamic>{};
    args['settings'] = argSettings;
    final result = await _methodChannel.invokeMethod('updateSettings', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel. $result',
      );
    }
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
