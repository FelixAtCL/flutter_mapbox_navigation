package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonElement
import com.google.gson.JsonObject
import com.mapbox.navigation.base.ExperimentalMapboxNavigationAPI
import com.mapbox.navigation.base.route.LegWaypoint

class MapBoxLegWaypoint:MapBoxParsable {
    private val location: MapBoxPoint
    private val name: String
    private val target: MapBoxPoint
    private val type: String
    private val metadata: Map<String, JsonElement>

    @OptIn(ExperimentalMapboxNavigationAPI::class)
    constructor(waypoint: LegWaypoint?) {
        this@MapBoxLegWaypoint.location = MapBoxPoint(waypoint?.location)
        this@MapBoxLegWaypoint.name = waypoint?.name ?: ""
        this@MapBoxLegWaypoint.target = MapBoxPoint(waypoint?.target)
        this@MapBoxLegWaypoint.type = waypoint?.type ?: ""
        this@MapBoxLegWaypoint.metadata = waypoint?.metadata ?: mapOf()
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "location", location)
        addProperty(json, "name", name)
        addProperty(json, "target", target)
        addProperty(json, "type", type)
        addPropertyMSJ(json, "metadata", metadata)

        return json
    }
}