part of mapbox_navigation_flutter;

/// Interface for managing the Attribution of the `map`.
class AttributionAPI {
  /// Constructor for [AttributionAPI].
  AttributionAPI(int id) {
    _methodChannel = MethodChannel(
      'flutter_mapbox_navigation/attribution/$id',
      const StandardMethodCodec(AttributionAPICodec()),
    );
    _methodChannel.setMethodCallHandler(_handleMethod);
  }

  late MethodChannel _methodChannel;

  /// Retrieves the Attribution settings from the API.
  ///
  /// Returns a [Future] that resolves to a [AttributionSettings] object.
  /// Throws a [PlatformException] if there is an error establishing the connection on the channel.
  Future<AttributionSettings> getSettings() async {
    final result = await _methodChannel.invokeMethod('getSettings', null);
    if (result is! AttributionSettings) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Updates the settings for the Attribution.
  ///
  /// The [argSettings] parameter is used to specify the new Attribution settings.
  /// The Attribution settings are passed as a [AttributionSettings] object.
  ///
  /// Throws a [PlatformException] if there is an error establishing the connection on the channel.
  Future<void> updateSettings(AttributionSettings argSettings) async {
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

  /// Generic Handler for Messages sent from the Platform
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'sendFromNative':
        final text = call.arguments as String?;
        return Future.value('Text from native: $text');
    }
  }
}
