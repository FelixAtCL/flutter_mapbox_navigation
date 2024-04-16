package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.geojson.BoundingBox

class MapBoxBoundingBox: MapBoxParsable {
    private val southwest: MapBoxPoint
    private val northeast: MapBoxPoint

    constructor(bbox: BoundingBox?) {
        this@MapBoxBoundingBox.southwest = MapBoxPoint(bbox?.southwest())
        this@MapBoxBoundingBox.northeast = MapBoxPoint(bbox?.northeast())
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "southwest", southwest)
        addProperty(json,"northeast", northeast)

        return json
    }


}