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

  /// Generic Handler for Messages sent from the Platform
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'sendFromNative':
        final text = call.arguments as String?;
        return Future.value('Text from native: $text');
    }
  }
}
