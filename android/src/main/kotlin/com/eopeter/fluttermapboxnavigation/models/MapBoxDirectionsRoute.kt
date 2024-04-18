package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.DirectionsRoute

class MapBoxDirectionsRoute: MapBoxParsable {
    private val routeIndex: String
    private val distance: Double
    private val duration: Double
    private val durationTypical: Double
    private val geometry: String
    private val weight: Double
    private val weightName: String
    private val legs: MutableList<MapBoxRouteLeg> = mutableListOf()
    private val waypoints: MutableList<MapBoxDirectionsWaypoint> = mutableListOf()
    private val routeOptions: MapBoxRouteOptions
    private val voiceLanguage: String
    private val requestUuid: String
    private val tollCosts: MutableList<MapBoxTollCost> = mutableListOf()

    constructor(route: DirectionsRoute?) {
        this@MapBoxDirectionsRoute.routeIndex = route?.routeIndex() ?: ""
        this@MapBoxDirectionsRoute.distance = route?.distance() ?: 0.0
        this@MapBoxDirectionsRoute.duration = route?.duration() ?: 0.0
        this@MapBoxDirectionsRoute.durationTypical = route?.durationTypical() ?: 0.0
        this@MapBoxDirectionsRoute.geometry = route?.geometry() ?: ""
        this@MapBoxDirectionsRoute.weight = route?.weight() ?: 0.0
        this@MapBoxDirectionsRoute.weightName = route?.weightName() ?: ""
        route?.legs()?.run {
            forEach {
                this@MapBoxDirectionsRoute.legs.add(MapBoxRouteLeg(it))
            }
        }
        route?.waypoints()?.run {
            forEach {
                this@MapBoxDirectionsRoute.waypoints.add(MapBoxDirectionsWaypoint(it))
            }
        }
        this@MapBoxDirectionsRoute.routeOptions = MapBoxRouteOptions(route?.routeOptions())
        this@MapBoxDirectionsRoute.voiceLanguage = route?.voiceLanguage() ?: ""
        this@MapBoxDirectionsRoute.requestUuid = route?.requestUuid() ?: ""
        route?.tollCosts()?.run {
            forEach {
                this@MapBoxDirectionsRoute.tollCosts.add(MapBoxTollCost(it))
            }
        }
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "routeIndex", routeIndex)
        addProperty(json, "distance", distance)
        addProperty(json, "duration", duration)
        addProperty(json, "durationTypical", durationTypical)
        addProperty(json, "geometry", geometry)
        addProperty(json, "weight", weight)
        addProperty(json, "weightName", weightName)
        addPropertyLJ(json, "legs", legs.map{it.toJsonObject()})
        addPropertyLMP(json, "waypoints", waypoints)
        addProperty(json, "routeOptions", routeOptions)
        addProperty(json, "voiceLanguage", voiceLanguage)
        addProperty(json, "requestUuid", requestUuid)
        addPropertyLMP(json, "tollCosts", tollCosts)


        return json
    }
}