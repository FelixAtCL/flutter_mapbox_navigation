import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mapbox_navigation/mapbox_navigation_flutter.dart';
import 'package:flutter_mapbox_navigation/src/models/models.dart';

/// Callback method for when the navigation view is ready to be used.
///
/// Pass to MapBoxNavigationView.onMapCreated to receive a
/// [MapBoxNavigationViewController] when the
/// map is created.
typedef OnNavigationViewCreatedCallBack = void Function(
  MapBoxNavigationViewController controller,
);

///Embeddable Navigation View.
class MapBoxNavigationView extends StatelessWidget {
  ///Embeddable Navigation View Constructor
  const MapBoxNavigationView({
    super.key,
    this.options,
    this.onCreated,
    this.onRouteEvent,
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
  });

  static const StandardMessageCodec _decoder = StandardMessageCodec();

  /// MapBox options
  final MapBoxOptions? options;

  /// Callback when view is created
  final OnNavigationViewCreatedCallBack? onCreated;

  /// Value setter for RouteEvents
  final ValueSetter<RouteEvent>? onRouteEvent;

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

  /// View name
  static const String viewType = 'FlutterMapboxNavigationView';

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      // using Hybrid Composition
      return PlatformViewLink(
        viewType: viewType,
        surfaceFactory: (context, controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (params) {
          return PlatformViewsService.initExpensiveAndroidView(
            id: params.id,
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: options!.toMap(),
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () {
              params.onFocusChanged(true);
            },
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..addOnPlatformViewCreatedListener(_onPlatformViewCreated)
            ..create();
        },
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: 'FlutterMapboxNavigationView',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: options!.toMap(),
        creationParamsCodec: _decoder,
      );
    } else {
      return Container();
    }
  }

  void _onPlatformViewCreated(int id) {
    if (onCreated == null) {
      return;
    }
    onCreated?.call(
      MapBoxNavigationViewController(
        id: id,
        onRouteEvent: onRouteEvent,
        onStyleLoadedListener: onStyleLoadedListener,
        onCameraChangeListener: onCameraChangeListener,
        onMapIdleListener: onMapIdleListener,
        onMapLoadedListener: onMapLoadedListener,
        onMapLoadErrorListener: onMapLoadErrorListener,
        onRenderFrameStartedListener: onRenderFrameStartedListener,
        onRenderFrameFinishedListener: onRenderFrameFinishedListener,
        onSourceAddedListener: onSourceAddedListener,
        onSourceDataLoadedListener: onSourceDataLoadedListener,
        onSourceRemovedListener: onSourceRemovedListener,
        onStyleDataLoadedListener: onStyleDataLoadedListener,
        onStyleImageMissingListener: onStyleImageMissingListener,
        onStyleImageUnusedListener: onStyleImageUnusedListener,
      ),
    );
  }
}
