package com.eopeter.fluttermapboxnavigation.boundings.camera.domain

import com.eopeter.fluttermapboxnavigation.boundings.style.domain.MbxEdgeInsets
import com.eopeter.fluttermapboxnavigation.core.PointDecoder
import com.eopeter.fluttermapboxnavigation.core.toList
import com.mapbox.geojson.Point

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