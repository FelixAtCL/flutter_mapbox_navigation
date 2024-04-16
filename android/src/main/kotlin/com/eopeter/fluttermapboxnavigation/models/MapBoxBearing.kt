package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.Bearing

class MapBoxBearing : MapBoxParsable {
    private val angle: Double
    private val degrees: Double

    constructor(bearing: Bearing) {
        this@MapBoxBearing.angle = bearing.angle()
        this@MapBoxBearing.degrees = bearing.degrees()
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "angle", angle)
        addProperty(json, "degrees", degrees)

        return json
    }
}