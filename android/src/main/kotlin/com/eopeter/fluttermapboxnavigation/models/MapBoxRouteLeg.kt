package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.RouteLeg

class MapBoxRouteLeg: MapBoxParsable {
    private val distance: Double
    private val duration: Double
    private val durationTypical: Double
    private val summary: String
    private val admins: MutableList<MapBoxAdmin?> = mutableListOf()
    private val steps: MutableList<MapBoxLegStep?> = mutableListOf()

    constructor(leg: RouteLeg?) {
        this@MapBoxRouteLeg.distance = leg?.distance() ?: 0.0
        this@MapBoxRouteLeg.duration = leg?.duration() ?: 0.0
        this@MapBoxRouteLeg.durationTypical = leg?.durationTypical() ?: 0.0
        this@MapBoxRouteLeg.summary = leg?.summary() ?: ""
        leg?.admins()?.run{
            forEach {
                this@MapBoxRouteLeg.admins.add(MapBoxAdmin(it))
            }
        }
        leg?.steps()?.run{
            forEach {
                this@MapBoxRouteLeg.steps.add(MapBoxLegStep(it))
            }
        }
    }

    override fun toJsonObject(): JsonObject {
        var json = JsonObject()

        addProperty(json, "distance", distance)
        addProperty(json, "duration", duration)
        addProperty(json, "durationTypical", durationTypical)
        addProperty(json, "summary", summary)
        addPropertyLMP(json, "admins", admins)
        addPropertyLMP(json, "steps", steps)

        return json
    }

}
