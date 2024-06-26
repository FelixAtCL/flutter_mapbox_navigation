part of mapbox_navigation_flutter;

/// Interface for managing the Navigation of the `map`.
class NavigationCoreAPI {
  /// Constructor for [NavigationCoreAPI].
  NavigationCoreAPI(int id) {
    _methodChannel =
        MethodChannel('flutter_mapbox_navigation/navigation/core/$id');
    _methodChannel.setMethodCallHandler(_handleMethod);

    _eventChannel =
        EventChannel('flutter_mapbox_navigation/navigation/core/$id/events');
  }

  late MethodChannel _methodChannel;
  late EventChannel _eventChannel;

  late StreamSubscription<RouteEvent> _routeEventSubscription;
  ValueSetter<RouteEvent>? _routeEventNotifier;

  /// Adds a notifier for route events.
  ///
  /// The [notifier] is a callback function that will be called whenever a route event occurs.
  /// It takes a single parameter of type [RouteEvent].
  /// Use this method to register a notifier to receive updates about route events.
  void addRouteEventNotifier(ValueSetter<RouteEvent> notifier) {
    _routeEventNotifier = notifier;
  }

  ///Build the Route Used for the Navigation
  ///
  /// [wayPoints] must not be null. A collection of [WayPoint](longitude,
  /// latitude and name). Must be at least 2 or at most 25. Cannot use
  /// drivingWithTraffic mode if more than 3-waypoints.
  ///
  Future<void> build({
    required List<WayPoint> wayPoints,
    required MapBoxOptions options,
  }) async {
    assert(wayPoints.length > 1, 'Error: WayPoints must be at least 2');
    final pointList = <Map<String, Object?>>[];

    for (var i = 0; i < wayPoints.length; i++) {
      final wayPoint = wayPoints[i];
      assert(wayPoint.name != null, 'Error: waypoints need name');
      assert(wayPoint.latitude != null, 'Error: waypoints need latitude');
      assert(wayPoint.longitude != null, 'Error: waypoints need longitude');

      final pointMap = <String, dynamic>{
        'Order': i,
        'Name': wayPoint.name,
        'Latitude': wayPoint.latitude,
        'Longitude': wayPoint.longitude,
        'IsSilent': wayPoint.isSilent,
      };
      pointList.add(pointMap);
    }

    var i = 0;
    final wayPointMap = {for (final e in pointList) i++: e};

    final args = options.toMap();
    args['wayPoints'] = wayPointMap;

    _routeEventSubscription = _streamRouteEvent!.listen(_onProgressData);
    final result = await _methodChannel.invokeMethod('build', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel. $result',
      );
    }
  }

  /// Starts the navigation process.
  ///
  /// This method invokes the 'start' method on the method channel to initiate the navigation process.
  /// It returns a [Future] that completes when the navigation process is started.
  /// If an error occurs during the process, a [PlatformException] is thrown with the error details.
  Future<void> start({
    required MapBoxOptions options,
  }) async {
    final args = options.toMap();
    final result = await _methodChannel.invokeMethod('start', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel. $result',
      );
    }
  }

  /// Finish the navigation session.
  ///
  /// This method is used to finish the navigation session and close the navigation screen.
  /// It invokes the 'finish' method on the method channel and throws a [PlatformException]
  /// if there is an error establishing a connection to the channel.
  ///
  /// Throws a [PlatformException] if there is an error establishing a connection to the channel.
  Future<void> finish() async {
    final result = await _methodChannel.invokeMethod('finish', null);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection to channel. $result',
      );
    }
  }

  /// Clears the navigation port.
  ///
  /// This method clears the navigation port by invoking the 'clear' method on the method channel.
  /// If the result is not null, it throws a [PlatformException] with the code 'channel-error'
  /// and a message indicating the failure to establish a connection to the channel.
  ///
  /// Throws a [PlatformException] if there is an error establishing a connection to the channel.
  Future<void> clear() async {
    final result = await _methodChannel.invokeMethod('clear', null);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection to channel. $result',
      );
    }
  }

  /// Mutes the navigation audio.
  ///
  /// This method invokes the 'mute' method on the [_methodChannel] to mute the navigation audio.
  /// If there is an error establishing a connection to the channel, a [PlatformException] is thrown.
  ///
  /// Throws a [PlatformException] if there is an error establishing a connection to the channel.
  Future<void> mute() async {
    final result = await _methodChannel.invokeMethod('mute', null);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection to channel. $result',
      );
    }
  }

  /// Unmutes the navigation audio.
  ///
  /// This method invokes the 'unmute' method on the method channel to unmute the navigation audio.
  /// If the result is not null, it throws a [PlatformException] with the code 'channel-error'
  /// and a message indicating the failure to establish a connection to the channel.
  Future<void> unmute() async {
    final result = await _methodChannel.invokeMethod('unmute', null);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection to channel. $result',
      );
    }
  }

  void _onProgressData(RouteEvent event) {
    if (_routeEventNotifier != null) _routeEventNotifier?.call(event);
  }

  Stream<RouteEvent>? get _streamRouteEvent {
    return _eventChannel
        .receiveBroadcastStream()
        .map((dynamic event) => _parseRouteEvent(event as String));
  }

  RouteEvent _parseRouteEvent(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    final event = RouteEvent.fromJson(map);
    _onProgressData(event);
    return event;
  }

  /// Generic Handler for Messages sent from the Platform
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'sendFromNative':
        final text = call.arguments as String?;
        return Future.value('Text from native: $text');
    }
  }

  void dispose() {
    _routeEventSubscription.cancel();
  }
}
