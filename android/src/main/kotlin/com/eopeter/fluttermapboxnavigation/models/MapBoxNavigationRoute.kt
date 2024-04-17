package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.navigation.base.route.NavigationRoute

class MapBoxNavigationRoute : MapBoxParsable {
    private val directionsResponse: MapBoxDirectionsResponse
    private val routeIndex: Int
    private val routeOptions: MapBoxRouteOptions
    private val directionsRoute: MapBoxDirectionsRoute
    private val id: String
    // origin => Not logically parsable with current information
    private val upcomingRoadObjects: MutableList<MapBoxUpcomingRoadObject> = mutableListOf()
    private val waypoints: MutableList<MapBoxDirectionsWaypoint> = mutableListOf()

    constructor(navigationRoute: NavigationRoute?) {
        this@MapBoxNavigationRoute.routeIndex = navigationRoute?.routeIndex ?: -1
        this@MapBoxNavigationRoute.directionsResponse = MapBoxDirectionsResponse(navigationRoute?.directionsResponse)
        this@MapBoxNavigationRoute.routeOptions = MapBoxRouteOptions(navigationRoute?.routeOptions)
        this@MapBoxNavigationRoute.directionsRoute = MapBoxDirectionsRoute(navigationRoute?.directionsRoute)
        this@MapBoxNavigationRoute.id = navigationRoute?.id ?: ""
        navigationRoute?.upcomingRoadObjects?.run {
            forEach{
                this@MapBoxNavigationRoute.upcomingRoadObjects.add(MapBoxUpcomingRoadObject(it))
            }
        }
        navigationRoute?.waypoints?.run {
            forEach {
                this@MapBoxNavigationRoute.waypoints.add(MapBoxDirectionsWaypoint(it))
            }
        }
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "routeIndex", routeIndex)
        addProperty(json, "directionsResponse", directionsResponse)
        addProperty(json, "routeOptions", routeOptions)
        addProperty(json, "directionsRoute", directionsRoute)
        addProperty(json, "id", id)
        addProperty(json, "upcomingRoadObjects", upcomingRoadObjects)
        addProperty(json, "waypoints", waypoints)

        return json
    }
}