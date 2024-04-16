package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.BannerComponents

class MapBoxBannerComponents: MapBoxParsable {
    private val text: String
    private val type: String
    private val subType: String
    private val abbreviation: String
    private val abbreviationPriority: Int
    private val imageBaseUrl: String
    private val mapboxShield: MapBoxMapboxShield
    private val imageUrl: String
    private val directions: MutableList<String> = mutableListOf()
    private val active: Boolean
    private val activeDirection: String

    constructor(components: BannerComponents) {
        this@MapBoxBannerComponents.text = components.text()
        this@MapBoxBannerComponents.type = components.type()
        this@MapBoxBannerComponents.subType = components.subType() ?: ""
        this@MapBoxBannerComponents.abbreviation = components.abbreviation() ?: ""
        this@MapBoxBannerComponents.abbreviationPriority = components.abbreviationPriority() ?: 0
        this@MapBoxBannerComponents.imageBaseUrl = components.imageBaseUrl() ?: ""
        this@MapBoxBannerComponents.mapboxShield = MapBoxMapboxShield(components.mapboxShield())
        this@MapBoxBannerComponents.imageUrl = components.imageUrl() ?: ""
        components.directions()?.run {
            forEach {
                this@MapBoxBannerComponents.directions.add(it)
            }
        }
        this@MapBoxBannerComponents.active = components.active() ?: false
        this@MapBoxBannerComponents.activeDirection = components.activeDirection() ?: ""
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "text", text)
        addProperty(json, "type", type)
        addProperty(json, "subType", subType)
        addProperty(json, "abbreviation", abbreviation)
        addProperty(json, "abbreviationPriority", abbreviationPriority)
        addProperty(json, "imageBaseUrl", imageBaseUrl)
        addProperty(json, "mapboxShield", mapboxShield)
        addProperty(json, "imageUrl", imageUrl)
        addProperty(json, "directions", directions)
        addProperty(json, "active", active)
        addProperty(json, "activeDirection", activeDirection)

        return json
    }
}