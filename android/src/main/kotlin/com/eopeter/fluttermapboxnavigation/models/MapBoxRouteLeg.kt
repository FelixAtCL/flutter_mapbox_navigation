package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonArray
import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.RouteLeg

class MapBoxRouteLeg: MapBoxParsable {
    private val distance: Double
    private val duration: Double
    private val durationTypical: Double
    private val summary: String
    private val admins: MutableList<MapBoxAdmin> = mutableListOf()
    private val steps: MutableList<MapBoxLegStep> = mutableListOf()

    constructor(leg: RouteLeg) {

    }

    override fun toJsonObject(): JsonObject {
        TODO("Not yet implemented")
    }

}
