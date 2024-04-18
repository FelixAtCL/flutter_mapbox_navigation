package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.navigation.base.ExperimentalPreviewMapboxNavigationAPI
import com.mapbox.navigation.base.internal.extensions.internalAlternativeRouteIndices
import com.mapbox.navigation.base.trip.model.RouteProgress
import com.mapbox.navigation.base.trip.model.RouteProgressState

class MapBoxRouteProgress: MapBoxParsable {
    private val navigationRoute: MapBoxNavigationRoute // -> RouteOptions
    private val bannerInstructions: MapBoxBannerInstructions
    private val voiceInstructions: MapBoxVoiceInstructions
    private val currentState: String
    private var currentLeg: MapBoxRouteLeg? = null
    private var upcomingLeg: MapBoxRouteLeg? = null
    private val currentLegIndex: Int
    private val currentLegProgress: MapBoxRouteLegProgress //
    private val upcomingStepPoints: MutableList<MapBoxPoint?> = mutableListOf()
    private val inTunnel: Boolean
    private val distanceRemaining: Float //
    private val distanceTraveled: Float //
    private val durationRemaining: Double //
    private val fractionTraveled: Float //
    private val remainingWaypointsCount: Int // -> remainingWaypointCounts
    private val remainingWaypoints: MutableList<MapBoxDirectionsWaypoint> = mutableListOf()
    private val route: MapBoxDirectionsRoute
    private val routeOptions: MapBoxRouteOptions
    private val upcomingRoadObjects: MutableList<MapBoxUpcomingRoadObject?> = mutableListOf() //
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
        this@MapBoxRouteProgress.remainingWaypointsCount = progress?.remainingWaypoints ?: 0
        this@MapBoxRouteProgress.route = MapBoxDirectionsRoute(progress?.route)
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
        this@MapBoxRouteProgress.currentLegIndex = progress?.currentLegProgress?.legIndex ?: 0
        this@MapBoxRouteProgress.routeOptions = MapBoxRouteOptions(progress?.route?.routeOptions())
        if(progress?.currentLegProgress != null && progress.navigationRoute.directionsRoute.legs() != null) {
            if(progress.currentLegProgress!!.legIndex < progress.navigationRoute.directionsRoute.legs()!!.count()) {
                this@MapBoxRouteProgress.currentLeg = MapBoxRouteLeg(
                    progress.navigationRoute.directionsRoute.legs()!!.elementAt(progress.currentLegProgress!!.legIndex)
                )
            }
            if(progress.currentLegProgress!!.legIndex - 1 < progress.navigationRoute.directionsRoute.legs()!!.count()) {
                this@MapBoxRouteProgress.upcomingLeg = MapBoxRouteLeg(
                    progress.navigationRoute.directionsRoute.legs()!!.elementAt(progress.currentLegProgress!!.legIndex + 1)
                )
            }
        }

        if(progress?.route?.waypoints() != null) {
            val count = progress.route.waypoints()!!.count()
            val drivenWaypointCount = progress.route.waypoints()!!.count() - progress.remainingWaypoints
            val remainingWaypoints = progress.route.waypoints()!!.subList(drivenWaypointCount, count)
            remainingWaypoints.run {
                forEach {
                    this@MapBoxRouteProgress.remainingWaypoints.add(MapBoxDirectionsWaypoint(it))
                }
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
        addProperty(json, "currentLeg", currentLeg)
        addProperty(json, "currentLegIndex", currentLegIndex)
        addProperty(json, "upcomingLeg", upcomingLeg)
        addPropertyLMP(json, "upcomingStepPoints", upcomingStepPoints)
        addProperty(json, "inTunnel", inTunnel)
        addProperty(json, "distanceRemaining", distanceRemaining)
        addProperty(json, "durationRemaining", durationRemaining)
        addProperty(json, "distanceTraveled", distanceTraveled)
        addProperty(json, "fractionTraveled", fractionTraveled)
        addProperty(json, "remainingWaypointsCount", remainingWaypointsCount)
        addPropertyLMP(json, "remainingWaypoints", remainingWaypoints)
        addPropertyLMP(json, "upcomingRoadObjects", upcomingRoadObjects)
        addProperty(json, "stale", stale)
        addProperty(json, "route", route)
        addProperty(json, "routeOptions", routeOptions)
        addProperty(json, "routeAlternativeId", routeAlternativeId)
        addProperty(json, "currentRouteGeometryIndex", currentRouteGeometryIndex)
        addProperty(json, "inParkingAisle", inParkingAisle)
        addPropertyMSMP(json, "alternativeRouteIndices", alternativeRouteIndices)

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