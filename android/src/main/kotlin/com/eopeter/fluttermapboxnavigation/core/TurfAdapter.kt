package com.eopeter.fluttermapboxnavigation.core

import com.mapbox.geojson.Point

fun Point.toList(): Any {
    return mapOf("coordinates" to coordinates())
}

object PointDecoder {
    fun fromList(list: Any?): Point {
        val map = list as Map<*, *>
        val coordinates = map["coordinates"] as List<Double>
        return Point.fromLngLat(coordinates.first(), coordinates.last())
    }
}