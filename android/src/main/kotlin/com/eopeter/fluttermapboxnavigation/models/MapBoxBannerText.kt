package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.BannerText

class MapBoxBannerText: MapBoxParsable {
    private val text: String
    private val components: MutableList<MapBoxBannerComponents> = mutableListOf()
    private val type: String
    private val modifier: String
    private val degrees: Double
    private val drivingSide: String

    constructor(banner: BannerText?) {
        this@MapBoxBannerText.text = banner?.text() ?: ""
        banner?.components()?.run {
            forEach {
                this@MapBoxBannerText.components.add(MapBoxBannerComponents(it))
            }
        }
        this@MapBoxBannerText.type = banner?.type() ?: ""
        this@MapBoxBannerText.modifier = banner?.modifier() ?: ""
        this@MapBoxBannerText.degrees = banner?.degrees() ?: 0.0
        this@MapBoxBannerText.drivingSide = banner?.drivingSide() ?: "right"
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "text", text)
        addProperty(json, "components", components)
        addProperty(json, "type", type)
        addProperty(json, "modifier", modifier)
        addProperty(json, "degrees", degrees)
        addProperty(json, "drivingSide", drivingSide)

        return json
    }
}