package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.navigation.base.trip.model.RouteStepProgress

class MapBoxRouteStepProgress: MapBoxParsable {
    private val stepIndex: Int
    private val intersectionIndex: Int
    private val instructionIndex: Int
    private val step: MapBoxLegStep
    private val stepPoints: MutableList<MapBoxPoint> = mutableListOf()
    private val distanceRemaining: Float
    private val distanceTraveled: Float
    private val fractionTraveled: Float
    private val durationRemaining: Double

    constructor(progress: RouteStepProgress?) {
        this@MapBoxRouteStepProgress.stepIndex = progress?.stepIndex ?: 0
        this@MapBoxRouteStepProgress.intersectionIndex = progress?.intersectionIndex ?: 0
        this@MapBoxRouteStepProgress.instructionIndex = progress?.instructionIndex ?: 0
        this@MapBoxRouteStepProgress.step = MapBoxLegStep(progress?.step)
        progress?.stepPoints?.run {
            forEach {
                this@MapBoxRouteStepProgress.stepPoints.add(MapBoxPoint(it))
            }
        }
        this@MapBoxRouteStepProgress.distanceRemaining = progress?.distanceRemaining ?: 0.0f
        this@MapBoxRouteStepProgress.distanceTraveled = progress?.distanceTraveled ?: 0.0f
        this@MapBoxRouteStepProgress.fractionTraveled = progress?.fractionTraveled ?: 0.0f
        this@MapBoxRouteStepProgress.durationRemaining = progress?.durationRemaining ?: 0.0
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "stepIndex", stepIndex)
        addProperty(json, "intersectionIndex", intersectionIndex)
        addProperty(json, "instructionIndex", instructionIndex)
        addProperty(json, "step", step)
        addPropertyLMP(json, "stepPoints", stepPoints)
        addProperty(json, "distanceRemaining", distanceRemaining)
        addProperty(json, "distanceTraveled", distanceTraveled)
        addProperty(json, "fractionTraveled", fractionTraveled)
        addProperty(json, "durationRemaining", durationRemaining)

        return json
    }
}