package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.navigation.base.trip.model.RouteLegProgress

class MapBoxRouteLegProgress: MapBoxParsable {
    private val legIndex: Int
    private val routeLeg: MapBoxRouteLeg
    private val distanceTraveled: Float
    private val distanceRemaining: Float
    private val durationRemaining: Double
    private val fractionTraveled: Float
    private val currentStepProgress: MapBoxRouteStepProgress
    private val upcomingStep: MapBoxLegStep
    private val geometryIndex: Int
    private val legDestination: MapBoxLegWaypoint

    constructor(progress: RouteLegProgress?) {
        this@MapBoxRouteLegProgress.legIndex = progress?.legIndex ?: 0
        this@MapBoxRouteLegProgress.routeLeg = MapBoxRouteLeg(progress?.routeLeg)
        this@MapBoxRouteLegProgress.distanceTraveled = progress?.distanceTraveled ?: 0.0f
        this@MapBoxRouteLegProgress.distanceRemaining = progress?.distanceRemaining ?: 0.0f
        this@MapBoxRouteLegProgress.durationRemaining = progress?.durationRemaining ?: 0.0
        this@MapBoxRouteLegProgress.fractionTraveled = progress?.fractionTraveled ?: 0.0f
        this@MapBoxRouteLegProgress.currentStepProgress = MapBoxRouteStepProgress(progress?.currentStepProgress)
        this@MapBoxRouteLegProgress.upcomingStep = MapBoxLegStep(progress?.upcomingStep)
        this@MapBoxRouteLegProgress.geometryIndex = progress?.geometryIndex ?: 0
        this@MapBoxRouteLegProgress.legDestination = MapBoxLegWaypoint(progress?.legDestination)
    }

    override fun toJsonObject(): JsonObject {
        TODO("Not yet implemented")
    }
}