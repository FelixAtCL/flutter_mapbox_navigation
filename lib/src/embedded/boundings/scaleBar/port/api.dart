part of mapbox_navigation_flutter;

/// Interface for managing the scaleBar of the `map`.
class ScaleBarAPI {
  /// Constructor for [ScaleBarAPI].
  ScaleBarAPI(int id) {
    _methodChannel = MethodChannel(
      'flutter_mapbox_navigation/scalebar/$id',
      const StandardMethodCodec(ScaleBarAPICodec()),
    );
    _methodChannel.setMethodCallHandler(_handleMethod);
  }

  late MethodChannel _methodChannel;

  /// Retrieves the scaleBar settings from the API.
  ///
  /// Returns a [Future] that resolves to a [ScaleBarSettings] object.
  /// Throws a [PlatformException] if there is an error establishing the connection on the channel.
  Future<ScaleBarSettings> getSettings() async {
    final result = await _methodChannel.invokeMethod('getSettings', null);
    if (result is! ScaleBarSettings) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Updates the settings for the scaleBar.
  ///
  /// The [argSettings] parameter is used to specify the new scaleBar settings.
  /// The scaleBar settings are passed as a [ScaleBarSettings] object.
  ///
  /// Throws a [PlatformException] if there is an error establishing the connection on the channel.
  Future<void> updateSettings(ScaleBarSettings argSettings) async {
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
