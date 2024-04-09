part of mapbox_navigation_flutter;

/// Interface for managing camera of the `map`.
class MapAPI {
  /// Constructor for [MapAPI].
  MapAPI(int id) {
    _methodChannel = MethodChannel(
      'flutter_mapbox_navigation/map/$id',
      const StandardMethodCodec(MapAPICodec()),
    );
    _methodChannel.setMethodCallHandler(_handleMethod);
  }

  late MethodChannel _methodChannel;
  final _observers = <String, List<Observer>>{};
  final _listeners = ArgumentCallbacks<Event>();
  final onStyleLoadedPlatform = ArgumentCallbacks<StyleLoadedEventData>();
  final onCameraChangeListenerPlatform =
      ArgumentCallbacks<CameraChangedEventData>();
  final onMapIdlePlatform = ArgumentCallbacks<MapIdleEventData>();
  final onMapLoadedPlatform = ArgumentCallbacks<MapLoadedEventData>();
  final onMapLoadErrorPlatform = ArgumentCallbacks<MapLoadingErrorEventData>();
  final onRenderFrameFinishedPlatform =
      ArgumentCallbacks<RenderFrameFinishedEventData>();
  final onRenderFrameStartedPlatform =
      ArgumentCallbacks<RenderFrameStartedEventData>();
  final onSourceAddedPlatform = ArgumentCallbacks<SourceAddedEventData>();
  final onSourceDataLoadedPlatform =
      ArgumentCallbacks<SourceDataLoadedEventData>();
  final onSourceRemovedPlatform = ArgumentCallbacks<SourceRemovedEventData>();
  final onStyleDataLoadedPlatform =
      ArgumentCallbacks<StyleDataLoadedEventData>();
  final onStyleImageMissingPlatform =
      ArgumentCallbacks<StyleImageMissingEventData>();
  final onStyleImageUnusedPlatform =
      ArgumentCallbacks<StyleImageUnusedEventData>();

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
    double argLatitude,
    double argLongitude,
  ) async {
    final args = <String, dynamic>{};
    args['latitude'] = argLatitude;
    args['longitude'] = argLongitude;
    final result =
        await _methodChannel.invokeMethod('pixelForCoordinate', args);
    if (result is! ScreenCoordinate) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel. $result',
      );
    }
    return result;
  }

  /// Queries the map for source features.
  ///
  /// @param sourceId The style source identifier used to query for source features.
  /// @param options The `source query options` for querying source features.
  /// @param completion The `query features completion` called when the query completes.
  Future<List<QueriedFeature?>> queryRenderedFeatures(
    RenderedQueryGeometry argGeometry,
    RenderedQueryOptions argOptions,
  ) async {
    final args = <String, dynamic>{};
    args['geometry'] = argGeometry;
    args['options'] = argOptions;
    final result =
        await _methodChannel.invokeMethod('queryRenderedFeatures', args);
    if (result is! List) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel. $result',
      );
    }
    return result.cast<QueriedFeature?>();
  }

  /// Adds an event listener to the API.
  ///
  /// The [observer] parameter is the observer object that will receive the events.
  /// The [events] parameter is a list of [MapEvent] objects representing the events to subscribe to.
  ///
  /// Example usage:
  /// ```dart
  /// api.addEventListener(observer, [MapEvent.event1, MapEvent.event2]);
  /// ```
  ///
  /// Throws an exception if the event subscription fails.
  Future<void> addEventListener(
    Observer observer,
    List<MapEvent> events,
  ) async {
    for (final element in events) {
      final args = <String, dynamic>{};
      args['mapevent'] = "element.name";
      final result = await _methodChannel.invokeMethod('listenOnEvent', args);
      if (result != null) {
        throw PlatformException(
          code: 'channel-error',
          message: 'Unable to establish connection on channel. $result',
        );
      }
      if (_observers[element.name] == null) {
        // Haven't subscribed this event
        _observers[element.name] = [observer];
      } else {
        // Have subscribed this event, just add observer to ths list
        _observers[element.name]!.add(observer);
      }
    }
    _listeners.add(_notify);
  }

  /// Removes the specified [observer] from listening to the given [events].
  ///
  /// The [observer] is removed from the list of observers for each event in the [events] list.
  /// If the observer is not registered for an event, no action is taken for that event.
  ///
  /// The [events] parameter is a list of [MapEvent] objects representing the events to remove the observer from.
  ///
  /// Example usage:
  /// ```dart
  /// removeEventListener(myObserver, [MapEvent.event1, MapEvent.event2]);
  /// ```
  void removeEventListener(
    Observer observer,
    List<MapEvent> events,
  ) {
    for (final element in events) {
      _observers[element.name]?.remove(observer);
      _listeners.remove(_notify);
    }
  }

  void _notify(Event argument) {
    // Notify all the observers registered with this event.
    _observers[argument.type]?.forEach((element) {
      element(argument);
    });
  }

  /// Generic Handler for Messages sent from the Platform
  Future<dynamic> _handleMethod(MethodCall call) async {
    try {
      if (call.method.startsWith('event')) {
        _handleEvents(call);
      } else {
        throw MissingPluginException();
      }
    } catch (error) {
      print(
        'Handle method call ${call.method}, arguments: ${call.arguments} with error: $error',
      );
    }
    switch (call.method) {
      case 'sendFromNative':
        final text = call.arguments as String?;
        return Future.value('Text from native: $text');
    }
  }

  void _handleEvents(MethodCall call) {
    final eventType = call.method.split('#')[1];
    final args = call.arguments as String;
    _listeners(Event(type: eventType, data: args));

    final data = jsonDecode(args) as Map<String, dynamic>;

    if (eventType == MapEvent.styleLoaded.name) {
      onStyleLoadedPlatform(StyleLoadedEventData.fromJson(data));
    } else if (eventType == MapEvent.cameraChanged.name) {
      onCameraChangeListenerPlatform(CameraChangedEventData.fromJson(data));
    } else if (eventType == MapEvent.mapIdle.name) {
      onMapIdlePlatform(MapIdleEventData.fromJson(data));
    } else if (eventType == MapEvent.mapLoaded.name) {
      onMapLoadedPlatform(MapLoadedEventData.fromJson(data));
    } else if (eventType == MapEvent.mapLoadingError.name) {
      onMapLoadErrorPlatform(MapLoadingErrorEventData.fromJson(data));
    } else if (eventType == MapEvent.renderFrameFinished.name) {
      onRenderFrameFinishedPlatform(
          RenderFrameFinishedEventData.fromJson(data));
    } else if (eventType == MapEvent.renderFrameStarted.name) {
      onRenderFrameStartedPlatform(RenderFrameStartedEventData.fromJson(data));
    } else if (eventType == MapEvent.sourceAdded.name) {
      onSourceAddedPlatform(SourceAddedEventData.fromJson(data));
    } else if (eventType == MapEvent.sourceDataLoaded.name) {
      onSourceDataLoadedPlatform(SourceDataLoadedEventData.fromJson(data));
    } else if (eventType == MapEvent.sourceRemoved.name) {
      onSourceRemovedPlatform(SourceRemovedEventData.fromJson(data));
    } else if (eventType == MapEvent.styleDataLoaded.name) {
      onStyleDataLoadedPlatform(StyleDataLoadedEventData.fromJson(data));
    } else if (eventType == MapEvent.styleImageMissing.name) {
      onStyleImageMissingPlatform(StyleImageMissingEventData.fromJson(data));
    } else if (eventType == MapEvent.styleImageRemoveUnused.name) {
      onStyleImageUnusedPlatform(StyleImageUnusedEventData.fromJson(data));
    } else {
      throw MissingPluginException();
    }
  }
}
