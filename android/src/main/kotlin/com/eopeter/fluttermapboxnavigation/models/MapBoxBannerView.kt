package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.BannerView

class MapBoxBannerView: MapBoxParsable {
    private val text: String
    private val components: MutableList<MapBoxBannerComponents> = mutableListOf()
    private val type: String
    private val modifier: String

    constructor(view: BannerView?) {
        this@MapBoxBannerView.text = view?.text() ?: ""
        view?.components()?.run {
            forEach {
                this@MapBoxBannerView.components.add(MapBoxBannerComponents(it))
            }
        }
        this@MapBoxBannerView.type = view?.type() ?: ""
        this@MapBoxBannerView.modifier = view?.modifier() ?: ""
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "text", text)
        addPropertyLMP(json, "components", components)
        addProperty(json, "type", type)
        addProperty(json, "modifier", modifier)

        return json
    }
}