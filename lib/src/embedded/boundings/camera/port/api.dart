part of mapbox_navigation_flutter;

/// Interface for managing camera of the `map`.
class CameraAPI {
  /// Constructor for [CameraAPI].
  CameraAPI(int id) {
    _methodChannel = MethodChannel(
      'flutter_mapbox_navigation/camera/$id',
      const StandardMethodCodec(CameraAPICodec()),
    );
    _methodChannel.setMethodCallHandler(_handleMethod);
  }

  late MethodChannel _methodChannel;

  /// Eases the camera to the specified [CameraOptions].
  ///
  /// The [argCameraoptions] parameter represents the camera options to ease to.
  /// The [argMapanimationoptions] parameter represents the animation options for the map animation.
  ///
  /// Throws a [PlatformException] if there is an error establishing a connection on the channel.
  Future<void> easeTo(
    CameraOptions argCameraoptions,
    MapAnimationOptions? argMapanimationoptions,
  ) async {
    final args = <String, dynamic>{};
    args['cameraoptions'] = argCameraoptions;
    args['animationoptions'] = argMapanimationoptions;
    final result = await _methodChannel.invokeMethod('easeTo', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Fly to a specific camera position with optional animation options.
  ///
  /// The [argCameraoptions] parameter specifies the camera options for the desired position.
  /// The [argMapanimationoptions] parameter specifies the animation options for the fly-to animation.
  ///
  /// Throws a [PlatformException] if there is an error establishing the connection on the channel.
  Future<void> flyTo(
    CameraOptions argCameraoptions,
    MapAnimationOptions? argMapanimationoptions,
  ) async {
    final args = <String, dynamic>{};
    args['cameraoptions'] = argCameraoptions;
    args['animationoptions'] = argMapanimationoptions;
    final result = await _methodChannel.invokeMethod('flyTo', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Sets the pitch of the camera by the given [argPitch].
  /// The [argMapanimationoptions] parameter specifies the animation options for the pitch change.
  ///
  /// NOTE: NOT AVAILABLE ON iOS
  ///
  /// Throws a [PlatformException] if there is an error establishing connection on the channel.
  Future<void> pitchBy(
    double argPitch,
    MapAnimationOptions? argMapanimationoptions,
  ) async {
    final args = <String, dynamic>{};
    args['pitch'] = argPitch;
    args['animationoptions'] = argMapanimationoptions;
    final result = await _methodChannel.invokeMethod('pitchBy', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Scales the camera view by the specified amount.
  ///
  /// The [argAmount] parameter specifies the amount by which the camera view should be scaled.
  /// A positive value will zoom in, while a negative value will zoom out.
  ///
  /// The [argScreencoordinate] parameter specifies the screen coordinate around which the scaling should occur.
  /// If null, the scaling will be centered on the screen.
  ///
  /// The [argMapanimationoptions] parameter specifies the animation options for the scaling operation.
  /// If null, no animation will be applied.
  ///
  /// NOTE: NOT AVAILABLE ON iOS
  ///
  /// Throws a [PlatformException] if there is an error establishing a connection on the method channel.
  Future<void> scaleBy(
    double argAmount,
    ScreenCoordinate? argScreencoordinate,
    MapAnimationOptions? argMapanimationoptions,
  ) async {
    final args = <String, dynamic>{};
    args['amount'] = argAmount;
    args['coordinate'] = argScreencoordinate;
    args['animationoptions'] = argMapanimationoptions;
    final result = await _methodChannel.invokeMethod('scaleBy', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Moves the camera by a given screen coordinate with optional animation options.
  ///
  /// The [argScreencoordinate] parameter specifies the screen coordinate by which the camera should be moved.
  /// The [argMapanimationoptions] parameter specifies the animation options for the camera movement. It is optional and can be null.
  ///
  /// NOTE: NOT AVAILABLE ON iOS
  ///
  /// Throws a [PlatformException] if there is an error establishing a connection on the channel.
  Future<void> moveBy(
    ScreenCoordinate argScreencoordinate,
    MapAnimationOptions? argMapanimationoptions,
  ) async {
    final args = <String, dynamic>{};
    args['coordinate'] = argScreencoordinate;
    args['animationoptions'] = argMapanimationoptions;
    final result = await _methodChannel.invokeMethod('moveBy', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Rotates the camera by the given screen coordinates.
  ///
  /// The [argFirst] and [argSecond] parameters represent the starting and ending screen coordinates
  /// for the rotation. The [argMapanimationoptions] parameter specifies the animation options for
  /// the rotation. If no animation options are provided, the rotation will be immediate.
  ///
  /// NOTE: NOT AVAILABLE ON iOS
  ///
  /// Throws a [PlatformException] if there is an error establishing a connection on the channel.
  Future<void> rotateBy(
    ScreenCoordinate argFirst,
    ScreenCoordinate argSecond,
    MapAnimationOptions? argMapanimationoptions,
  ) async {
    final args = <String, dynamic>{};
    args['first'] = argFirst;
    args['second'] = argSecond;
    args['animationoptions'] = argMapanimationoptions;
    final result = await _methodChannel.invokeMethod('rotateBy', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Cancels the ongoing camera animation.
  ///
  /// This method invokes the native platform method 'cancelCameraAnimation'
  /// through the method channel. If the method call returns a non-null result,
  /// it throws a [PlatformException] with the code 'channel-error' and the
  /// message 'Unable to establish connection on channel.'
  ///
  /// Throws:
  ///   - [PlatformException] if the method call returns a non-null result.
  Future<void> cancelCameraAnimation() async {
    final result =
        await _methodChannel.invokeMethod('cancelCameraAnimation', null);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Retrieves the current state of the camera.
  ///
  /// Returns a [Future] that resolves to a [CameraState] object representing the current state of the camera.
  /// Throws a [PlatformException] if there is an error establishing a connection on the channel.
  Future<CameraState> getState() async {
    final result = await _methodChannel.invokeMethod('getState', null);
    if (result is! CameraState) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Retrieves the coordinate bounds of the camera view.
  ///
  /// This method takes a [CameraOptions] object as a parameter and returns a [Future] that resolves to a [CoordinateBounds] object.
  /// The [CameraOptions] object contains the necessary information to determine the camera view, such as the zoom level and center coordinates.
  ///
  /// Throws a [PlatformException] if there is an error establishing a connection on the method channel.
  ///
  /// Example usage:
  /// ```dart
  /// CameraOptions camera = CameraOptions(zoom: 15, center: LatLng(37.7749, -122.4194));
  /// CoordinateBounds bounds = await coordinateBounds(camera);
  /// print(bounds);
  /// ```
  Future<CoordinateBounds> getCoordinateBounds(
    CameraOptions argCameraOptions,
  ) async {
    final args = <String, dynamic>{};
    args['camera'] = argCameraOptions;
    final result = await _methodChannel.invokeMethod(
      'getCoordinateBounds',
      args,
    );
    if (result is! CoordinateBounds) {
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
