package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.navigation.base.trip.model.roadobject.location.RoadObjectLocation

class MapBoxRoadObjectLocation: MapBoxParsable {
    private val type: String
    private val geometry: MapBoxGeometry

    constructor(location: RoadObjectLocation?) {
        this@MapBoxRoadObjectLocation.type = mapLocationType(location?.locationType ?: -1)
        this@MapBoxRoadObjectLocation.geometry = MapBoxGeometry(location?.shape)
    }

    private fun mapLocationType(type: Int): String {
        return when(type) {
            0 -> "gantry"
            1 -> "open_lr_line"
            2 -> "open_lr_point"
            3 -> "point"
            4 -> "polygon"
            5 -> "polyline"
            6 -> "polyline"
            7 -> "route_alert"
            else -> "unknown"
        }
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "type", type)
        addProperty(json, "geometry", geometry)

        return json
    }
}