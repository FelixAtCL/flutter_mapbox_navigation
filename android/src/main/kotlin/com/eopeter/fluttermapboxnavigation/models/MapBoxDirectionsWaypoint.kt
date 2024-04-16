package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.DirectionsWaypoint

class MapBoxDirectionsWaypoint : MapBoxParsable {
    val name: String
    val location: MapBoxPoint
    var distance: Double? = null

    constructor(waypoint: DirectionsWaypoint) {
        this@MapBoxDirectionsWaypoint.name = waypoint.name()
        this@MapBoxDirectionsWaypoint.location = MapBoxPoint(waypoint.location())
        this@MapBoxDirectionsWaypoint.distance = waypoint.distance()
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "name", name)
        json.add("location", location.toJsonObject())
        addProperty(json, "distance", distance)

        return json
    }


}