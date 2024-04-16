package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.VoiceInstructions

class MapBoxVoiceInstructions: MapBoxParsable {
    private val distanceAlongGeometry: Double
    private val announcement: String
    private val ssmlAnnouncement: String

    constructor(instructions: VoiceInstructions?) {
        this@MapBoxVoiceInstructions.distanceAlongGeometry = instructions?.distanceAlongGeometry() ?: 0.0
        this@MapBoxVoiceInstructions.announcement = instructions?.announcement() ?: ""
        this@MapBoxVoiceInstructions.ssmlAnnouncement = instructions?.ssmlAnnouncement() ?: ""
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "distanceAlongGeometry", distanceAlongGeometry)
        addProperty(json, "announcement", announcement)
        addProperty(json, "ssmlAnnouncement", ssmlAnnouncement)

        return json
    }
}