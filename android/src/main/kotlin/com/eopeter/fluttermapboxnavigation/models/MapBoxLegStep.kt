package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.LegStep

class MapBoxLegStep: MapBoxParsable {
    private val distance: Double
    private val duration: Double
    private val durationTypical: Double
    private val speedLimitUnit: String
    private val speedLimitSign: String
    private val geometry: String
    private val name: String
    private val ref: String
    private val destinations: String
    private val mode: String
    private val pronunciation: String
    private val rotaryName: String
    private val rotaryPronunciation: String
    private val maneuver: MapBoxStepManeuver
    private val voiceInstructions: MutableList<MapBoxVoiceInstructions> = mutableListOf()
    private val bannerInstructions: MutableList<MapBoxBannerInstructions> = mutableListOf()
    private val drivingSide: String
    private val weight: Double
    private val intersections: MutableList<MapBoxStepIntersection> = mutableListOf()
    private val exits: String

    constructor(step: LegStep?) {
        this@MapBoxLegStep.distance = step?.distance() ?: 0.0
        this@MapBoxLegStep.duration = step?.duration() ?: 0.0
        this@MapBoxLegStep.durationTypical = step?.durationTypical() ?: 0.0
        this@MapBoxLegStep.speedLimitUnit = step?.speedLimitUnit() ?: ""
        this@MapBoxLegStep.speedLimitSign = step?.speedLimitSign() ?: ""
        this@MapBoxLegStep.geometry = step?.geometry() ?: ""
        this@MapBoxLegStep.name = step?.name() ?: ""
        this@MapBoxLegStep.ref = step?.ref() ?: ""
        this@MapBoxLegStep.destinations = step?.destinations() ?: ""
        this@MapBoxLegStep.mode = step?.mode() ?: ""
        this@MapBoxLegStep.pronunciation = step?.pronunciation() ?: ""
        this@MapBoxLegStep.rotaryName = step?.rotaryName() ?: ""
        this@MapBoxLegStep.rotaryPronunciation = step?.rotaryPronunciation() ?: ""
        this@MapBoxLegStep.maneuver = MapBoxStepManeuver(step?.maneuver())
        step?.voiceInstructions()?.run {
            forEach {
                this@MapBoxLegStep.voiceInstructions.add(MapBoxVoiceInstructions(it))
            }
        }
        step?.bannerInstructions()?.run {
            forEach {
                this@MapBoxLegStep.bannerInstructions.add(MapBoxBannerInstructions(it))
            }
        }
        this@MapBoxLegStep.drivingSide = step?.drivingSide() ?: ""
        this@MapBoxLegStep.weight = step?.weight() ?: 0.0
        step?.intersections()?.run {
            forEach {
                this@MapBoxLegStep.intersections.add(MapBoxStepIntersection(it))
            }
        }
        this@MapBoxLegStep.exits = step?.exits() ?: ""
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "distance", distance)
        addProperty(json, "duration", duration)
        addProperty(json, "durationTypical", durationTypical)
        addProperty(json, "speedLimitUnit", speedLimitUnit)
        addProperty(json, "speedLimitSign", speedLimitSign)
        addProperty(json, "geometry", geometry)
        addProperty(json, "name", name)
        addProperty(json, "ref", ref)
        addProperty(json, "destinations",destinations)
        addProperty(json, "mode", mode)
        addProperty(json, "pronunciation", pronunciation)
        addProperty(json, "rotaryName",rotaryName)
        addProperty(json, "rotaryPronunciation", rotaryPronunciation)
        addProperty(json, "maneuver", maneuver)
        addProperty(json, "voiceInstructions", voiceInstructions)
        addProperty(json, "bannerInstructions", bannerInstructions)
        addProperty(json, "drivingSide", drivingSide)
        addProperty(json, "weight", weight)
        addProperty(json, "intersections", intersections)
        addProperty(json, "exits", exits)

        return json
    }
}