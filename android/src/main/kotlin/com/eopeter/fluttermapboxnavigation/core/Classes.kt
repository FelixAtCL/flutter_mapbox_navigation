package com.eopeter.fluttermapboxnavigation.core

import com.mapbox.geojson.Point

/**
 * The distance on each side between rectangles, when one is contained into other.
 *
 * All fields' values are in `logical pixel` units.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class MbxEdgeInsets(
    /** Padding from the top. */
    val top: Double,
    /** Padding from the left. */
    val left: Double,
    /** Padding from the bottom. */
    val bottom: Double,
    /** Padding from the right. */
    val right: Double

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): MbxEdgeInsets {
            val top = list[0] as Double
            val left = list[1] as Double
            val bottom = list[2] as Double
            val right = list[3] as Double
            return MbxEdgeInsets(top, left, bottom, right)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            top,
            left,
            bottom,
            right,
        )
    }
}

/**
 * The `transition options` controls timing for the interpolation between a transitionable style
 * property's previous value and new value. These can be used to define the style default property
 * transition behavior. Also, any transitionable style property may also have its own `-transition`
 * property that defines specific transition timing for that specific layer property, overriding
 * the global transition values.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class TransitionOptions(
    /** Time allotted for transitions to complete. Units in milliseconds. Defaults to `300.0`. */
    val duration: Long? = null,
    /** Length of time before a transition begins. Units in milliseconds. Defaults to `0.0`. */
    val delay: Long? = null,
    /** Whether the fade in/out symbol placement transition is enabled. Defaults to `true`. */
    val enablePlacementTransitions: Boolean? = null

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): TransitionOptions {
            val duration = list[0].let { if (it is Int) it.toLong() else it as Long? }
            val delay = list[1].let { if (it is Int) it.toLong() else it as Long? }
            val enablePlacementTransitions = list[2] as Boolean?
            return TransitionOptions(duration, delay, enablePlacementTransitions)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            duration,
            delay,
            enablePlacementTransitions,
        )
    }
}

/**
 * Specifies position of a layer that is added via addStyleLayer method.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class LayerPosition(
    /** Layer should be positioned above specified layer id. */
    val above: String? = null,
    /** Layer should be positioned below specified layer id. */
    val below: String? = null,
    /** Layer should be positioned at specified index in a layers stack. */
    val at: Long? = null

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): LayerPosition {
            val above = list[0] as String?
            val below = list[1] as String?
            val at = list[2].let { if (it is Int) it.toLong() else it as Long? }
            return LayerPosition(above, below, at)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            above,
            below,
            at,
        )
    }
}

/** Describes the kind of a style property value. */
enum class StylePropertyValueKind(val raw: Int) {
    /** The property value is not defined. */
    UNDEFINED(0),
    /** The property value is a constant. */
    CONSTANT(1),
    /** The property value is a style [expression](https://docs.mapbox.com/mapbox-gl-js/style-spec/#expressions). */
    EXPRESSION(2),
    /** Property value is a style [transition](https://docs.mapbox.com/mapbox-gl-js/style-spec/#transition). */
    TRANSITION(3);

    companion object {
        fun ofRaw(raw: Int): StylePropertyValueKind? {
            return values().firstOrNull { it.raw == raw }
        }
    }
}

/**
 * Holds a style property value with meta data.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class StylePropertyValue(
    /** The property value. */
    val value: Any? = null,
    /** The kind of the property value. */
    val kind: StylePropertyValueKind

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): StylePropertyValue {
            val value = list[0]
            val kind = StylePropertyValueKind.ofRaw(list[1] as Int)!!
            return StylePropertyValue(value, kind)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            value,
            kind.raw,
        )
    }
}

/**
 * Image type.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class MbxImage(
    /** The width of the image, in screen pixels. */
    val width: Long,
    /** The height of the image, in screen pixels. */
    val height: Long,
    /**
     * 32-bit premultiplied RGBA image data.
     *
     * An uncompressed image data encoded in 32-bit RGBA format with premultiplied
     * alpha channel. This field should contain exactly `4 * width * height` bytes. It
     * should consist of a sequence of scanlines.
     */
    val data: ByteArray

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): MbxImage {
            val width = list[0].let { if (it is Int) it.toLong() else it as Long }
            val height = list[1].let { if (it is Int) it.toLong() else it as Long }
            val data = list[2] as ByteArray
            return MbxImage(width, height, data)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            width,
            height,
            data,
        )
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as MbxImage

        if (width != other.width) return false
        if (height != other.height) return false
        if (!data.contentEquals(other.data)) return false

        return true
    }

    override fun hashCode(): Int {
        var result = width.hashCode()
        result = 31 * result + height.hashCode()
        result = 31 * result + data.contentHashCode()
        return result
    }
}

/**
 * Describes the image stretch areas.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class ImageStretches(
    /** The first stretchable part in screen pixel units. */
    val first: Double,
    /** The second stretchable part in screen pixel units. */
    val second: Double

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): ImageStretches {
            val first = list[0] as Double
            val second = list[1] as Double
            return ImageStretches(first, second)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            first,
            second,
        )
    }
}

/**
 * Describes the image content, e.g. where text can be fit into an image.
 *
 * When sizing icons with `icon-text-fit`, the icon size will be adjusted so that the this content box fits exactly around the text.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class ImageContent(
    /** Distance to the left, in screen pixels. */
    val left: Double,
    /** Distance to the top, in screen pixels. */
    val top: Double,
    /** Distance to the right, in screen pixels. */
    val right: Double,
    /** Distance to the bottom, in screen pixels. */
    val bottom: Double

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): ImageContent {
            val left = list[0] as Double
            val top = list[1] as Double
            val right = list[2] as Double
            val bottom = list[3] as Double
            return ImageContent(left, top, right, bottom)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            left,
            top,
            right,
            bottom,
        )
    }
}

/**
 * Represents a tile coordinate.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class CanonicalTileID(
    /** The z value of the coordinate (zoom-level). */
    val z: Long,
    /** The x value of the coordinate. */
    val x: Long,
    /** The y value of the coordinate. */
    val y: Long

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): CanonicalTileID {
            val z = list[0].let { if (it is Int) it.toLong() else it as Long }
            val x = list[1].let { if (it is Int) it.toLong() else it as Long }
            val y = list[2].let { if (it is Int) it.toLong() else it as Long }
            return CanonicalTileID(z, x, y)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            z,
            x,
            y,
        )
    }
}

/**
 * A rectangular area as measured on a two-dimensional map projection.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class CoordinateBounds(
    /**
     * Coordinate at the southwest corner.
     * Note: setting this field with invalid values (infinite, NaN) will crash the application.
     */
    val southwest: Point,
    /**
     * Coordinate at the northeast corner.
     * Note: setting this field with invalid values (infinite, NaN) will crash the application.
     */
    val northeast: Point,
    /**
     * If set to `true`, an infinite (unconstrained) bounds covering the world coordinates would be used.
     * Coordinates provided in `southwest` and `northeast` fields would be omitted and have no effect.
     */
    val infiniteBounds: Boolean

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): CoordinateBounds {
            val southwest = PointDecoder.fromList(list[0] as List<Any?>)
            val northeast = PointDecoder.fromList(list[1] as List<Any?>)
            val infiniteBounds = list[2] as Boolean
            return CoordinateBounds(southwest, northeast, infiniteBounds)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            southwest.toList(),
            northeast.toList(),
            infiniteBounds,
        )
    }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class StyleProjection(
    val name: StyleProjectionName

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): StyleProjection {
            val name = StyleProjectionName.ofRaw(list[0] as Int)!!
            return StyleProjection(name)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            name.raw,
        )
    }
}

enum class StyleProjectionName(val raw: Int) {
    MERCATOR(0),
    GLOBE(1);

    companion object {
        fun ofRaw(raw: Int): StyleProjectionName? {
            return values().firstOrNull { it.raw == raw }
        }
    }
}

/**
 * An indirect light affecting all objects in the map adding a constant amount of light on them. It has no explicit direction and cannot cast shadows.
 *
 * - SeeAlso: [Mapbox Style Specification](https://www.mapbox.com/mapbox-gl-style-spec/#light)
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class AmbientLight(
    /** Unique light name */
    val id: String,
    /** Color of the ambient light. */
    val color: Long? = null,
    /** Transition property for `color` */
    val colorTransition: TransitionOptions? = null,
    /** A multiplier for the color of the ambient light. */
    val intensity: Double? = null,
    /** Transition property for `intensity` */
    val intensityTransition: TransitionOptions? = null

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): AmbientLight {
            val id = list[0] as String
            val color = list[1].let { if (it is Int) it.toLong() else it as Long? }
            val colorTransition = (list[2] as List<Any?>?)?.let {
                TransitionOptions.fromList(it)
            }
            val intensity = list[3] as Double?
            val intensityTransition = (list[4] as List<Any?>?)?.let {
                TransitionOptions.fromList(it)
            }
            return AmbientLight(id, color, colorTransition, intensity, intensityTransition)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            id,
            color,
            colorTransition?.toList(),
            intensity,
            intensityTransition?.toList(),
        )
    }
}

/**
 * Holds information about `camera bounds`.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class CameraBounds(
    /** The latitude and longitude bounds to which the camera center are constrained. */
    val bounds: CoordinateBounds,
    /** The maximum zoom level, in Mapbox zoom levels 0-25.5. At low zoom levels, a small set of map tiles covers a large geographical area. At higher zoom levels, a larger number of tiles cover a smaller geographical area. */
    val maxZoom: Double,
    /** The minimum zoom level, in Mapbox zoom levels 0-25.5. */
    val minZoom: Double,
    /** The maximum allowed pitch value in degrees. */
    val maxPitch: Double,
    /** The minimum allowed pitch value in degrees. */
    val minPitch: Double

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): CameraBounds {
            val bounds = CoordinateBounds.fromList(list[0] as List<Any?>)
            val maxZoom = list[1] as Double
            val minZoom = list[2] as Double
            val maxPitch = list[3] as Double
            val minPitch = list[4] as Double
            return CameraBounds(bounds, maxZoom, minZoom, maxPitch, minPitch)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            bounds.toList(),
            maxZoom,
            minZoom,
            maxPitch,
            minPitch,
        )
    }
}

/**
 * Holds options to be used for setting `camera bounds`.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class CameraBoundsOptions(
    /** The latitude and longitude bounds to which the camera center are constrained. */
    val bounds: CoordinateBounds? = null,
    /** The maximum zoom level, in Mapbox zoom levels 0-25.5. At low zoom levels, a small set of map tiles covers a large geographical area. At higher zoom levels, a larger number of tiles cover a smaller geographical area. */
    val maxZoom: Double? = null,
    /** The minimum zoom level, in Mapbox zoom levels 0-25.5. */
    val minZoom: Double? = null,
    /** The maximum allowed pitch value in degrees. */
    val maxPitch: Double? = null,
    /** The minimum allowed pitch value in degrees. */
    val minPitch: Double? = null

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): CameraBoundsOptions {
            val bounds = (list[0] as List<Any?>?)?.let {
                CoordinateBounds.fromList(it)
            }
            val maxZoom = list[1] as Double?
            val minZoom = list[2] as Double?
            val maxPitch = list[3] as Double?
            val minPitch = list[4] as Double?
            return CameraBoundsOptions(bounds, maxZoom, minZoom, maxPitch, minPitch)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            bounds?.toList(),
            maxZoom,
            minZoom,
            maxPitch,
            minPitch,
        )
    }
}

/**
 * Various options for describing the viewpoint of a camera. All fields are
 * optional.
 *
 * Anchor and center points are mutually exclusive, with preference for the
 * center point when both are set.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class CameraOptions(
    /** Coordinate at the center of the camera. */
    val center: Point? = null,
    /**
     * Padding around the interior of the view that affects the frame of
     * reference for `center`.
     */
    val padding: MbxEdgeInsets? = null,
    /**
     * Point of reference for `zoom` and `angle`, assuming an origin at the
     * top-left corner of the view.
     */
    val anchor: ScreenCoordinate? = null,
    /**
     * Zero-based zoom level. Constrained to the minimum and maximum zoom
     * levels.
     */
    val zoom: Double? = null,
    /** Bearing, measured in degrees from true north. Wrapped to [0, 360). */
    val bearing: Double? = null,
    /** Pitch toward the horizon measured in degrees. */
    val pitch: Double? = null

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): CameraOptions {
            val center = (list[0] as List<Any?>?)?.let {
                PointDecoder.fromList(it)
            }
            val padding = (list[1] as List<Any?>?)?.let {
                MbxEdgeInsets.fromList(it)
            }
            val anchor = (list[2] as List<Any?>?)?.let {
                ScreenCoordinate.fromList(it)
            }
            val zoom = list[3] as Double?
            val bearing = list[4] as Double?
            val pitch = list[5] as Double?
            return CameraOptions(center, padding, anchor, zoom, bearing, pitch)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            center?.toList(),
            padding?.toList(),
            anchor?.toList(),
            zoom,
            bearing,
            pitch,
        )
    }
}

/**
 * Describes the coordinate on the screen, measured from top to bottom and from left to right.
 * Note: the `map` uses screen coordinate units measured in `logical pixels`.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class ScreenCoordinate(
    /** A value representing the x position of this coordinate. */
    val x: Double,
    /** A value representing the y position of this coordinate. */
    val y: Double

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): ScreenCoordinate {
            val x = list[0] as Double
            val y = list[1] as Double
            return ScreenCoordinate(x, y)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            x,
            y,
        )
    }
}

/**
 * A coordinate bounds and zoom.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class CoordinateBoundsZoom(
    /** The latitude and longitude bounds. */
    val bounds: CoordinateBounds,
    /** Zoom. */
    val zoom: Double

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): CoordinateBoundsZoom {
            val bounds = CoordinateBounds.fromList(list[0] as List<Any?>)
            val zoom = list[1] as Double
            return CoordinateBoundsZoom(bounds, zoom)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            bounds.toList(),
            zoom,
        )
    }
}

/**
 * A light that has a direction and is located at infinite, so its rays are parallel. Simulates the sun light and it can cast shadows
 *
 * - SeeAlso: [Mapbox Style Specification](https://www.mapbox.com/mapbox-gl-style-spec/#light)
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class DirectionalLight(
    /** Unique light name */
    val id: String,
    /** Enable/Disable shadow casting for this light */
    val castShadows: Boolean? = null,
    /** Color of the directional light. */
    val color: Long? = null,
    /** Transition property for `color` */
    val colorTransition: TransitionOptions? = null,
    /** Direction of the light source specified as [a azimuthal angle, p polar angle] where a indicates the azimuthal angle of the light relative to north (in degrees and proceeding clockwise), and p indicates polar angle of the light (from 0 degree, directly above, to 180 degree, directly below). */
    val direction: List<Double?>? = null,
    /** Transition property for `direction` */
    val directionTransition: TransitionOptions? = null,
    /** A multiplier for the color of the directional light. */
    val intensity: Double? = null,
    /** Transition property for `intensity` */
    val intensityTransition: TransitionOptions? = null,
    /** Determines the shadow strength, affecting the shadow receiver surfaces final color. Values near 0.0 reduce the shadow contribution to the final color. Values near to 1.0 make occluded surfaces receive almost no directional light. Designed to be used mostly for transitioning between values 0 and 1. */
    val shadowIntensity: Double? = null,
    /** Transition property for `shadowIntensity` */
    val shadowIntensityTransition: TransitionOptions? = null

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): DirectionalLight {
            val id = list[0] as String
            val castShadows = list[1] as Boolean?
            val color = list[2].let { if (it is Int) it.toLong() else it as Long? }
            val colorTransition = (list[3] as List<Any?>?)?.let {
                TransitionOptions.fromList(it)
            }
            val direction = list[4] as List<Double?>?
            val directionTransition = (list[5] as List<Any?>?)?.let {
                TransitionOptions.fromList(it)
            }
            val intensity = list[6] as Double?
            val intensityTransition = (list[7] as List<Any?>?)?.let {
                TransitionOptions.fromList(it)
            }
            val shadowIntensity = list[8] as Double?
            val shadowIntensityTransition = (list[9] as List<Any?>?)?.let {
                TransitionOptions.fromList(it)
            }
            return DirectionalLight(id, castShadows, color, colorTransition, direction, directionTransition, intensity, intensityTransition, shadowIntensity, shadowIntensityTransition)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            id,
            castShadows,
            color,
            colorTransition?.toList(),
            direction,
            directionTransition?.toList(),
            intensity,
            intensityTransition?.toList(),
            shadowIntensity,
            shadowIntensityTransition?.toList(),
        )
    }
}

/**
 * A value or a collection of a feature extension.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class FeatureExtensionValue(
    /** An optional value of a feature extension */
    val value: String? = null,
    /** An optional array of features from a feature extension. */
    val featureCollection: List<Map<String?, Any?>?>? = null

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): FeatureExtensionValue {
            val value = list[0] as String?
            val featureCollection = list[1] as List<Map<String?, Any?>?>?
            return FeatureExtensionValue(value, featureCollection)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            value,
            featureCollection,
        )
    }
}

/**
 * A global directional light source which is only applied on 3D layers and hillshade layers. Using this type disables other light sources.
 *
 * - SeeAlso: [Mapbox Style Specification](https://www.mapbox.com/mapbox-gl-style-spec/#light)
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class FlatLight(
    /** Unique light name */
    val id: String,
    /** Whether extruded geometries are lit relative to the map or viewport. */
    val anchor: Anchor? = null,
    /** Color tint for lighting extruded geometries. */
    val color: Long? = null,
    /** Transition property for `color` */
    val colorTransition: TransitionOptions? = null,
    /** Intensity of lighting (on a scale from 0 to 1). Higher numbers will present as more extreme contrast. */
    val intensity: Double? = null,
    /** Transition property for `intensity` */
    val intensityTransition: TransitionOptions? = null,
    /** Position of the light source relative to lit (extruded) geometries, in [r radial coordinate, a azimuthal angle, p polar angle] where r indicates the distance from the center of the base of an object to its light, a indicates the position of the light relative to 0 degree (0 degree when `light.anchor` is set to `viewport` corresponds to the top of the viewport, or 0 degree when `light.anchor` is set to `map` corresponds to due north, and degrees proceed clockwise), and p indicates the height of the light (from 0 degree, directly above, to 180 degree, directly below). */
    val position: List<Double?>? = null,
    /** Transition property for `position` */
    val positionTransition: TransitionOptions? = null

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): FlatLight {
            val id = list[0] as String
            val anchor = (list[1] as Int?)?.let {
                Anchor.ofRaw(it)
            }
            val color = list[2].let { if (it is Int) it.toLong() else it as Long? }
            val colorTransition = (list[3] as List<Any?>?)?.let {
                TransitionOptions.fromList(it)
            }
            val intensity = list[4] as Double?
            val intensityTransition = (list[5] as List<Any?>?)?.let {
                TransitionOptions.fromList(it)
            }
            val position = list[6] as List<Double?>?
            val positionTransition = (list[7] as List<Any?>?)?.let {
                TransitionOptions.fromList(it)
            }
            return FlatLight(id, anchor, color, colorTransition, intensity, intensityTransition, position, positionTransition)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            id,
            anchor?.raw,
            color,
            colorTransition?.toList(),
            intensity,
            intensityTransition?.toList(),
            position,
            positionTransition?.toList(),
        )
    }
}

/** Whether extruded geometries are lit relative to the map or viewport. */
enum class Anchor(val raw: Int) {
    /** The position of the light source is aligned to the rotation of the map. */
    MAP(0),
    /** The position of the light source is aligned to the rotation of the viewport. */
    VIEWPORT(1);

    companion object {
        fun ofRaw(raw: Int): Anchor? {
            return values().firstOrNull { it.raw == raw }
        }
    }
}

/**
 * Describes the glyphs rasterization option values.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class GlyphsRasterizationOptions(
    /** Glyphs rasterization mode for client-side text rendering. */
    val rasterizationMode: GlyphsRasterizationMode,
    /**
     * Font family to use as font fallback for client-side text renderings.
     *
     * Note: `GlyphsRasterizationMode` has precedence over font family. If `AllGlyphsRasterizedLocally`
     * or `IdeographsRasterizedLocally` is set, local glyphs will be generated based on the provided font family. If no
     * font family is provided, the map will fall back to use the system default font. The mechanisms of choosing the
     * default font are varied in platforms:
     * - For darwin(iOS/macOS) platform, the default font family is created from the <a href="https://developer.apple.com/documentation/uikit/uifont/1619027-systemfontofsize?language=objc">systemFont</a>.
     *   If provided fonts are not supported on darwin platform, the map will fall back to use the first available font from the global fallback list.
     * - For Android platform: the default font <a href="https://developer.android.com/reference/android/graphics/Typeface#DEFAULT">Typeface.DEFAULT</a> will be used.
     *
     * Besides, the font family will be discarded if it is provided along with `NoGlyphsRasterizedLocally` mode.
     *
     */
    val fontFamily: String? = null

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): GlyphsRasterizationOptions {
            val rasterizationMode = GlyphsRasterizationMode.ofRaw(list[0] as Int)!!
            val fontFamily = list[1] as String?
            return GlyphsRasterizationOptions(rasterizationMode, fontFamily)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            rasterizationMode.raw,
            fontFamily,
        )
    }
}

/** Describes glyphs rasterization modes. */
enum class GlyphsRasterizationMode(val raw: Int) {
    /** No glyphs are rasterized locally. All glyphs are loaded from the server. */
    NO_GLYPHS_RASTERIZED_LOCALLY(0),
    /** Ideographs are rasterized locally, and they are not loaded from the server. */
    IDEOGRAPHS_RASTERIZED_LOCALLY(1),
    /** All glyphs are rasterized locally. No glyphs are loaded from the server. */
    ALL_GLYPHS_RASTERIZED_LOCALLY(2);

    companion object {
        fun ofRaw(raw: Int): GlyphsRasterizationMode? {
            return values().firstOrNull { it.raw == raw }
        }
    }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class MapAnimationOptions(
    /**
     * The duration of the animation in milliseconds.
     * If not set explicitly default duration will be taken 300ms
     */
    val duration: Long? = null,
    /**
     * The amount of time, in milliseconds, to delay starting the animation after animation start.
     * If not set explicitly default startDelay will be taken 0ms. This only works for Android.
     */
    val startDelay: Long? = null

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): MapAnimationOptions {
            val duration = list[0].let { if (it is Int) it.toLong() else it as Long? }
            val startDelay = list[1].let { if (it is Int) it.toLong() else it as Long? }
            return MapAnimationOptions(duration, startDelay)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            duration,
            startDelay,
        )
    }
}

/**
 * Options for enabling debugging features in a map.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class MapDebugOptions(
    val data: MapDebugOptionsData

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): MapDebugOptions {
            val data = MapDebugOptionsData.ofRaw(list[0] as Int)!!
            return MapDebugOptions(data)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            data.raw,
        )
    }
}

/** Options for enabling debugging features in a map. */
enum class MapDebugOptionsData(val raw: Int) {
    /**
     * Edges of tile boundaries are shown as thick, red lines to help diagnose
     * tile clipping issues.
     */
    TILE_BORDERS(0),
    /** Each tile shows its tile coordinate (x/y/z) in the upper-left corner. */
    PARSE_STATUS(1),
    /** Each tile shows a timestamp indicating when it was loaded. */
    TIMESTAMPS(2),
    /**
     * Edges of glyphs and symbols are shown as faint, green lines to help
     * diagnose collision and label placement issues.
     */
    COLLISION(3),
    /**
     * Each drawing operation is replaced by a translucent fill. Overlapping
     * drawing operations appear more prominent to help diagnose overdrawing.
     */
    OVERDRAW(4),
    /** The stencil buffer is shown instead of the color buffer. */
    STENCIL_CLIP(5),
    /** The depth buffer is shown instead of the color buffer. */
    DEPTH_BUFFER(6),
    /**
     * Visualize residency of tiles in the render cache. Tile boundaries of cached tiles
     * are rendered with green, tiles waiting for an update with yellow and tiles not in the cache
     * with red.
     */
    RENDER_CACHE(7),
    /** Show 3D model bounding boxes. */
    MODEL_BOUNDS(8),
    /** Show a wireframe for terrain. */
    TERRAIN_WIREFRAME(9);

    companion object {
        fun ofRaw(raw: Int): MapDebugOptionsData? {
            return values().firstOrNull { it.raw == raw }
        }
    }
}

/**
 * Describes the map option values.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class MapOptions(
    /**
     * The map context mode. This can be used to optimizations
     * if we know that the drawing context is not shared with other code.
     */
    val contextMode: ContextMode? = null,
    /**
     * The map constrain mode. This can be used to limit the map
     * to wrap around the globe horizontally. By default, it is set to
     * `HeightOnly`.
     */
    val constrainMode: ConstrainMode? = null,
    /**
     * The viewport mode. This can be used to flip the vertical
     * orientation of the map as some devices may use inverted orientation.
     */
    val viewportMode: ViewportMode? = null,
    /**
     * The orientation of the Map. By default, it is set to
     * `Upwards`.
     */
    val orientation: NorthOrientation? = null,
    /**
     * Specify whether to enable cross-source symbol collision detection
     * or not. By default, it is set to `true`.
     */
    val crossSourceCollisions: Boolean? = null,
    /**
     * The size to resize the map object and renderer backend.
     * The size is given in `logical pixel` units. macOS and iOS platforms use
     * device-independent pixel units, while other platforms, such as Android,
     * use screen pixel units.
     */
    val size: Size? = null,
    /** The custom pixel ratio. By default, it is set to 1.0 */
    val pixelRatio: Double,
    /** Glyphs rasterization options to use for client-side text rendering. */
    val glyphsRasterizationOptions: GlyphsRasterizationOptions? = null

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): MapOptions {
            val contextMode = (list[0] as Int?)?.let {
                ContextMode.ofRaw(it)
            }
            val constrainMode = (list[1] as Int?)?.let {
                ConstrainMode.ofRaw(it)
            }
            val viewportMode = (list[2] as Int?)?.let {
                ViewportMode.ofRaw(it)
            }
            val orientation = (list[3] as Int?)?.let {
                NorthOrientation.ofRaw(it)
            }
            val crossSourceCollisions = list[4] as Boolean?
            val size = (list[5] as List<Any?>?)?.let {
                Size.fromList(it)
            }
            val pixelRatio = list[6] as Double
            val glyphsRasterizationOptions = (list[7] as List<Any?>?)?.let {
                GlyphsRasterizationOptions.fromList(it)
            }
            return MapOptions(contextMode, constrainMode, viewportMode, orientation, crossSourceCollisions, size, pixelRatio, glyphsRasterizationOptions)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            contextMode?.raw,
            constrainMode?.raw,
            viewportMode?.raw,
            orientation?.raw,
            crossSourceCollisions,
            size?.toList(),
            pixelRatio,
            glyphsRasterizationOptions?.toList(),
        )
    }
}

/**
 * Describes the map context mode.
 * We can make some optimizations if we know that the drawing context is not shared with other code.
 */
enum class ContextMode(val raw: Int) {
    /**
     * Unique context mode: in OpenGL, the GL context is not shared, thus we can retain knowledge about the GL state
     * from a previous render pass. It also enables clearing the screen using glClear for the bottommost background
     * layer when no pattern is applied to that layer.
     */
    UNIQUE(0),
    /**
     * Shared context mode: in OpenGL, the GL context is shared with other renderers, thus we cannot rely on the GL
     * state set from a previous render pass.
     */
    SHARED(1);

    companion object {
        fun ofRaw(raw: Int): ContextMode? {
            return values().firstOrNull { it.raw == raw }
        }
    }
}

/** Describes whether to constrain the map in both axes or only vertically e.g. while panning. */
enum class ConstrainMode(val raw: Int) {
    /** No constrains. */
    NONE(0),
    /** Constrain to height only */
    HEIGHT_ONLY(1),
    /** Constrain both width and height axes. */
    WIDTH_AND_HEIGHT(2);

    companion object {
        fun ofRaw(raw: Int): ConstrainMode? {
            return values().firstOrNull { it.raw == raw }
        }
    }
}

/** Satisfies embedding platforms that requires the viewport coordinate systems to be set according to its standards. */
enum class ViewportMode(val raw: Int) {
    /** Default viewport */
    DEFAULT(0),
    /** Viewport flipped on the y-axis. */
    FLIPPED_Y(1);

    companion object {
        fun ofRaw(raw: Int): ViewportMode? {
            return values().firstOrNull { it.raw == raw }
        }
    }
}

/** Describes the map orientation. */
enum class NorthOrientation(val raw: Int) {
    /** Default, map oriented upwards */
    UPWARDS(0),
    /** Map oriented righwards */
    RIGHTWARDS(1),
    /** Map oriented downwards */
    DOWNWARDS(2),
    /** Map oriented leftwards */
    LEFTWARDS(3);

    companion object {
        fun ofRaw(raw: Int): NorthOrientation? {
            return values().firstOrNull { it.raw == raw }
        }
    }
}

/**
 * Size type.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class Size(
    /** Width of the size. */
    val width: Double,
    /** Height of the size. */
    val height: Double

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): Size {
            val width = list[0] as Double
            val height = list[1] as Double
            return Size(width, height)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            width,
            height,
        )
    }
}

/**
 * Describes a point on the map in Mercator projection.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class MercatorCoordinate(
    /** A value representing the x position of this coordinate. */
    val x: Double,
    /** A value representing the y position of this coordinate. */
    val y: Double

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): MercatorCoordinate {
            val x = list[0] as Double
            val y = list[1] as Double
            return MercatorCoordinate(x, y)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            x,
            y,
        )
    }
}

/**
 * An offline region definition is a geographic region defined by a style URL,
 * a geometry, zoom range, and device pixel ratio. Both `minZoom` and `maxZoom` must be ≥ 0,
 * and `maxZoom` must be ≥ `minZoom`. The `maxZoom` may be ∞, in which case for each tile source,
 * the region will include tiles from `minZoom` up to the maximum zoom level provided by that source.
 * The `pixelRatio` must be ≥ 0 and should typically be 1.0 or 2.0.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class OfflineRegionGeometryDefinition(
    /** The style associated with the offline region */
    val styleURL: String,
    /** The geometry that defines the boundary of the offline region */
    val geometry: Map<String?, Any?>,
    /** Minimum zoom level for the offline region */
    val minZoom: Double,
    /** Maximum zoom level for the offline region */
    val maxZoom: Double,
    /** Pixel ratio to be accounted for when downloading assets */
    val pixelRatio: Double,
    /** Specifies glyphs rasterization mode. It defines which glyphs will be loaded from the server */
    val glyphsRasterizationMode: GlyphsRasterizationMode

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): OfflineRegionGeometryDefinition {
            val styleURL = list[0] as String
            val geometry = list[1] as Map<String?, Any?>
            val minZoom = list[2] as Double
            val maxZoom = list[3] as Double
            val pixelRatio = list[4] as Double
            val glyphsRasterizationMode = GlyphsRasterizationMode.ofRaw(list[5] as Int)!!
            return OfflineRegionGeometryDefinition(styleURL, geometry, minZoom, maxZoom, pixelRatio, glyphsRasterizationMode)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            styleURL,
            geometry,
            minZoom,
            maxZoom,
            pixelRatio,
            glyphsRasterizationMode.raw,
        )
    }
}

/**
 * An offline region definition is a geographic region defined by a style URL,
 * geographic bounding box, zoom range, and device pixel ratio. Both `minZoom` and `maxZoom` must be ≥ 0,
 * and `maxZoom` must be ≥ `minZoom`. The `maxZoom` may be ∞, in which case for each tile source,
 * the region will include tiles from `minZoom` up to the maximum zoom level provided by that source.
 * The `pixelRatio` must be ≥ 0 and should typically be 1.0 or 2.0.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class OfflineRegionTilePyramidDefinition(
    /** The style associated with the offline region. */
    val styleURL: String,
    /** The bounds covering the region. */
    val bounds: CoordinateBounds,
    /** Minimum zoom level for the offline region. */
    val minZoom: Double,
    /** Maximum zoom level for the offline region. */
    val maxZoom: Double,
    /** Pixel ratio to be accounted for when downloading assets. */
    val pixelRatio: Double,
    /** Specifies glyphs download mode. */
    val glyphsRasterizationMode: GlyphsRasterizationMode

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): OfflineRegionTilePyramidDefinition {
            val styleURL = list[0] as String
            val bounds = CoordinateBounds.fromList(list[1] as List<Any?>)
            val minZoom = list[2] as Double
            val maxZoom = list[3] as Double
            val pixelRatio = list[4] as Double
            val glyphsRasterizationMode = GlyphsRasterizationMode.ofRaw(list[5] as Int)!!
            return OfflineRegionTilePyramidDefinition(styleURL, bounds, minZoom, maxZoom, pixelRatio, glyphsRasterizationMode)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            styleURL,
            bounds.toList(),
            minZoom,
            maxZoom,
            pixelRatio,
            glyphsRasterizationMode.raw,
        )
    }
}

/**
 * ProjectedMeters is a coordinate in a specific
 * [Spherical Mercator](http://docs.openlayers.org/library/spherical_mercator.html) projection.
 *
 * This specific Spherical Mercator projection assumes the Earth is a sphere with a radius
 * of 6,378,137 meters. Coordinates are determined as distances, in meters, on the surface
 * of that sphere.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class ProjectedMeters(
    /** Projected meters in north direction. */
    val northing: Double,
    /** Projected meters in east direction. */
    val easting: Double

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): ProjectedMeters {
            val northing = list[0] as Double
            val easting = list[1] as Double
            return ProjectedMeters(northing, easting)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            northing,
            easting,
        )
    }
}

/**
 * Represents query result that is returned in QueryFeaturesCallback.
 * @see `queryRenderedFeatures` or `querySourceFeatures`
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class QueriedFeature(
    /** Feature returned by the query. */
    val feature: Map<String?, Any?>,
    /** Source id for a queried feature. */
    val source: String,
    /**
     * Source layer id for a queried feature. May be null if source does not support layers, e.g., 'geojson' source,
     * or when data provided by the source is not layered.
     */
    val sourceLayer: String? = null,
    /**
     * Feature state for a queried feature. Type of the value is an Object.
     * @see `setFeatureState` and `getFeatureState`
     */
    val state: String

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): QueriedFeature {
            val feature = list[0] as Map<String?, Any?>
            val source = list[1] as String
            val sourceLayer = list[2] as String?
            val state = list[3] as String
            return QueriedFeature(feature, source, sourceLayer, state)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            feature,
            source,
            sourceLayer,
            state,
        )
    }
}

/**
 * Represents query result that is returned in QueryRenderedFeaturesCallback.
 * @see `queryRenderedFeatures`
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class QueriedRenderedFeature(
    /** Feature returned by the query. */
    val queriedFeature: QueriedFeature,
    /**
     * An array of layer Ids for the queried feature.
     * If the feature has been rendered in multiple layers, multiple Ids will be provided.
     * If the feature is only rendered in one layer, a single Id will be provided.
     */
    val layers: List<String?>

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): QueriedRenderedFeature {
            val queriedFeature = QueriedFeature.fromList(list[0] as List<Any?>)
            val layers = list[1] as List<String?>
            return QueriedRenderedFeature(queriedFeature, layers)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            queriedFeature.toList(),
            layers,
        )
    }
}

/**
 * Represents query result that is returned in QuerySourceFeaturesCallback.
 * @see `querySourceFeatures`
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class QueriedSourceFeature(
    /** Feature returned by the query. */
    val queriedFeature: QueriedFeature

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): QueriedSourceFeature {
            val queriedFeature = QueriedFeature.fromList(list[0] as List<Any?>)
            return QueriedSourceFeature(queriedFeature)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            queriedFeature.toList(),
        )
    }
}

/**
 * Geometry for querying rendered features.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class RenderedQueryGeometry(
    /** ScreenCoordinate/List<ScreenCoordinate>/ScreenBox in Json mode. */
    val value: String,
    val type: Type

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): RenderedQueryGeometry {
            val value = list[0] as String
            val type = Type.ofRaw(list[1] as Int)!!
            return RenderedQueryGeometry(value, type)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            value,
            type.raw,
        )
    }
}

/** Type information of the variant's content */
enum class Type(val raw: Int) {
    SCREEN_BOX(0),
    SCREEN_COORDINATE(1),
    LIST(2);

    companion object {
        fun ofRaw(raw: Int): Type? {
            return values().firstOrNull { it.raw == raw }
        }
    }
}

/**
 * Options for querying rendered features.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class RenderedQueryOptions(
    /** Layer IDs to include in the query. */
    val layerIds: List<String?>? = null,
    /** Filters the returned features with an expression */
    val filter: String? = null

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): RenderedQueryOptions {
            val layerIds = list[0] as List<String?>?
            val filter = list[1] as String?
            return RenderedQueryOptions(layerIds, filter)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            layerIds,
            filter,
        )
    }
}

/**
 * Describes the coordinate box on the screen, measured in `logical pixels`
 * from top to bottom and from left to right.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class ScreenBox(
    /** The screen coordinate close to the top left corner of the screen. */
    val min: ScreenCoordinate,
    /** The screen coordinate close to the bottom right corner of the screen. */
    val max: ScreenCoordinate

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): ScreenBox {
            val min = ScreenCoordinate.fromList(list[0] as List<Any?>)
            val max = ScreenCoordinate.fromList(list[1] as List<Any?>)
            return ScreenBox(min, max)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            min.toList(),
            max.toList(),
        )
    }
}

/**
 * Options for querying source features.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class SourceQueryOptions(
    /** Source layer IDs to include in the query. */
    val sourceLayerIds: List<String?>? = null,
    /** Filters the returned features with an expression */
    val filter: String

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): SourceQueryOptions {
            val sourceLayerIds = list[0] as List<String?>?
            val filter = list[1] as String
            return SourceQueryOptions(sourceLayerIds, filter)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            sourceLayerIds,
            filter,
        )
    }
}

/**
 * The information about style object (source or layer).
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class StyleObjectInfo(
    /** The object's identifier. */
    val id: String,
    /** The object's type. */
    val type: String

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): StyleObjectInfo {
            val id = list[0] as String
            val type = list[1] as String
            return StyleObjectInfo(id, type)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            id,
            type,
        )
    }
}

/**
 * Map memory budget in megabytes.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class TileCacheBudgetInMegabytes(
    val size: Long

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): TileCacheBudgetInMegabytes {
            val size = list[0].let { if (it is Int) it.toLong() else it as Long }
            return TileCacheBudgetInMegabytes(size)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            size,
        )
    }
}

/**
 * Map memory budget in tiles.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class TileCacheBudgetInTiles(
    val size: Long

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): TileCacheBudgetInTiles {
            val size = list[0].let { if (it is Int) it.toLong() else it as Long }
            return TileCacheBudgetInTiles(size)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            size,
        )
    }
}

/**
 * Describes the viewpoint of a camera.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class CameraState(
    /** Coordinate at the center of the camera. */
    val center: Point,
    /**
     * Padding around the interior of the view that affects the frame of
     * reference for `center`.
     */
    val padding: MbxEdgeInsets,
    /**
     * Zero-based zoom level. Constrained to the minimum and maximum zoom
     * levels.
     */
    val zoom: Double,
    /** Bearing, measured in degrees from true north. Wrapped to [0, 360). */
    val bearing: Double,
    /** Pitch toward the horizon measured in degrees. */
    val pitch: Double

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): CameraState {
            val center = PointDecoder.fromList(list[0] as List<Any?>)
            val padding = MbxEdgeInsets.fromList(list[1] as List<Any?>)
            val zoom = list[2] as Double
            val bearing = list[3] as Double
            val pitch = list[4] as Double
            return CameraState(center, padding, zoom, bearing, pitch)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            center.toList(),
            padding.toList(),
            zoom,
            bearing,
            pitch,
        )
    }
}