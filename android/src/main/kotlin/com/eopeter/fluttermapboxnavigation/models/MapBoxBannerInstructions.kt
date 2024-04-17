package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.BannerInstructions

class MapBoxBannerInstructions: MapBoxParsable {
    private val distanceAlongGeometry: Double
    private val primary: MapBoxBannerText
    private val secondary: MapBoxBannerText
    private val sub: MapBoxBannerText
    private val view: MapBoxBannerView

    constructor(instructions: BannerInstructions?) {
        this@MapBoxBannerInstructions.distanceAlongGeometry = instructions?.distanceAlongGeometry() ?: -1.0
        this@MapBoxBannerInstructions.primary = MapBoxBannerText(instructions?.primary())
        this@MapBoxBannerInstructions.secondary = MapBoxBannerText(instructions?.secondary())
        this@MapBoxBannerInstructions.sub = MapBoxBannerText(instructions?.sub())
        this@MapBoxBannerInstructions.view = MapBoxBannerView(instructions?.view())
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "distanceAlongGeometry", distanceAlongGeometry)

        return json
    }
}