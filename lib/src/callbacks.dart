part of '../mapbox_navigation_flutter.dart';

/// Callback function taking a single argument.
typedef ArgumentCallback<T> = void Function(T argument);

/// Mutable collection of [ArgumentCallback] instances, itself an [ArgumentCallback].
///
/// Additions and removals happening during a single [call] invocation do not
/// change who gets a callback until the next such invocation.
///
/// Optimized for the singleton case.
class ArgumentCallbacks<T> {
  final List<ArgumentCallback<T>> _callbacks = <ArgumentCallback<T>>[];

  /// Callback method. Invokes the corresponding method on each callback
  /// in this collection.
  ///
  /// The list of callbacks being invoked is computed at the start of the
  /// method and is unaffected by any changes subsequently made to this
  /// collection.
  Future<void> call(T argument) async {
    final length = _callbacks.length;
    if (length == 1) {
      _callbacks[0].call(argument);
    } else if (0 < length) {
      for (final callback in List<ArgumentCallback<T>>.from(_callbacks)) {
        callback(argument);
      }
    }
  }

  /// Adds a callback to this collection.
  void add(ArgumentCallback<T> callback) {
    _callbacks.add(callback);
  }

  /// Removes a callback from this collection.
  ///
  /// Does nothing, if the callback was not present.
  void remove(ArgumentCallback<T> callback) {
    _callbacks.remove(callback);
  }

  /// Whether this collection is empty.
  bool get isEmpty => _callbacks.isEmpty;

  /// Whether this collection is non-empty.
  bool get isNotEmpty => _callbacks.isNotEmpty;
}

/// Definition for listener invoked when the map is created.
typedef MapCreatedCallback = void Function(MapboxMap controller);

/// Definition for listener invoked when the style is fully loaded.
typedef OnStyleLoadedListener = void Function(
  StyleLoadedEventData styleLoadedEventData,
);

/// Definition for listener invoked whenever the camera position changes.
typedef OnCameraChangeListener = void Function(
  CameraChangedEventData cameraChangedEventData,
);

/// Definition for listener invoked whenever the Map has entered the idle state.
typedef OnMapIdleListener = void Function(MapIdleEventData mapIdleEventData);

/// Definition for listener invoked when the map loading finishes.
typedef OnMapLoadedListener = void Function(
  MapLoadedEventData mapLoadedEventData,
);

/// Definition for listener invoked whenever the map load errors out.
typedef OnMapLoadErrorListener = void Function(
  MapLoadingErrorEventData mapLoadingErrorEventData,
);

/// Definition for listener invoked whenever the Map started rendering a frame.
typedef OnRenderFrameStartedListener = void Function(
  RenderFrameStartedEventData renderFrameStartedEventData,
);

/// Definition for listener invoked whenever the Map finished rendering a frame.
typedef OnRenderFrameFinishedListener = void Function(
  RenderFrameFinishedEventData renderFrameFinishedEventData,
);

/// Definition for listener invoked whenever a source is added.
typedef OnSourceAddedListener = void Function(
  SourceAddedEventData sourceAddedEventData,
);

/// Definition for listener invoked when the requested source data has been loaded.
typedef OnSourceDataLoadedListener = void Function(
  SourceDataLoadedEventData sourceDataLoadedEventData,
);

/// Definition for listener invoked whenever a source is removed.
typedef OnSourceRemovedListener = void Function(
  SourceRemovedEventData sourceRemovedEventData,
);

/// Definition for listener invoked when the requested style data has been loaded.
typedef OnStyleDataLoadedListener = void Function(
  StyleDataLoadedEventData styleDataLoadedEventData,
);

/// Definition for listener invoked when the style has a missing image.
typedef OnStyleImageMissingListener = void Function(
  StyleImageMissingEventData styleImageMissingEventData,
);

/// Definition for listener invoked when an image added to the Style is no longer needed.
typedef OnStyleImageUnusedListener = void Function(
  StyleImageUnusedEventData styleImageUnusedEventData,
);

/// Gesture listener called on map tap.
typedef OnMapTapListener = void Function(ScreenCoordinate coordinate);

/// Gesture listener called on map double tap.
typedef OnMapLongTapListener = void Function(ScreenCoordinate coordinate);

/// Gesture listener called on map scroll.
typedef OnMapScrollListener = void Function(ScreenCoordinate coordinate);
