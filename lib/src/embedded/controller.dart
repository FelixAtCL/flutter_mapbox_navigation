part of '../../mapbox_navigation_flutter.dart';

/// Controller for a single MapBox Navigation instance
/// running on the host platform.
class MapBoxNavigationViewController {
  /// Constructor
  MapBoxNavigationViewController({
    required int id,
    this.onStyleLoadedListener,
    this.onCameraChangeListener,
    this.onMapIdleListener,
    this.onMapLoadedListener,
    this.onMapLoadErrorListener,
    this.onRenderFrameStartedListener,
    this.onRenderFrameFinishedListener,
    this.onSourceAddedListener,
    this.onSourceDataLoadedListener,
    this.onSourceRemovedListener,
    this.onStyleDataLoadedListener,
    this.onStyleImageMissingListener,
    this.onStyleImageUnusedListener,
  }) {
    attribution = AttributionAPI(id);
    camera = CameraAPI(id);
    compass = CompassAPI(id);
    navigationCore = NavigationCoreAPI(id);
    navigationView = NavigationViewAPI(id);
    gesture = GestureAPI(id);
    location = LocationAPI(id);
    logo = LogoAPI(id);
    map = MapAPI(id);
    scaleBar = ScaleBarAPI(id);
    style = StyleAPI(id);

    if (onStyleLoadedListener != null) {
      map.onStyleLoadedPlatform.add((argument) {
        onStyleLoadedListener?.call(argument);
      });
    }
    if (onCameraChangeListener != null) {
      map.onCameraChangeListenerPlatform.add((argument) {
        onCameraChangeListener?.call(argument);
      });
    }
    if (onMapIdleListener != null) {
      map.onMapIdlePlatform.add((argument) {
        onMapIdleListener?.call(argument);
      });
    }
    if (onMapLoadedListener != null) {
      map.onMapLoadedPlatform.add((argument) {
        onMapLoadedListener?.call(argument);
      });
    }
    if (onMapLoadErrorListener != null) {
      map.onMapLoadErrorPlatform.add((argument) {
        onMapLoadErrorListener?.call(argument);
      });
    }
    if (onRenderFrameFinishedListener != null) {
      map.onRenderFrameFinishedPlatform.add((argument) {
        onRenderFrameFinishedListener?.call(argument);
      });
    }
    if (onRenderFrameStartedListener != null) {
      map.onRenderFrameStartedPlatform.add((argument) {
        onRenderFrameStartedListener?.call(argument);
      });
    }
    if (onSourceAddedListener != null) {
      map.onSourceAddedPlatform.add((argument) {
        onSourceAddedListener?.call(argument);
      });
    }
    if (onSourceDataLoadedListener != null) {
      map.onSourceDataLoadedPlatform.add((argument) {
        onSourceDataLoadedListener?.call(argument);
      });
    }
    if (onSourceRemovedListener != null) {
      map.onSourceRemovedPlatform.add((argument) {
        onSourceRemovedListener?.call(argument);
      });
    }
    if (onStyleDataLoadedListener != null) {
      map.onStyleDataLoadedPlatform.add((argument) {
        onStyleDataLoadedListener?.call(argument);
      });
    }
    if (onStyleImageMissingListener != null) {
      map.onStyleImageMissingPlatform.add((argument) {
        onStyleImageMissingListener?.call(argument);
      });
    }
    if (onStyleImageUnusedListener != null) {
      map.onStyleImageUnusedPlatform.add((argument) {
        onStyleImageUnusedListener?.call(argument);
      });
    }
  }

  late AttributionAPI attribution;
  late CameraAPI camera;
  late CompassAPI compass;
  late NavigationCoreAPI navigationCore;
  late NavigationViewAPI navigationView;
  late GestureAPI gesture;
  late LocationAPI location;
  late LogoAPI logo;
  late MapAPI map;
  late ScaleBarAPI scaleBar;
  late StyleAPI style;

  late MethodChannel _methodChannel;

  /// Invoked when the requested style has been fully loaded, including the style, specified sprite and sources' metadata.
  final OnStyleLoadedListener? onStyleLoadedListener;

  /// Invoked whenever camera position changes.
  final OnCameraChangeListener? onCameraChangeListener;

  /// Invoked when the Map has entered the idle state. The Map is in the idle state when there are no ongoing transitions
  /// and the Map has rendered all available tiles.
  final OnMapIdleListener? onMapIdleListener;

  /// Invoked when the Map's style has been fully loaded, and the Map has rendered all visible tiles.
  final OnMapLoadedListener? onMapLoadedListener;

  /// Invoked whenever the map load errors out
  final OnMapLoadErrorListener? onMapLoadErrorListener;

  /// Invoked whenever the Map finished rendering a frame.
  /// The render-mode value tells whether the Map has all data ("full") required to render the visible viewport.
  /// The needs-repaint value provides information about ongoing transitions that trigger Map repaint.
  /// The placement-changed value tells if the symbol placement has been changed in the visible viewport.
  final OnRenderFrameFinishedListener? onRenderFrameFinishedListener;

  /// Invoked whenever the Map started rendering a frame.
  final OnRenderFrameStartedListener? onRenderFrameStartedListener;

  /// Invoked whenever the Source has been added with StyleManager#addStyleSource runtime API.
  final OnSourceAddedListener? onSourceAddedListener;

  /// Invoked when the requested source data has been loaded.
  final OnSourceDataLoadedListener? onSourceDataLoadedListener;

  /// Invoked whenever the Source has been removed with StyleManager#removeStyleSource runtime API.
  final OnSourceRemovedListener? onSourceRemovedListener;

  /// Invoked when the requested style data has been loaded.
  final OnStyleDataLoadedListener? onStyleDataLoadedListener;

  /// Invoked whenever a style has a missing image. This event is emitted when the Map renders visible tiles and
  /// one of the required images is missing in the sprite sheet. Subscriber has to provide the missing image
  /// by calling StyleManager#addStyleImage method.
  final OnStyleImageMissingListener? onStyleImageMissingListener;

  /// Invoked whenever an image added to the Style is no longer needed and can be removed using StyleManager#removeStyleImage method.
  final OnStyleImageUnusedListener? onStyleImageUnusedListener;

  ValueSetter<RouteEvent>? _routeEventNotifier;

  late StreamSubscription<RouteEvent> _routeEventSubscription;

  ///Current Device OS Version
  Future<String> get platformVersion => _methodChannel
      .invokeMethod('getPlatformVersion')
      .then((dynamic result) => result as String);

  void dispose() {
    navigationCore.dispose();
    navigationView.dispose();
  }
}
