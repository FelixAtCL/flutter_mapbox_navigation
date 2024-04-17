package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.DirectionsResponse

class MapBoxDirectionsResponse: MapBoxParsable {
    private val code: String
    private val message: String
    private val waypoints: MutableList<MapBoxDirectionsWaypoint> = mutableListOf()
    private val routes: MutableList<MapBoxDirectionsRoute> = mutableListOf()
    private val uuid: String
    private val metadata: Map<String, String>

    constructor(response: DirectionsResponse?) {
        this@MapBoxDirectionsResponse.code = response?.code() ?: ""
        this@MapBoxDirectionsResponse.message = response?.message() ?: ""
        this@MapBoxDirectionsResponse.uuid = response?.uuid() ?: ""
        response?.waypoints()?.run {
            forEach{
                this@MapBoxDirectionsResponse.waypoints.add(MapBoxDirectionsWaypoint(it))
            }
        }
        response?.routes()?.run {
            forEach {
                this@MapBoxDirectionsResponse.routes.add(MapBoxDirectionsRoute(it))
            }
        }
        this@MapBoxDirectionsResponse.metadata = response?.metadata()?.infoMap() ?: emptyMap()
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "code", code)
        addProperty(json, "message", message)
        addProperty(json, "waypoints", waypoints)
        addProperty(json, "routes", routes)
        addProperty(json, "uuid", uuid)
        addProperty(json, "metadata", metadata)

        return json
    }
}