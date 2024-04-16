package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.MapboxShield

class MapBoxMapboxShield: MapBoxParsable {
    private val baseUrl: String
    private val name: String
    private val textColor: String
    private val displayRef: String

    constructor(shield: MapboxShield?) {
        this@MapBoxMapboxShield.baseUrl = shield?.baseUrl() ?: ""
        this@MapBoxMapboxShield.name = shield?.name() ?: ""
        this@MapBoxMapboxShield.textColor = shield?.textColor() ?: ""
        this@MapBoxMapboxShield.displayRef = shield?.displayRef() ?: ""
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "baseUrl", baseUrl)
        addProperty(json, "name", name)
        addProperty(json, "textColor", textColor)
        addProperty(json, "displayRef", displayRef)

        return json
    }
}