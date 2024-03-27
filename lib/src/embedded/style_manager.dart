part of '../../mapbox_navigation_flutter.dart';

/// Interface for managing style of the `map`.
class StyleManager {
  /// Constructor for [StyleManager].
  StyleManager(int id) {
    _methodChannel = MethodChannel('flutter_mapbox_navigation/style/$id');
    _methodChannel.setMethodCallHandler(_handleMethod);

    _eventChannel = EventChannel('flutter_mapbox_navigation/style/$id/events');
  }

  late MethodChannel _methodChannel;
  late EventChannel _eventChannel;

  /// Get the URI of the current style in use.
  ///
  /// @return A string containing a style URI.
  Future<String> getStyleURI() async {
    final result = await _methodChannel.invokeMethod('getStyleURI', null);
    if (result is! String) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Load style from provided URI.
  ///
  /// This is an asynchronous call. To check the result of this operation the user must register an observer observing
  /// `MapLoaded` or `MapLoadingError` events. In case of successful style load, `StyleLoaded` event will be also emitted.
  ///
  /// @param uri URI where the style should be loaded from.
  Future<void> setStyleURI(String argUri) async {
    final args = <String, dynamic>{};
    args['uri'] = argUri;
    final result = await _methodChannel.invokeMethod('setStyleURI', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Get the JSON serialization string of the current style in use.
  ///
  /// @return A JSON string containing a serialized style.
  Future<String> getStyleJSON() async {
    final result = await _methodChannel.invokeMethod('getStyleJSON', null);
    if (result is! String) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Load the style from a provided JSON string.
  ///
  /// @param json A JSON string containing a serialized style.
  Future<void> setStyleJSON(String argJson) async {
    final args = <String, dynamic>{};
    args['json'] = argJson;
    final result = await _methodChannel.invokeMethod('setStyleJSON', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Returns the map style's default camera, if any, or a default camera otherwise.
  /// The map style's default camera is defined as follows:
  /// - [center](https://docs.mapbox.com/mapbox-gl-js/style-spec/#root-center)
  /// - [zoom](https://docs.mapbox.com/mapbox-gl-js/style-spec/#root-zoom)
  /// - [bearing](https://docs.mapbox.com/mapbox-gl-js/style-spec/#root-bearing)
  /// - [pitch](https://docs.mapbox.com/mapbox-gl-js/style-spec/#root-pitch)
  ///
  /// The style default camera is re-evaluated when a new style is loaded.
  ///
  /// @return The default `camera options` of the current style in use.
  Future<CameraOptions> getStyleDefaultCamera() async {
    final result =
        await _methodChannel.invokeMethod('getStyleDefaultCamera', null);
    if (result is! CameraOptions) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Returns the map style's transition options. By default, the style parser will attempt
  /// to read the style default transition options, if any, fallbacking to an immediate transition
  /// otherwise. Transition options can be overriden via `setStyleTransition`, but the options are
  /// reset once a new style has been loaded.
  ///
  /// The style transition is re-evaluated when a new style is loaded.
  ///
  /// @return The `transition options` of the current style in use.
  Future<TransitionOptions> getStyleTransition() async {
    final result =
        await _methodChannel.invokeMethod('getStyleTransition', null);
    if (result is! TransitionOptions) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Overrides the map style's transition options with user-provided options.
  ///
  /// The style transition is re-evaluated when a new style is loaded.
  ///
  /// @param transitionOptions The `transition options`.
  Future<void> setStyleTransition(
    TransitionOptions argTransitionoptions,
  ) async {
    final args = <String, dynamic>{};
    args['transition'] = argTransitionoptions;
    final result =
        await _methodChannel.invokeMethod('setStyleTransition', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Adds a new [style layer](https://docs.mapbox.com/mapbox-gl-js/style-spec/#layers).
  ///
  /// Runtime style layers are valid until they are either removed or a new style is loaded.
  ///
  /// @param properties A map of style layer properties.
  /// @param layerPosition If not empty, the new layer will be positioned according to `layer position` parameters.
  ///
  /// @return A string describing an error if the operation was not successful, or empty otherwise.
  Future<void> addStyleLayer(
    String argProperties,
    LayerPosition? argLayerposition,
  ) async {
    final args = <String, dynamic>{};
    args['properties'] = argProperties;
    args['layerposition'] = argLayerposition;
    final result = await _methodChannel.invokeMethod('addStyleLayer', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Adds a new [style layer](https://docs.mapbox.com/mapbox-gl-js/style-spec/#layers).
  ///
  /// Whenever a new style is being parsed and currently used style has persistent layers,
  /// an engine will try to do following:
  ///   - keep the persistent layer at its relative position
  ///   - keep the source used by a persistent layer
  ///   - keep images added through `addStyleImage` method
  ///
  /// In cases when a new style has the same layer, source or image resource, style's resources would be
  /// used instead and `MapLoadingError` event will be emitted.
  ///
  /// @param properties A map of style layer properties.
  /// @param layerPosition If not empty, the new layer will be positioned according to `layer position` parameters.
  ///
  /// @return A string describing an error if the operation was not successful, or empty otherwise.
  Future<void> addPersistentStyleLayer(
    String argProperties,
    LayerPosition? argLayerposition,
  ) async {
    final args = <String, dynamic>{};
    args['properties'] = argProperties;
    args['layerposition'] = argLayerposition;
    final result =
        await _methodChannel.invokeMethod('addPersistentStyleLayer', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Checks if a style layer is persistent.
  ///
  /// @param layerId A style layer identifier.
  /// @return A string describing an error if the operation was not successful, boolean representing state otherwise.
  Future<bool> isStyleLayerPersistent(String argLayerid) async {
    final args = <String, dynamic>{};
    args['id'] = argLayerid;
    final result =
        await _methodChannel.invokeMethod('isStyleLayerPersistent', args);
    if (result is! bool) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Removes an existing style layer.
  ///
  /// @param layerId An identifier of the style layer to remove.
  ///
  /// @return A string describing an error if the operation was not successful, or empty otherwise.
  Future<void> removeStyleLayer(String argLayerid) async {
    final args = <String, dynamic>{};
    args['id'] = argLayerid;
    final result = await _methodChannel.invokeMethod('removeStyleLayer', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Moves an existing style layer
  ///
  /// @param layerId Identifier of the style layer to move.
  /// @param layerPosition The layer will be positioned according to the LayerPosition parameters. If an empty LayerPosition
  ///                      is provided then the layer is moved to the top of the layerstack.
  ///
  /// @return A string describing an error if the operation was not successful, or empty otherwise.
  Future<void> moveStyleLayer(
    String argLayerid,
    LayerPosition? argLayerposition,
  ) async {
    final args = <String, dynamic>{};
    args['id'] = argLayerid;
    args['layerposition'] = argLayerposition;
    final result = await _methodChannel.invokeMethod('moveStyleLayer', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Checks whether a given style layer exists.
  ///
  /// @param layerId Style layer identifier.
  ///
  /// @return A `true` value if the given style layer exists, `false` otherwise.
  Future<bool> styleLayerExists(String argLayerid) async {
    final args = <String, dynamic>{};
    args['id'] = argLayerid;
    final result = await _methodChannel.invokeMethod('styleLayerExists', args);
    if (result is! bool) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Returns the existing style layers.
  ///
  /// @return The list containing the information about existing style layer objects.
  Future<List<StyleObjectInfo?>> getStyleLayers() async {
    final result = await _methodChannel.invokeMethod('getStyleLayers', null);
    if (result == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return (result as List<Object?>).cast<StyleObjectInfo?>();
  }

  /// Gets the value of style layer property.
  ///
  /// @param layerId A style layer identifier.
  /// @param property The style layer property name.
  /// @return The `style property value`.
  Future<StylePropertyValue> getStyleLayerProperty(
    String argLayerid,
    String argProperty,
  ) async {
    final args = <String, dynamic>{};
    args['id'] = argLayerid;
    args['property'] = argProperty;
    final result =
        await _methodChannel.invokeMethod('getStyleLayerProperty', null);
    if (result is! StylePropertyValue) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Sets a value to a style layer property.
  ///
  /// @param layerId A style layer identifier.
  /// @param property The style layer property name.
  /// @param value The style layer property value.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  Future<void> setStyleLayerProperty(
    String argLayerid,
    String argProperty,
    Object argValue,
  ) async {
    final args = <String, dynamic>{};
    args['id'] = argLayerid;
    args['property'] = argProperty;
    args['value'] = argValue;
    final result =
        await _methodChannel.invokeMethod('setStyleLayerProperty', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Gets style layer properties.
  ///
  /// @return The style layer properties or a string describing an error if the operation was not successful.
  Future<String> getStyleLayerProperties(String argLayerid) async {
    final args = <String, dynamic>{};
    args['id'] = argLayerid;
    final result =
        await _methodChannel.invokeMethod('getStyleLayerProperties', args);
    if (result is! String) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Sets style layer properties.
  /// This method can be used to perform batch update for a style layer properties. The structure of a
  /// provided `properties` value must conform to a format for a corresponding [layer type](https://docs.mapbox.com/mapbox-gl-js/style-spec/layers/).
  /// Modification of a layer [id](https://docs.mapbox.com/mapbox-gl-js/style-spec/layers/#id) and/or a [layer type] (https://docs.mapbox.com/mapbox-gl-js/style-spec/layers/#type) is not allowed.
  ///
  /// @param layerId A style layer identifier.
  /// @param properties A map of style layer properties.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  Future<void> setStyleLayerProperties(
    String argLayerid,
    String argProperties,
  ) async {
    final args = <String, dynamic>{};
    args['id'] = argLayerid;
    args['properties'] = argProperties;
    final result =
        await _methodChannel.invokeMethod('setStyleLayerProperties', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Adds a new [style source](https://docs.mapbox.com/mapbox-gl-js/style-spec/#sources).
  ///
  /// @param sourceId An identifier for the style source.
  /// @param properties A map of style source properties.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  Future<void> addStyleSource(String argSourceid, String argProperties) async {
    final args = <String, dynamic>{};
    args['id'] = argSourceid;
    args['properties'] = argProperties;
    final result = await _methodChannel.invokeMethod('addStyleSource', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Gets the value of style source property.
  ///
  /// @param sourceId A style source identifier.
  /// @param property The style source property name.
  /// @return The value of a `property` in the source with a `sourceId`.
  Future<StylePropertyValue> getStyleSourceProperty(
    String argSourceid,
    String argProperty,
  ) async {
    final args = <String, dynamic>{};
    args['id'] = argSourceid;
    args['property'] = argProperty;
    final result =
        await _methodChannel.invokeMethod('getStyleSourceProperty', args);
    if (result is! StylePropertyValue) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Sets a value to a style source property.
  /// Note: When setting the `data` property of a `geojson` source, this method never returns an error.
  /// In case of success, a `map-loaded` event will be propagated. In case of errors, a `map-loading-error` event will be propagated instead.
  ///
  ///
  /// @param sourceId A style source identifier.
  /// @param property The style source property name.
  /// @param value The style source property value.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  Future<void> setStyleSourceProperty(
    String argSourceid,
    String argProperty,
    Object argValue,
  ) async {
    final args = <String, dynamic>{};
    args['id'] = argSourceid;
    args['property'] = argProperty;
    args['value'] = argValue;
    final result =
        await _methodChannel.invokeMethod('setStyleSourceProperty', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Gets style source properties.
  ///
  /// @param sourceId A style source identifier.
  ///
  /// @return The style source properties or a string describing an error if the operation was not successful.
  Future<String> getStyleSourceProperties(String argSourceid) async {
    final args = <String, dynamic>{};
    args['id'] = argSourceid;
    final result =
        await _methodChannel.invokeMethod('getStyleSourceProperties', args);
    if (result is! String) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Sets style source properties.
  ///
  /// This method can be used to perform batch update for a style source properties. The structure of a
  /// provided `properties` value must conform to a format for a corresponding [source type](https://docs.mapbox.com/mapbox-gl-js/style-spec/sources/).
  /// Modification of a source [type](https://docs.mapbox.com/mapbox-gl-js/style-spec/sources/#type) is not allowed.
  ///
  /// @param sourceId A style source identifier.
  /// @param properties A map of Style source properties.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  Future<void> setStyleSourceProperties(
    String argSourceid,
    String argProperties,
  ) async {
    final args = <String, dynamic>{};
    args['id'] = argSourceid;
    args['properties'] = argProperties;
    final result =
        await _methodChannel.invokeMethod('setStyleSourceProperties', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Updates the image of an [image style source](https://docs.mapbox.com/mapbox-gl-js/style-spec/#sources-image).
  ///
  /// @param sourceId A style source identifier.
  /// @param image An `image`.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  Future<void> updateStyleImageSourceImage(
    String argSourceid,
    MbxImage argImage,
  ) async {
    final args = <String, dynamic>{};
    args['id'] = argSourceid;
    args['image'] = argImage;
    final result =
        await _methodChannel.invokeMethod('updateStyleImageSourceImage', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Removes an existing style source.
  ///
  /// @param sourceId An identifier of the style source to remove.
  Future<void> removeStyleSource(String argSourceid) async {
    final args = <String, dynamic>{};
    args['id'] = argSourceid;
    final result = await _methodChannel.invokeMethod('removeStyleSource', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Checks whether a given style source exists.
  ///
  /// @param sourceId A style source identifier.
  ///
  /// @return `true` if the given source exists, `false` otherwise.
  Future<bool> styleSourceExists(String argSourceid) async {
    final args = <String, dynamic>{};
    args['id'] = argSourceid;
    final result = await _methodChannel.invokeMethod('styleSourceExists', args);
    if (result is! bool) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Returns the existing style sources.
  ///
  /// @return The list containing the information about existing style source objects.
  Future<List<StyleObjectInfo?>> getStyleSources() async {
    final result = await _methodChannel.invokeMethod('getStyleSources', null);
    if (result is! List) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return (result as List<Object?>).cast<StyleObjectInfo?>();
  }

  /// Sets the style global [light](https://docs.mapbox.com/mapbox-gl-js/style-spec/#light) properties.
  ///
  /// @param properties A map of style light properties values, with their names as a key.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  Future<void> setStyleLight(String argProperties) async {
    final args = <String, dynamic>{};
    args['properties'] = argProperties;
    final result = await _methodChannel.invokeMethod('setStyleLight', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Gets the value of a style light property.
  ///
  /// @param property The style light property name.
  /// @return The style light property value.
  Future<StylePropertyValue> getStyleLightProperty(String argProperty) async {
    final args = <String, dynamic>{};
    args['property'] = argProperty;
    final result =
        await _methodChannel.invokeMethod('getStyleLightProperty', args);
    if (result is! StylePropertyValue) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Sets a value to the the style light property.
  ///
  /// @param property The style light property name.
  /// @param value The style light property value.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  Future<void> setStyleLightProperty(
    String argProperty,
    Object argValue,
  ) async {
    final args = <String, dynamic>{};
    args['property'] = argProperty;
    args['value'] = argValue;
    final result =
        await _methodChannel.invokeMethod('setStyleLightProperty', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Sets the style global [terrain](https://docs.mapbox.com/mapbox-gl-js/style-spec/#terrain) properties.
  ///
  /// @param properties A map of style terrain properties values, with their names as a key.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  Future<void> setStyleTerrain(String argProperties) async {
    final args = <String, dynamic>{};
    args['properties'] = argProperties;
    final result = await _methodChannel.invokeMethod('setStyleTerrain', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Gets the value of a style terrain property.
  ///
  /// @param property The style terrain property name.
  /// @return The style terrain property value.
  Future<StylePropertyValue> getStyleTerrainProperty(String argProperty) async {
    final args = <String, dynamic>{};
    args['property'] = argProperty;
    final result =
        await _methodChannel.invokeMethod('getStyleTerrainProperty', args);
    if (result is! StylePropertyValue) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Sets a value to the the style terrain property.
  ///
  /// @param property The style terrain property name.
  /// @param value The style terrain property value.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  Future<void> setStyleTerrainProperty(
    String argProperty,
    Object argValue,
  ) async {
    final args = <String, dynamic>{};
    args['property'] = argProperty;
    args['value'] = argValue;
    final result =
        await _methodChannel.invokeMethod('setStyleTerrainProperty', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Get an `image` from the style.
  ///
  /// @param imageId The identifier of the `image`.
  ///
  /// @return The `image` for the given `imageId`, or empty if no image is associated with the `imageId`.
  Future<MbxImage?> getStyleImage(String argImageid) async {
    final args = <String, dynamic>{};
    args['id'] = argImageid;
    final result = await _methodChannel.invokeMethod('getStyleImage', args);
    if (result == null) return null;
    if (result is! MbxImage) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Adds an image to be used in the style. This API can also be used for updating
  /// an image. If the image for a given `imageId` was already added, it gets replaced by the new image.
  ///
  /// The image can be used in [`icon-image`](https://www.mapbox.com/mapbox-gl-js/style-spec/#layout-symbol-icon-image),
  /// [`fill-pattern`](https://www.mapbox.com/mapbox-gl-js/style-spec/#paint-fill-fill-pattern),
  /// [`line-pattern`](https://www.mapbox.com/mapbox-gl-js/style-spec/#paint-line-line-pattern) and
  /// [`text-field`](https://www.mapbox.com/mapbox-gl-js/style-spec/#layout-symbol-text-field) properties.
  ///
  /// @param imageId An identifier of the image.
  /// @param scale A scale factor for the image.
  /// @param image A pixel data of the image.
  /// @param sdf An option to treat whether image is SDF(signed distance field) or not.
  /// @param stretchX An array of two-element arrays, consisting of two numbers that represent
  /// the from position and the to position of areas that can be stretched horizontally.
  /// @param stretchY An array of two-element arrays, consisting of two numbers that represent
  /// the from position and the to position of areas that can be stretched vertically.
  /// @param content An array of four numbers, with the first two specifying the left, top
  /// corner, and the last two specifying the right, bottom corner. If present, and if the
  /// icon uses icon-text-fit, the symbol's text will be fit inside the content box.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  Future<void> addStyleImage(
    String argImageid,
    double argScale,
    MbxImage argImage,
    bool argSdf,
    List<ImageStretches?> argStretchx,
    List<ImageStretches?> argStretchy,
    ImageContent? argContent,
  ) async {
    final args = <String, dynamic>{};
    args['id'] = argImageid;
    args['scale'] = argScale;
    args['image'] = argImage;
    args['sdf'] = argSdf;
    args['stretchX'] = argStretchx;
    args['stretchY'] = argStretchy;
    args['content'] = argContent;
    final result = await _methodChannel.invokeMethod('addStyleImage', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Removes an image from the style.
  ///
  /// @param imageId The identifier of the image to remove.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  Future<void> removeStyleImage(String argImageid) async {
    final args = <String, dynamic>{};
    args['id'] = argImageid;
    final result = await _methodChannel.invokeMethod('removeStyleImage', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Checks whether an image exists.
  ///
  /// @param imageId The identifier of the image.
  ///
  /// @return True if image exists, false otherwise.
  Future<bool> hasStyleImage(String argImageid) async {
    final args = <String, dynamic>{};
    args['id'] = argImageid;
    final result = await _methodChannel.invokeMethod('hasStyleImage', args);
    if (result is! bool) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Set tile data of a custom geometry.
  ///
  /// @param sourceId A style source identifier.
  /// @param tileId A `canonical tile id` of the tile.
  /// @param featureCollection An array with the features to add.
  /// Invalidate tile for provided custom geometry source.
  ///
  /// @param sourceId A style source identifier,.
  /// @param tileId A `canonical tile id` of the tile.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  Future<void> invalidateStyleCustomGeometrySourceTile(
    String argSourceid,
    CanonicalTileID argTileid,
  ) async {
    final args = <String, dynamic>{};
    args['id'] = argSourceid;
    args['tileId'] = argTileid;
    final result = await _methodChannel.invokeMethod(
      'invalidateStyleCustomGeometrySourceTile',
      args,
    );
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Invalidate region for provided custom geometry source.
  ///
  /// @param sourceId A style source identifier
  /// @param bounds A `coordinate bounds` object.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  Future<void> invalidateStyleCustomGeometrySourceRegion(
    String argSourceid,
    CoordinateBounds argBounds,
  ) async {
    final args = <String, dynamic>{};
    args['id'] = argSourceid;
    args['bounds'] = argBounds;
    final result = await _methodChannel.invokeMethod(
      'invalidateStyleCustomGeometrySourceRegion',
      args,
    );
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Check if the style is completely loaded.
  ///
  /// Note: The style specified sprite would be marked as loaded even with sprite loading error (An error will be emitted via `MapLoadingError`).
  /// Sprite loading error is not fatal and we don't want it to block the map rendering, thus the function will still return `true` if style and sources are fully loaded.
  ///
  /// @return `true` iff the style JSON contents, the style specified sprite and sources are all loaded, otherwise returns `false`.
  ///
  Future<bool> isStyleLoaded() async {
    final result = await _methodChannel.invokeMethod('isStyleLoaded', null);
    if (result is! bool) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Function to get the projection provided by the Style Extension.
  ///
  /// @return Projection that is currently applied to the map
  Future<String> getProjection() async {
    final result = await _methodChannel.invokeMethod('getProjection', null);
    if (result is! String) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
    return result;
  }

  /// Function to set the projection provided by the Style Extension.
  ///
  /// @param projection The projection to be set.
  Future<void> setProjection(String argProjection) async {
    final args = <String, dynamic>{};
    args['projection'] = argProjection;
    final result = await _methodChannel.invokeMethod('setProjection', args);
    if (result != null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    }
  }

  /// Function to localize style labels.
  ///
  /// @param locale The locale to apply for localization
  /// @param layerIds The ids of layers that will localize on, default is null which means will localize all the feasible layers.
  Future<void> localizeLabels(
    String argLocale,
    List<String?>? argLayerids,
  ) async {
    final args = <String, dynamic>{};
    args['locale'] = argLocale;
    args['layerids'] = argLayerids;
    final result = await _methodChannel.invokeMethod('localizeLabels', args);
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

/// Extension for StyleManager to add/update/get layers from the current style.
extension StyleLayer on StyleManager {
  /// Add a layer the the current style.
  Future<void> addLayer(Layer layer) {
    final encode = layer._encode();
    return addStyleLayer(encode, null);
  }

  /// Add a layer to the current style in a specific position.
  Future<void> addLayerAt(Layer layer, LayerPosition position) {
    final encode = layer._encode();
    return addStyleLayer(encode, position);
  }

  /// Update an exsiting layer in the style.
  Future<void> updateLayer(Layer layer) {
    final encode = layer._encode();
    return setStyleLayerProperties(layer.id, encode);
  }

  /// Get a previously added layer from the current style.
  Future<Layer?> getLayer(String layerId) async {
    final properties = await getStyleLayerProperties(layerId);

    Layer? layer;
    final map = json.decode(properties);

    final type = map['type'];
    switch (type) {
      case 'background':
        layer = BackgroundLayer.decode(properties);
        break;
      case 'location-indicator':
        layer = LocationIndicatorLayer.decode(properties);
        break;
      case 'sky':
        layer = SkyLayer.decode(properties);
        break;
      case 'circle':
        layer = CircleLayer.decode(properties);
        break;
      case 'fill-extrusion':
        layer = FillExtrusionLayer.decode(properties);
        break;
      case 'fill':
        layer = FillLayer.decode(properties);
        break;
      case 'heatmap':
        layer = HeatmapLayer.decode(properties);
        break;
      case 'hillshade':
        layer = HillshadeLayer.decode(properties);
        break;
      case 'line':
        layer = LineLayer.decode(properties);
        break;
      case 'raster':
        layer = RasterLayer.decode(properties);
        break;
      case 'symbol':
        layer = SymbolLayer.decode(properties);
        break;
      default:
        if (kDebugMode) {
          print('Layer type: $type unknown.');
        }
    }

    return Future.value(layer);
  }
}

/// Extension for StyleManager to add/get sources from the current style.
extension StyleSource on StyleManager {
  /// Adds a [source] to the style.
  ///
  /// The [source] parameter is the source to be added to the style.
  /// This method returns a [Future] that completes when the source has been added.
  ///
  /// The [nonVolatileProperties] and [volatileProperties] are properties of the source.
  /// The [nonVolatileProperties] are properties that do not change frequently,
  /// while the [volatileProperties] are properties that change frequently.
  ///
  /// The [source] is bound to the [StyleManager] using the [bind] method.
  ///
  /// After the source has been added to the style, the volatile properties are set
  /// using the [setStyleSourceProperties] method.
  ///
  /// Example usage:
  /// ```dart
  /// final source = Source();
  /// styleManager.addSource(source);
  /// ```
  Future<void> addSource(Source source) {
    final nonVolatileProperties = source._encode(false);
    final volatileProperties = source._encode(true);
    source.bind(this);
    return addStyleSource(source.id, nonVolatileProperties).then((value) {
      // volatile properties have to be set after the source has been added to the style
      setStyleSourceProperties(source.id, volatileProperties);
    });
  }

  /// Get the source with sourceId from the current style.
  Future<Source?> getSource(String sourceId) async {
    final properties = await getStyleSourceProperties(sourceId);

    Source? source;

    final map = json.decode(properties) as Map<String, dynamic>;

    final type = map['type'];
    switch (type) {
      case 'vector':
        source = VectorSource(id: sourceId);
        break;
      case 'geojson':
        source = GeoJsonSource(id: sourceId);
        break;
      case 'image':
        source = ImageSource(id: sourceId);
        break;
      case 'raster-dem':
        source = RasterDemSource(id: sourceId);
        break;
      case 'raster':
        source = RasterSource(id: sourceId);
        break;
      default:
        if (kDebugMode) {
          print('Source type: $type unknown.');
        }
    }

    source?.bind(this);
    return Future.value(source);
  }
}

/// Extension for StyleManager to set light in the current style.
extension StyleLight on StyleManager {
  Future<void> setLight(Light light) {
    final encode = light.encode();
    return setStyleLight(encode);
  }
}
