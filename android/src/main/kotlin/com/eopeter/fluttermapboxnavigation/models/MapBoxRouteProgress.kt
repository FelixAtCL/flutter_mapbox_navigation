package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.navigation.base.trip.model.RouteProgress

class MapBoxRouteProgress: MapBoxParsable {
    private val navigationRoute: MapBoxNavigationRoute
    private val bannerInstructions: MapBoxBannerInstructions
    private val voiceInstructions: MapBoxVoiceInstructions
    private val currentState: String
    // private val currentLegProgress: MapBox
    private val upcomingStepPoints: MutableList<MapBoxPoint> = mutableListOf()
    private val isTunnel: Boolean
    private val distanceRemaining: Float
    private val distanceTraveled: Float
    private val durationRemaining: Double
    private val fractionTraveled: Float
    private val remainingWaypoints: Int
    private val upcomingRoadObjects: MutableList<MapBoxUpcomingRoadObject> = mutableListOf()
    private val stale: Boolean
    private val routeAlternativeId: String
    private val currentRouteGeometryIndex: Int
    private val inParkingAisle: Boolean

    constructor(progress: RouteProgress)

    override fun toJsonObject(): JsonObject {
        TODO("Not yet implemented")
    }
}