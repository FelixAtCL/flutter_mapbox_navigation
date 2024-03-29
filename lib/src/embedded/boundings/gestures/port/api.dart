part of '../../../../../mapbox_navigation_flutter.dart';

typedef MapGestureListener = void Function(ScreenCoordinate coordinate);

/// Interface for managing gestures of the `map`.
class GestureAPI {
  /// Constructor for [GestureAPI].
  GestureAPI(int id) {
    _methodChannel = MethodChannel(
      'flutter_mapbox_navigation/gestures/$id',
      const StandardMethodCodec(GestureListenerCodec()),
    );
    _methodChannel.setMethodCallHandler(_handleMethod);
  }

  void addListenerOnMapTap(MapGestureListener listener) {
    _onTapMap = listener;
  }

  void removeListenerOnMapTap() {
    _onTapMap = null;
  }

  void addListenerOnScrollMap(MapGestureListener listener) {
    _onScrollMap = listener;
  }

  void removeListenerOnScrollMap() {
    _onScrollMap = null;
  }

  void addListenerOnLongTapMap(MapGestureListener listener) {
    _onLongTapMap = listener;
  }

  void removeListenerOnLongTapMap() {
    _onLongTapMap = null;
  }

  late MethodChannel _methodChannel;

  MapGestureListener? _onTapMap;
  MapGestureListener? _onScrollMap;
  MapGestureListener? _onLongTapMap;

  /// Generic Handler for Messages sent from the Platform
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'sendFromNative':
        final text = call.arguments as String?;
        return Future.value('Text from native: $text');
      case 'onMapTap':
        if (call.arguments is! ScreenCoordinate) break;
        _onTapMap?.call(call.arguments as ScreenCoordinate);
        break;
      case 'onScrollMap':
        if (call.arguments is! ScreenCoordinate) break;
        _onScrollMap?.call(call.arguments as ScreenCoordinate);
        break;
      case 'onLongTapMap':
        if (call.arguments is! ScreenCoordinate) break;
        _onLongTapMap?.call(call.arguments as ScreenCoordinate);
        break;
      default:
        print("${call.method}: ${call.arguments}");
        break;
    }
  }
}
