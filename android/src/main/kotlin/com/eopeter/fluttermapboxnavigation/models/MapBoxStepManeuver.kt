package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.StepManeuver

class MapBoxStepManeuver: MapBoxParsable {
    private val location: MapBoxPoint
    private val bearingBefore: Double
    private val bearingAfter: Double
    private val instruction: String
    private val type: String
    private val modifier: String
    private val exit: Int

    constructor(maneuver: StepManeuver?) {
        this@MapBoxStepManeuver.location = MapBoxPoint(maneuver?.location())
        this@MapBoxStepManeuver.bearingBefore = maneuver?.bearingBefore() ?: 0.0
        this@MapBoxStepManeuver.bearingAfter = maneuver?.bearingAfter() ?: 0.0
        this@MapBoxStepManeuver.instruction = maneuver?.instruction() ?: ""
        this@MapBoxStepManeuver.type = maneuver?.type() ?: ""
        this@MapBoxStepManeuver.modifier = maneuver?.modifier() ?: ""
        this@MapBoxStepManeuver.exit = maneuver?.exit() ?: 0
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "location", location)
        addProperty(json, "bearingBefore", bearingBefore)
        addProperty(json, "bearingAfter", bearingAfter)
        addProperty(json, "instruction", instruction)
        addProperty(json, "type", type)
        addProperty(json, "modifier", modifier)
        addProperty(json, "exit", exit)

        return json
    }
}