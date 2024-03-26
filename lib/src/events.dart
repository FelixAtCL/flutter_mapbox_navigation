part of '../mapbox_navigation_flutter.dart';

/// List of supported event types by the `map` and `map snapshotter` objects,
/// and event data format specification for each event.
///
/// ``` text
/// Simplified diagram for events emitted by the map object.
///
/// ┌─────────────┐               ┌─────────┐                   ┌──────────────┐
/// │ Application │               │   Map   │                   │ResourceLoader│
/// └──────┬──────┘               └────┬────┘                   └───────┬──────┘
///        │                           │                                │
///        ├───────setStyleURI────────▶│                                │
///        │                           ├───────────get style───────────▶│
///        │                           │                                │
///        │                           │◀─────────style data────────────┤
///        │                           │                                │
///        │                           ├─parse style─┐                  │
///        │                           │             │                  │
///        │      StyleDataLoaded      ◀─────────────┘                  │
///        │◀────{"type": "style"}─────┤                                │
///        │                           ├─────────get sprite────────────▶│
///        │                           │                                │
///        │                           │◀────────sprite data────────────┤
///        │                           │                                │
///        │                           ├──────parse sprite───────┐      │
///        │                           │                         │      │
///        │      StyleDataLoaded      ◀─────────────────────────┘      │
///        │◀───{"type": "sprite"}─────┤                                │
///        │                           ├─────get source TileJSON(s)────▶│
///        │                           │                                │
///        │     SourceDataLoaded      │◀─────parse TileJSON data───────┤
///        │◀──{"type": "metadata"}────┤                                │
///        │                           │                                │
///        │                           │                                │
///        │      StyleDataLoaded      │                                │
///        │◀───{"type": "sources"}────┤                                │
///        │                           ├──────────get tiles────────────▶│
///        │                           │                                │
///        │◀───────StyleLoaded────────┤                                │
///        │                           │                                │
///        │     SourceDataLoaded      │◀─────────tile data─────────────┤
///        │◀────{"type": "tile"}──────┤                                │
///        │                           │                                │
///        │                           │                                │
///        │◀────RenderFrameStarted────┤                                │
///        │                           ├─────render─────┐               │
///        │                           │                │               │
///        │                           ◀────────────────┘               │
///        │◀───RenderFrameFinished────┤                                │
///        │                           ├──render, all tiles loaded──┐   │
///        │                           │                            │   │
///        │                           ◀────────────────────────────┘   │
///        │◀────────MapLoaded─────────┤                                │
///        │                           │                                │
///        │                           │                                │
///        │◀─────────MapIdle──────────┤                                │
///        │                    ┌ ─── ─┴─ ─── ┐                         │
///        │                    │   offline   │                         │
///        │                    └ ─── ─┬─ ─── ┘                         │
///        │                           │                                │
///        ├─────────setCamera────────▶│                                │
///        │                           ├───────────get tiles───────────▶│
///        │                           │                                │
///        │                           │┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─   │
///        │◀─────────MapIdle──────────┤   waiting for connectivity  │  │
///        │                           ││  Map renders cached data      │
///        │                           │ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘  │
///        │                           │                                │
/// ```
class MapEvents {
  /// The style has been fully loaded, and the `map` has rendered all visible tiles.
  ///
  /// ``` text
  /// Event data format (Object).
  /// ```
  static const String MAP_LOADED = 'map-loaded';

  /// Describes an error that has occured while loading the Map. The `type` property defines what resource could
  /// not be loaded and the `message` property will contain a descriptive error message.
  /// In case of `source` or `tile` loading errors, `source-id` will contain the id of the source failing.
  /// In case of `tile` loading errors, `tile-id` will contain the id of the tile
  ///
  /// ``` text
  /// Event data format (Object):
  /// .
  /// ├── type - String ("style" | "sprite" | "source" | "tile" | "glyphs")
  /// ├── message - String
  /// ├── source-id - optional String
  /// └── tile-id - optional Object
  ///     ├── z Number (zoom level)
  ///     ├── x Number (x coorinate)
  ///     └── y Number (y coorinate)
  /// ```
  static const String MAP_LOADING_ERROR = 'map-loading-error';

  /// The `map` has entered the idle state. The `map` is in the idle state when there are no ongoing transitions
  /// and the `map` has rendered all requested non-volatile tiles. The event will not be emitted if `setUserAnimationInProgress`
  /// and / or `setGestureInProgress` is set to `true`.
  ///
  /// ``` text
  /// Event data format (Object).
  /// ```
  static const String MAP_IDLE = 'map-idle';

  /// The requested style data has been loaded. The `type` property defines what kind of style data has been loaded.
  /// Event may be emitted synchronously, for example, when `setStyleJSON` is used to load style.
  ///
  /// Based on an event data `type` property value, following use-cases may be implemented:
  /// - `style`: Style is parsed, style layer properties could be read and modified, style layers and sources could be
  ///   added or removed before rendering is started.
  /// - `sprite`: Style's sprite sheet is parsed and it is possible to add or update images.
  /// - `sources`: All sources defined by the style are loaded and their properties could be read and updated if needed.
  ///
  /// ``` text
  /// Event data format (Object):
  /// .
  /// └── type - String ("style" | "sprite" | "sources")
  /// ```
  static const String STYLE_DATA_LOADED = 'style-data-loaded';

  /// The requested style has been fully loaded, including the style, specified sprite and sources' metadata.
  ///
  /// ``` text
  /// Event data format (Object).
  /// ```
  ///
  /// Note: The style specified sprite would be marked as loaded even with sprite loading error (An error will be emitted via `MapLoadingError`).
  /// Sprite loading error is not fatal and we don't want it to block the map rendering, thus this event will still be emitted if style and sources are fully loaded.
  ///
  static const String STYLE_LOADED = 'style-loaded';

  /// A style has a missing image. This event is emitted when the `map` renders visible tiles and
  /// one of the required images is missing in the sprite sheet. Subscriber has to provide the missing image
  /// by calling `addStyleImage` method.
  ///
  /// ``` text
  /// Event data format (Object):
  /// .
  /// └── id - String
  /// ```
  static const String STYLE_IMAGE_MISSING = 'style-image-missing';

  /// An image added to the style is no longer needed and can be removed using `removeStyleImage` method.
  ///
  /// ``` text
  /// Event data format (Object):
  /// .
  /// └── id - String
  /// ```
  static const String STYLE_IMAGE_REMOVE_UNUSED = 'style-image-remove-unused';

  /// A source data has been loaded.
  /// Event may be emitted synchronously in cases when source's metadata is available when source is added to the style.
  ///
  /// The `id` property defines the source id.
  ///
  /// The `type` property defines if source's metadata (e.g., TileJSON) or tile has been loaded. The property of `metadata`
  /// value might be useful to identify when particular source's metadata is loaded, thus all source's properties are
  /// readable and can be updated before `map` will start requesting data to be rendered.
  ///
  /// The `loaded` property will be set to `true` if all source's data required for visible viewport of the `map`, are loaded.
  /// The `tile-id` property defines the tile id if the `type` field equals `tile`.
  ///
  /// ``` text
  /// Event data format (Object):
  /// .
  /// ├── id - String
  /// ├── type - String ("metadata" | "tile")
  /// ├── loaded - optional Boolean
  /// └── tile-id - optional Object
  ///     ├── z Number (zoom level)
  ///     ├── x Number (x coorinate)
  ///     └── y Number (y coorinate)
  /// ```
  static const String SOURCE_DATA_LOADED = 'source-data-loaded';

  /// The source has been added with `addStyleSource` method.
  /// The event is emitted synchronously, therefore, it is possible to immediately
  /// read added source's properties.
  ///
  /// ``` text
  /// Event data format (Object):
  /// .
  /// └── id - String
  /// ```
  static const String SOURCE_ADDED = 'source-added';

  /// The source has been removed with `removeStyleSource` method.
  /// The event is emitted synchronously, thus, `getStyleSources` will be
  /// in sync when the `observer` receives the notification.
  ///
  /// ``` text
  /// Event data format (Object):
  /// .
  /// └── id - String
  /// ```
  static const String SOURCE_REMOVED = 'source-removed';

  /// The `map` started rendering a frame.
  ///
  /// Event data format (Object).
  static const String RENDER_FRAME_STARTED = 'render-frame-started';

  /// The `map` finished rendering a frame.
  /// The `render-mode` property tells whether the `map` has all data (`full`) required to render the visible viewport.
  /// The `needs-repaint` property provides information about ongoing transitions that trigger `map` repaint.
  /// The `placement-changed` property tells if the symbol placement has been changed in the visible viewport.
  ///
  /// ``` text
  /// Event data format (Object):
  /// .
  /// ├── render-mode - String ("partial" | "full")
  /// ├── needs-repaint - Boolean
  /// └── placement-changed - Boolean
  /// ```
  static const String RENDER_FRAME_FINISHED = 'render-frame-finished';

  /// The camera has changed. This event is emitted whenever the visible viewport
  /// changes due to the invocation of `setSize`, `setBounds` methods or when the camera
  /// is modified by calling camera methods. The event is emitted synchronously,
  /// so that an updated camera state can be fetched immediately.
  ///
  /// ``` text
  /// Event data format (Object).
  /// ```
  static const String CAMERA_CHANGED = 'camera-changed';

  /// The `ResourceRequest` event allows client to observe resource requests made by a
  /// `map` or `map snapshotter` objects.
  ///
  /// ``` text
  /// Event data format (Object):
  /// .
  /// ├── data-source - String ("resource-loader" | "network" | "database" | "asset" | "file-system")
  /// ├── request - Object
  /// │   ├── url - String
  /// │   ├── kind - String ("unknown" | "style" | "source" | "tile" | "glyphs" | "sprite-image" | "sprite-json" | "image")
  /// │   ├── priority - String ("regular" | "low")
  /// │   └── loading-method - Array ["cache" | "network"]
  /// ├── response - optional Object
  /// │   ├── no-content - Boolean
  /// │   ├── not-modified - Boolean
  /// │   ├── must-revalidate - Boolean
  /// │   ├── source - String ("network" | "cache" | "tile-store" | "local-file")
  /// │   ├── size - Number (size in bytes)
  /// │   ├── modified - optional String, rfc1123 timestamp
  /// │   ├── expires - optional String, rfc1123 timestamp
  /// │   ├── etag - optional String
  /// │   └── error - optional Object
  /// │       ├── reason - String ("success" | "not-found" | "server" | "connection" | "rate-limit" | "in-offline-mode" | "other")
  /// │       └── message - String
  /// └── cancelled - Boolean
  /// ```
  static const String RESOURCE_REQUEST = 'resource-request';
}

/// The class for camera-changed event in Observer
class CameraChangedEventData {
  /// Creates a new instance of [CameraChangedEventData] from a JSON map.
  ///
  /// The [json] parameter is a map containing the JSON data for the event.
  /// Returns an instance of [CameraChangedEventData].
  CameraChangedEventData.fromJson(Map<String, dynamic> json)
      : begin = json['begin'] as int? ?? 0,
        end = json['end'] as int? ?? 0;

  /// Representing timestamp taken at the time of an event creation; in microseconds; since the epoch.
  final int begin;

  /// For an interfinal events; an optional `end` property will be present that represents timestamp taken at the time
  /// of an event completion.
  final int? end;
}

/// The class for map-idle event in Observer
class MapIdleEventData {
  /// Creates a new instance of [MapIdleEventData] from a JSON map.
  ///
  /// The [json] parameter is a map containing the JSON data for the event.
  /// Returns an instance of [MapIdleEventData].
  MapIdleEventData.fromJson(Map<String, dynamic> json)
      : begin = json['begin'] as int? ?? 0,
        end = json['end'] as int? ?? 0;

  /// Representing timestamp taken at the time of an event creation; in microseconds; since the epoch.
  final int begin;

  /// For an interfinal events; an optional `end` property will be present that represents timestamp taken at the time
  /// of an event completion.
  final int? end;
}

/// The class for map-loaded event in Observer
class MapLoadedEventData {
  /// Creates a new instance of [MapLoadedEventData] from a JSON map.
  ///
  /// The [json] parameter is a map containing the JSON data for the event.
  /// Returns an instance of [MapLoadedEventData].
  MapLoadedEventData.fromJson(Map<String, dynamic> json)
      : begin = json['begin'] as int? ?? 0,
        end = json['end'] as int? ?? 0;

  /// Representing timestamp taken at the time of an event creation; in microseconds; since the epoch.
  final int begin;

  /// For an interfinal events; an optional `end` property will be present that represents timestamp taken at the time
  /// of an event completion.
  final int? end;
}

/// The class for map-loading-error event in Observer
class MapLoadingErrorEventData {
  /// Creates a new instance of [MapLoadingErrorEventData] from a JSON map.
  ///
  /// The [json] parameter is a map containing the JSON data to parse.
  /// Returns a new instance of [MapLoadingErrorEventData] with the parsed data.
  MapLoadingErrorEventData.fromJson(Map<String, dynamic> json)
      : begin = json['begin'] as int? ?? 0,
        end = json['end'] as int? ?? 0,
        type = EnumToString.fromString(
          MapLoadErrorType.values,
          (json['type'] as String? ?? '').toUpperCase().replaceAll('-', '_'),
        )!,
        message = json['message'] as String? ?? '',
        sourceId = json['source-id'] as String? ?? '',
        tileId = json['tile-id'] != null
            ? TileID.fromJson(json['tile-id'] as Map<String, dynamic>? ?? {})
            : null;

  /// Representing timestamp taken at the time of an event creation; in microseconds; since the epoch.
  final int begin;

  /// For an interfinal events; an optional `end` property will be present that represents timestamp taken at the time
  /// of an event completion.
  final int? end;

  /// Defines what resource could not be loaded.
  final MapLoadErrorType type;

  /// The descriptive error message of the error.
  final String message;

  /// In case of `source` or `tile` loading errors; `source-id` will contain the id of the source failing.
  final String? sourceId;

  /// In case of `tile` loading errors; `tile-id` will contain the id of the tile.
  final TileID? tileId;
}

/// The class for render-frame-finished event in Observer
class RenderFrameFinishedEventData {
  /// Creates a new instance of [RenderFrameFinishedEventData] from a JSON map.
  ///
  /// The [json] parameter is a map containing the JSON data to parse.
  /// Returns a new instance of [RenderFrameFinishedEventData] with the parsed data.
  RenderFrameFinishedEventData.fromJson(Map<String, dynamic> json)
      : begin = json['begin'] as int? ?? 0,
        end = json['end'] as int? ?? 0,
        renderMode = EnumToString.fromString(
          RenderMode.values,
          (json['render-mode'] as String? ?? '')
              .toUpperCase()
              .replaceAll('-', '_'),
        )!,
        placementChanged = json['placement-changed'] as bool? ?? false,
        needsRepaint = json['needs-repaint'] as bool? ?? false;

  /// Representing timestamp taken at the time of an event creation; in microseconds; since the epoch.
  final int begin;

  /// For an interfinal events; an optional `end` property will be present that represents timestamp taken at the time
  /// of an event completion.
  final int? end;

  /// The render-mode finalue tells whether the Map has all {"full"} required to render the visible viewport.
  final RenderMode renderMode;

  /// The needs-repaint finalue provides information about ongoing transitions that trigger Map repaint.
  final bool needsRepaint;

  /// The placement-changed finalue tells if the symbol placement has been changed in the visible viewport.
  final bool placementChanged;
}

/// Describes whether a map or frame has been fully rendered or not.
/// @param value String value of this enum
enum RenderMode {
  /// The map is partially rendered. Partially rendered map means
  /// that not all data needed to render the map has been arrived
  /// from the network or being parsed.
  PARTIAL,

  /// The map is fully rendered.  */
  FULL
}

/// The class for render-frame-started event in Observer
class RenderFrameStartedEventData {
  /// Creates a new instance of [RenderFrameStartedEventData] from a JSON map.
  ///
  /// The [json] parameter is a map containing the JSON data to parse.
  /// Returns a new instance of [RenderFrameStartedEventData] with the parsed data.
  RenderFrameStartedEventData.fromJson(Map<String, dynamic> json)
      : begin = json['begin'] as int? ?? 0,
        end = json['end'] as int? ?? 0;

  /// Representing timestamp taken at the time of an event creation; in microseconds; since the epoch.
  final int begin;

  /// For an interfinal events; an optional `end` property will be present that represents timestamp taken at the time
  /// of an event completion.
  final int? end;
}

///The class for event in Observer
class ResourceEventData {
  /// Creates a new instance of [ResourceEventData] from a JSON map.
  ///
  /// The [json] parameter is a map containing the JSON data to parse.
  /// Returns a new instance of [ResourceEventData] with the parsed data.
  ResourceEventData.fromJson(Map<String, dynamic> json)
      : begin = json['begin'] as int? ?? 0,
        end = json['end'] as int? ?? 0,
        dataSource = EnumToString.fromString(
          DataSourceType.values,
          (json['data-source'] as String? ?? '')
              .toUpperCase()
              .replaceAll('-', '_'),
        )!,
        request =
            Request.fromJson(json['request'] as Map<String, dynamic>? ?? {}),
        response = json['response'] != null
            ? Response.fromJson(json['response'] as Map<String, dynamic>? ?? {})
            : null,
        cancelled = json['cancelled'] as bool? ?? false;

  /// Representing timestamp taken at the time of an event creation; in microseconds; since the epoch.
  final int begin;

  /// For an interfinal events; an optional `end` property will be present that represents timestamp taken at the time
  /// of an event completion.
  final int? end;

  /// "data-source" property
  final DataSourceType dataSource;

  /// "request" property
  final Request request;

  /// "response" property
  final Response? response;

  /// "cancelled" property
  final bool cancelled;
}

/// Describes data source of request for resource-request event.
/// @param value String value of this enum
enum DataSourceType {
  /// data source as resource-loader.
  RESOURCE_LOADER,

  /// data source as network.
  NETWORK,

  /// data source as database.
  DATABASE,

  /// data source as asset.
  ASSET,

  /// data source as file-system.
  FILE_SYSTEM,
}

/// The class for source-added event in Observer
class SourceAddedEventData {
  /// Creates a new instance of [SourceAddedEventData] from a JSON map.
  ///
  /// The [json] parameter is a map containing the JSON data to parse.
  /// Returns a new instance of [SourceAddedEventData] with the parsed data.
  SourceAddedEventData.fromJson(Map<String, dynamic> json)
      : begin = json['begin'] as int? ?? 0,
        end = json['end'] as int? ?? 0,
        id = json['id'] as String? ?? '';

  /// Representing timestamp taken at the time of an event creation; in microseconds; since the epoch.
  final int begin;

  /// For an interfinal events; an optional `end` property will be present that represents timestamp taken at the time
  /// of an event completion.
  final int? end;

  /// The ID of the added source.
  final String id;
}

/// The class for source-data-loaded event in Observer
class SourceDataLoadedEventData {
  SourceDataLoadedEventData.fromJson(Map<String, dynamic> json)
      : begin = json['begin'] as int? ?? 0,
        end = json['end'] as int? ?? 0,
        id = json['id'] as String? ?? '',
        type = EnumToString.fromString(
          SourceDataType.values,
          (json['type'] as String? ?? '').toUpperCase().replaceAll('-', '_'),
        )!,
        loaded = json['loaded'] as bool? ?? false,
        tileID = json['tile-id'] != null
            ? TileID.fromJson(json['tile-id'] as Map<String, dynamic>? ?? {})
            : null;

  /// Representing timestamp taken at the time of an event creation; in microseconds; since the epoch.
  final int begin;

  /// For an interfinal events; an optional `end` property will be present that represents timestamp taken at the time
  /// of an event completion.
  final int? end;

  /// The 'id' property defines the source id.
  final String id;

  /// The 'type' property defines if source's meta{e.g.; TileJSON} or tile has been loaded.
  final SourceDataType type;

  /// The 'loaded' property will be set to 'true' if all source's required for Map's visible viewport; are loaded.
  final bool? loaded;

  /// The 'tile-id' property defines the tile id if the 'type' field equals 'tile'.
  final TileID? tileID;
}

/// The class for source-removed event in Observer
class SourceRemovedEventData {
  /// Creates a new instance of [SourceRemovedEventData] from a JSON map.
  ///
  /// The [json] parameter is a map containing the JSON data to parse.
  /// Returns a new instance of [SourceRemovedEventData] with the parsed data.
  SourceRemovedEventData.fromJson(Map<String, dynamic> json)
      : begin = json['begin'] as int? ?? 0,
        end = json['end'] as int? ?? 0,
        id = json['id'] as String? ?? '';

  /// Representing timestamp taken at the time of an event creation; in microseconds; since the epoch.
  final int begin;

  /// For an interfinal events; an optional `end` property will be present that represents timestamp taken at the time
  /// of an event completion.
  final int? end;

  /// The ID of the removed source.
  final String id;
}

/// The class for style-data-loaded event in Observer
class StyleDataLoadedEventData {
  /// Creates a new instance of [StyleDataLoadedEventData] from a JSON map.
  ///
  /// The [json] parameter is a map containing the JSON data to parse.
  /// Returns a new instance of [StyleDataLoadedEventData] with the parsed data.
  StyleDataLoadedEventData.fromJson(Map<String, dynamic> json)
      : begin = json['begin'] as int? ?? 0,
        end = json['end'] as int? ?? 0,
        type = EnumToString.fromString(
          StyleDataType.values,
          (json['type'] as String? ?? '').toUpperCase().replaceAll('-', '_'),
        )!;

  /// Representing timestamp taken at the time of an event creation; in microseconds; since the epoch.
  final int begin;

  /// For an interfinal events; an optional `end` property will be present that represents timestamp taken at the time
  /// of an event completion.
  final int? end;

  /// The 'type' property defines what kind of style has been loaded.
  final StyleDataType type;
}

/// The class for style-image-missing event in Observer
class StyleImageMissingEventData {
  /// Creates a new instance of [StyleImageMissingEventData] from a JSON map.
  ///
  /// The [json] parameter is a map containing the JSON data to parse.
  /// Returns a new instance of [StyleImageMissingEventData] with the parsed data.
  StyleImageMissingEventData.fromJson(Map<String, dynamic> json)
      : begin = json['begin'] as int? ?? 0,
        end = json['end'] as int? ?? 0,
        id = json['id'] as String? ?? '';

  /// Representing timestamp taken at the time of an event creation; in microseconds; since the epoch.
  final int begin;

  /// For an interfinal events; an optional `end` property will be present that represents timestamp taken at the time
  /// of an event completion.
  final int? end;

  /// The ID of the missing image.
  final String id;
}

/// The class for style-image-remove-unused event in Observer
class StyleImageUnusedEventData {
  /// Creates a new instance of [StyleImageUnusedEventData] from a JSON map.
  ///
  /// The [json] parameter is a map containing the JSON data to parse.
  /// Returns a new instance of [StyleImageUnusedEventData] with the parsed data.
  StyleImageUnusedEventData.fromJson(Map<String, dynamic> json)
      : begin = json['begin'] as int? ?? 0,
        end = json['end'] as int? ?? 0,
        id = json['id'] as String? ?? '';

  /// Representing timestamp taken at the time of an event creation; in microseconds; since the epoch.
  final int begin;

  /// For an interfinal events; an optional `end` property will be present that represents timestamp taken at the time
  /// of an event completion.
  final int? end;

  /// The ID of the unused image.
  final String id;
}

/// The class for style-loaded event in Observer
class StyleLoadedEventData {
  /// Creates a new instance of [StyleLoadedEventData] from a JSON map.
  ///
  /// The [json] parameter is a map containing the JSON data to parse.
  /// Returns a new instance of [StyleLoadedEventData] with the parsed data.
  StyleLoadedEventData.fromJson(Map<String, dynamic> json)
      : begin = json['begin'] as int? ?? 0,
        end = json['end'] as int? ?? 0;

  /// Representing timestamp taken at the time of an event creation; in microseconds; since the epoch.
  final int begin;

  /// For an interfinal events; an optional `end` property will be present that represents timestamp taken at the time
  /// of an event completion.
  final int? end;
}

/// Describes an error type while loading the map.
/// Defines what resource could not be loaded.
/// @param finalue String finalue of this enum
enum MapLoadErrorType {
  /// An error related to style.
  STYLE,

  /// An error related to sprite.
  SPRITE,

  /// An error related to source.
  SOURCE,

  /// An error related to tile.
  TILE,

  /// An error related to glyphs.
  GLYPHS
}

/// Defines what kind of style data has been loaded in a style-data-loaded event.
/// @param finalue String finalue of this enum
enum StyleDataType {
  /// The style data loaded event is associated with style.
  STYLE,

  /// The style data loaded event is associated with sprite.
  SPRITE,

  /// The style data loaded event is associated with sources.
  SOURCES
}

/// Defines what kind of source data has been loaded in a source-data-loaded event.
/// @param finalue String finalue of this enum
enum SourceDataType {
  /// The source data loaded event is associated with source metadata.
  METADATA,

  /// The source data loaded event is associated with source tile.
  TILE
}

/// Defines the tile id in a source-data-loaded event.
class TileID {
  /// Creates a new instance of [TileID] from a JSON map.
  ///
  /// The [json] parameter is a map containing the JSON data to parse.
  /// Returns a new instance of [TileID] with the parsed data.
  TileID.fromJson(Map<String, dynamic> json)
      : x = json['x'] as int? ?? 0,
        y = json['y'] as int? ?? 0,
        z = json['z'] as int? ?? 0;

  /// The zoom level.
  final int z;

  /// The x coordinate of the tile
  final int x;

  /// The y coordinate of the tile
  final int y;

  /// Converts the object to a map representation.
  ///
  /// Returns a map with the keys 'x', 'y', and 'z' representing the values of the object's properties.
  dynamic toMap() => <String, dynamic>{'x': x, 'y': y, 'z': z};
}

///The data class for error in Observer
class Error {
  /// Creates an Error object from a JSON map.
  Error.fromJson(Map<String, dynamic> json)
      : reason = EnumToString.fromString(
          ResponseErrorReason.values,
          (json['reason'] as String? ?? '').toUpperCase().replaceAll('-', '_'),
        )!,
        message = json['message'] as String? ??
            'There was no error message delivered!';

  /// "reason" property
  final ResponseErrorReason reason;

  /// "message" property
  final String message;
}

/// The response data class that included in EventData
class Response {
  /// Creates a new [Response] object from a JSON map.
  ///
  /// The [json] parameter is a map containing the JSON data to parse.
  /// The keys in the map should be strings, and the values can be of any type.
  /// This constructor is used to deserialize the JSON response received from the server
  /// into a [Response] object.
  Response.fromJson(Map<String, dynamic> json)
      : eTag = json['etag'] as String?,
        mustRevalidate = json['must-revalidate'] as bool? ?? false,
        noContent = json['no-content'] as bool? ?? false,
        modified = json['modified'] as String? ?? '',
        source = EnumToString.fromString(
          ResponseSourceType.values,
          (json['source'] as String? ?? '').toUpperCase().replaceAll('-', '_'),
        )!,
        notModified = json['not-modified'] as bool? ?? false,
        expires = json['expires'] as String?,
        size = json['size'] as int? ?? 0,
        error = json['error'] != null
            ? Error.fromJson(json['error'] as Map<String, dynamic>? ?? {})
            : null;

  /// "etag" property
  final String? eTag;

  /// "must-revalidate" property
  final bool mustRevalidate;

  /// "no-content" property
  final bool noContent;

  /// "modified" property
  final String modified;

  /// "source" property
  final ResponseSourceType source;

  /// "notModified" property
  final bool notModified;

  /// "expires" property
  final String? expires;

  /// "size" property
  final int size;

  /// "error" property
  final Error? error;
}

/// Describes source data type for response in resource-request event.
/// @param value String value of this enum
enum ResponseSourceType {
  /// source type as network.
  NETWORK,

  /// source type as cache.
  CACHE,

  /// source type as tile-store.
  TILE_STORE,

  /// source type as local-file.
  LOCAL_FILE,
}

/// The request data class that included in EventData
class Request {
  /// Creates a new [Request] object from a JSON map.
  ///
  /// The [json] parameter is a map containing the JSON data to parse.
  /// Throws a [FormatException] if the JSON data is not valid.
  Request.fromJson(Map<String, dynamic> json)
      : loadingMethod = json['loading-method'] as List<String>? ?? [],
        url = json['url'] as String? ?? '',
        kind = EnumToString.fromString(
          RequestType.values,
          (json['kind'] as String? ?? '').toUpperCase().replaceAll('-', '_'),
        )!,
        priority = EnumToString.fromString(
          RequestPriority.values,
          (json['priority'] as String? ?? '')
              .toUpperCase()
              .replaceAll('-', '_'),
        )!;

  /// "loading-method" property
  final List<String> loadingMethod;

  /// "url" property
  final String url;

  /// "kind" property
  final RequestType kind;

  /// "priority" property
  final RequestPriority priority;
}

/// Describes type for request object.
/// @param value String value of this enum
enum RequestType {
  /// Request type unknown.
  UNKNOWN,

  /// Request type style.
  STYLE,

  /// Request type source.
  SOURCE,

  /// Request type tile.
  TILE,

  /// Request type glyphs.
  GLYPHS,

  /// Request type sprite-image.
  SPRITE_IMAGE,

  /// Request type sprite-json.
  SPRITE_JSON,

  /// Request type image.
  IMAGE,
}

/// Describes priority for request object.
/// @param value String value of this enum
enum RequestPriority {
  /// Regular priority. */
  REGULAR,

  /// low priority. */
  LOW
}

/// Describes priority for request object.
/// @param finalue String finalue of this enum
enum RequestPriorit {
  /// Regular priority. */
  REGULAR,

  /// low priority. */
  LOW
}

/// Generic Event type used to notify an `observer`.
class Event {
  /// Creates a new instance of the [Event] class.
  ///
  /// The [type] parameter specifies the type of the event.
  /// The [data] parameter specifies the associated data.
  Event({required this.type, required this.data});

  /// Type of the event.
  String type;

  /// Generic container for an event's data (Object). By default, event data will contain `begin` key, whose value
  /// is a number representing timestamp taken at the time of an event creation, in microseconds, since the epoch.
  /// For an interval events, an optional `end` property will be present that represents timestamp taken at the time
  /// of an event completion. Additional data properties are docummented by respective events.
  ///
  /// ``` text
  /// Event data format (Object):
  /// .
  /// ├── begin - Number
  /// └── end - optional Number
  /// ```
  String data;
}

/// An `observer` interface used to subscribe for an `observable` events. */
typedef Observer = void Function(Event event);
