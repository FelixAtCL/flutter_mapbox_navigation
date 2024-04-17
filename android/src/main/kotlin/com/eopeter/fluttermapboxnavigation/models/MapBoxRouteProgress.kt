package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.BannerInstructions
import com.mapbox.navigation.base.ExperimentalPreviewMapboxNavigationAPI
import com.mapbox.navigation.base.internal.extensions.internalAlternativeRouteIndices
import com.mapbox.navigation.base.route.NavigationRoute
import com.mapbox.navigation.base.trip.model.RouteProgress
import com.mapbox.navigation.base.trip.model.RouteProgressState
import okhttp3.Route

class MapBoxRouteProgress: MapBoxParsable {
    private val navigationRoute: MapBoxNavigationRoute
    private val bannerInstructions: MapBoxBannerInstructions
    private val voiceInstructions: MapBoxVoiceInstructions
    private val currentState: String
    private val currentLegProgress: MapBoxRouteLegProgress
    private val upcomingStepPoints: MutableList<MapBoxPoint> = mutableListOf()
    private val inTunnel: Boolean
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
    private val alternativeRouteIndices: MutableMap<String, MapBoxRouteIndices> = mutableMapOf()

    @OptIn(ExperimentalPreviewMapboxNavigationAPI::class)
    constructor(progress: RouteProgress?) {
        this@MapBoxRouteProgress.navigationRoute = MapBoxNavigationRoute(progress?.navigationRoute)
        this@MapBoxRouteProgress.bannerInstructions = MapBoxBannerInstructions(progress?.bannerInstructions)
        this@MapBoxRouteProgress.voiceInstructions = MapBoxVoiceInstructions(progress?.voiceInstructions)
        this@MapBoxRouteProgress.currentState = mapStateToString(progress?.currentState)
        this@MapBoxRouteProgress.currentLegProgress = MapBoxRouteLegProgress(progress?.currentLegProgress)
        progress?.upcomingStepPoints?.run {
            forEach {
                this@MapBoxRouteProgress.upcomingStepPoints.add(MapBoxPoint(it))
            }
        }
        this@MapBoxRouteProgress.inTunnel = progress?.inTunnel ?: false
        this@MapBoxRouteProgress.distanceRemaining = progress?.distanceRemaining ?: 0.0f
        this@MapBoxRouteProgress.distanceTraveled = progress?.distanceTraveled ?: 0.0f
        this@MapBoxRouteProgress.durationRemaining = progress?.durationRemaining ?: 0.0
        this@MapBoxRouteProgress.fractionTraveled = progress?.fractionTraveled ?: 0.0f
        this@MapBoxRouteProgress.remainingWaypoints = progress?.remainingWaypoints ?: 0
        progress?.upcomingRoadObjects?.run {
            forEach {
                this@MapBoxRouteProgress.upcomingRoadObjects.add(MapBoxUpcomingRoadObject(it))
            }
        }
        this@MapBoxRouteProgress.stale = progress?.stale ?: false
        this@MapBoxRouteProgress.routeAlternativeId = progress?.routeAlternativeId ?: ""
        this@MapBoxRouteProgress.currentRouteGeometryIndex = progress?.currentRouteGeometryIndex ?: -1
        this@MapBoxRouteProgress.inParkingAisle = progress?.inParkingAisle ?: false
        progress?.internalAlternativeRouteIndices()?.run {
            forEach{
                this@MapBoxRouteProgress.alternativeRouteIndices[it.key] = MapBoxRouteIndices(it.value)
            }
        }
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "navigationRoute", navigationRoute)
        addProperty(json, "bannerInstructions", bannerInstructions)
        addProperty(json, "voiceInstructions", voiceInstructions)
        addProperty(json, "currentState", currentState)
        addProperty(json, "currentLegProgress", currentLegProgress)
        addProperty(json, "upcomingStepPoints", upcomingStepPoints)
        addProperty(json, "inTunnel", inTunnel)
        addProperty(json, "distanceRemaining", distanceRemaining)
        addProperty(json, "distanceTraveled", distanceTraveled)
        addProperty(json, "fractionTraveled", fractionTraveled)
        addProperty(json, "remainingWaypoints", remainingWaypoints)
        addProperty(json, "upcomingRoadObjects", upcomingRoadObjects)
        addProperty(json, "stale", stale)
        addProperty(json, "routeAlternativeId", routeAlternativeId)
        addProperty(json, "currentRouteGeometryIndex", currentRouteGeometryIndex)
        addProperty(json, "inParkingAisle", inParkingAisle)
        addProperty(json, "alternativeRouteIndices", alternativeRouteIndices)

        return json
    }

    private fun mapStateToString(state: RouteProgressState?): String {
        return when(state) {
            RouteProgressState.INITIALIZED -> "INITIALIZED"
            RouteProgressState.OFF_ROUTE -> "OFF_ROUTE"
            RouteProgressState.COMPLETE -> "COMPLETE"
            RouteProgressState.TRACKING -> "TRACKING"
            RouteProgressState.UNCERTAIN -> "UNCERTAIN"
            else -> ""
        }
    }
}