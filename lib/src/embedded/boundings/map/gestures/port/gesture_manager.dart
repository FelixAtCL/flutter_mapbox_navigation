part of '../../../../../../mapbox_navigation_flutter.dart';

/// Interface for managing gestures of the `map`.
class GestureManager {
  /// Constructor for [GestureManager].
  GestureManager(int id) {
    _methodChannel = MethodChannel('flutter_mapbox_navigation/gestures/$id');
    _methodChannel.setMethodCallHandler(_handleMethod);

    _eventChannel =
        EventChannel('flutter_mapbox_navigation/gestures/$id/events');
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
