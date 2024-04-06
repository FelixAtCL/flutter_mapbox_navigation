package com.eopeter.fluttermapboxnavigation.core

import com.google.gson.Gson
import com.mapbox.geojson.Point

fun Point.toList(): Any? {
    return mapOf("coordinates" to coordinates())
}

object PointDecoder {
    fun fromList(list: List<Any?>): Point {
        return Point.fromJson(Gson().toJson(list.first()))
    }
}