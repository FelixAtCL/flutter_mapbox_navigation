part of '../../mapbox_navigation_flutter.dart';

/// Influences the y direction of the tile coordinates. The global-mercator (aka Spherical Mercator) profile is assumed.
///
/// @param value
enum Scheme {
  /// Slippy map tilenames scheme.
  XYZ,

  /// OSGeo spec scheme.
  TMS,
}

/// The encoding used by this source. Mapbox Terrain RGB is used by default
///
/// @param value
enum Encoding {
  /// Terrarium format PNG tiles. See https://aws.amazon.com/es/public-datasets/terrain/ for more info.
  TERRARIUM,

  /// Mapbox Terrain RGB tiles. See https://www.mapbox.com/help/access-elevation-data/#mapbox-terrain-rgb for more info.
  MAPBOX,
}

/// The visibility of a layer.
enum Visibility {
  /// The layer is shown.
  VISIBLE,

  /// The layer is hidden.
  NONE
}

enum ModelType {
  /// Integrated to 3D scene, using depth testing, along with terrain, fill-extrusions and custom layer.
  COMMON_3D,

  /// Displayed over other 3D content, occluded by terrain.
  LOCATION_INDICATOR,
}

/// The type of the sky
enum SkyType {
  /// Renders the sky with a gradient that can be configured with {@link SKY_GRADIENT_RADIUS} and {@link SKY_GRADIENT}.
  GRADIENT,

  /// Renders the sky with a simulated atmospheric scattering algorithm, the sun direction can be attached to the light position or explicitly set through {@link SKY_ATMOSPHERE_SUN}.
  ATMOSPHERE,
}

/// The resampling/interpolation method to use for overscaling, also known as texture magnification filter
enum RasterResampling {
  /// (Bi)linear filtering interpolates pixel values using the weighted average of the four closest original source pixels creating a smooth but blurry look when overscaled
  LINEAR,

  /// Nearest neighbor filtering interpolates pixel values using the nearest original source pixel creating a sharp but pixelated look when overscaled
  NEAREST,
}

/// Direction of light source when map is rotated.
enum HillshadeIlluminationAnchor {
  /// The hillshade illumination is relative to the north direction.
  MAP,

  /// The hillshade illumination is relative to the top of the viewport.
  VIEWPORT,
}

/// Controls the frame of reference for `fill-extrusion-translate`.
enum FillExtrusionTranslateAnchor {
  /// The fill extrusion is translated relative to the map.
  MAP,

  /// The fill extrusion is translated relative to the viewport.
  VIEWPORT,
}

/// Whether extruded geometries are lit relative to the map or viewport.
enum Anchor {
  /// The position of the light source is aligned to the rotation of the map.
  MAP,

  /// The position of the light source is aligned to the rotation of the viewport.
  VIEWPORT,
}

/// Define the duration and delay for a style transition.
class StyleTransition {
  /// A class that represents a style transition.
  ///
  /// The `StyleTransition` class is used to define a transition for a style change.
  /// It takes a `duration` parameter to specify the duration of the transition,
  /// and an optional `delay` parameter to specify a delay before the transition starts.
  StyleTransition({this.duration, this.delay});

  /// Decodes the given properties string and returns a [StyleTransition] object.
  ///
  /// The [properties] parameter is a string representing the properties to be decoded.
  /// Returns a [StyleTransition] object that represents the decoded properties.
  StyleTransition.decode(String properties) {
    final map = json.decode(properties) as Map<String, dynamic>;
    duration = map['duration'] as int?;
    delay = map['delay'] as int?;
  }

  /// Duration of the transition.
  int? duration;

  /// Delay of the transition.
  int? delay;

  /// Encodes the style into a string representation.
  ///
  /// Returns the encoded string representation of the style.
  String encode() {
    final properties = <String, dynamic>{'duration': duration, 'delay': delay};
    return json.encode(properties);
  }
}

/// Super class for all different types of layers.
abstract class Layer {
  /// Creates a new instance of the [Layer] class.
  ///
  /// The [id] parameter is required and specifies the unique identifier of the layer.
  /// The [visibility] parameter is optional and determines the visibility of the layer.
  /// The [maxZoom] parameter is optional and sets the maximum zoom level at which the layer is visible.
  /// The [minZoom] parameter is optional and sets the minimum zoom level at which the layer is visible.
  Layer({required this.id, this.visibility, this.maxZoom, this.minZoom});

  /// The ID of the Layer.
  String id;

  /// The visibility of the layer.
  Visibility? visibility;

  /// The minimum zoom level for the layer. At zoom levels less than the minzoom, the layer will be hidden.
  ///
  /// Range:
  ///       minimum: 0
  ///       maximum: 24
  double? minZoom;

  /// The maximum zoom level for the layer. At zoom levels equal to or greater than the maxzoom, the layer will be hidden.
  ///
  /// Range:
  ///       minimum: 0
  ///       maximum: 24
  double? maxZoom;

  /// Get the type of current layer as a String.
  String getType();

  String _encode();
}

/// Super class for all different types of sources.
abstract class Source {
  /// Creates a new instance of the [Source] class with the specified [id].
  Source({required this.id});

  /// The ID of the Source.
  String id;

  /// Get the type of the current source as a String.
  String getType();

  String _encode(bool volatile);

  StyleManager? _style;

  /// Binds the given [style] to the current instance.
  void bind(StyleManager style) => _style = style;
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

/// Extension to convert color format
extension StyleColorInt on int {
  /// Convert the color from int format to a string with format "rgba(red, green, blue, alpha)".
  String toRGBA() {
    final color = Color(this);
    return 'rgba(${color.red}, ${color.green}, ${color.blue}, ${color.alpha})';
  }
}

extension StyleColorList on List {
  /// Convert the color from a list `[rgba, $R, $G, $B, $A]` to int.
  int toRGBAInt() {
    final alpha = this.last is num ? ((this.last as num) * 255).toInt() : null;
    final red = this[1] is num ? (this[1] as num).toInt() : null;
    final green = this[2] is num ? (this[2] as num).toInt() : null;
    final blue = this[3] is num ? (this[3] as num).toInt() : null;
    if (alpha != null && red != null && green != null && blue != null) {
      return Color.fromARGB(alpha, red, green, blue).value;
    } else {
      return 0;
    }
  }
}
