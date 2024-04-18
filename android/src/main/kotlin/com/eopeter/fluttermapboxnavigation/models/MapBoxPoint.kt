package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.geojson.Point

class MapBoxPoint : MapBoxParsable {
    val type: String
    val bbox: MapBoxBoundingBox
    val coordinates: List<Double>

    constructor(point: Point?) {
        this@MapBoxPoint.type = point?.type() ?: "Unknown"
        this@MapBoxPoint.coordinates = point?.coordinates() ?: emptyList()
        this@MapBoxPoint.bbox = MapBoxBoundingBox(point?.bbox())
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "type", type)
        addProperty(json, "bbox", bbox)
        addPropertyLD(json, "coordinates", coordinates)

        return json
    }
}