package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.geojson.Geometry

class MapBoxGeometry: MapBoxParsable {
    private val type: String
    private val bbox: MapBoxBoundingBox

    constructor(geometry: Geometry?) {
        this@MapBoxGeometry.type = geometry?.type() ?: "unknown"
        this@MapBoxGeometry.bbox = MapBoxBoundingBox(geometry?.bbox())
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "type", type)
        addProperty(json, "bbox", bbox)

        return json
    }
}