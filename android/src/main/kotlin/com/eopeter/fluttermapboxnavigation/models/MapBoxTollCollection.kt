package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.TollCollection

class MapBoxTollCollection: MapBoxParsable {
    private val type: String
    private val name: String

    constructor(collection: TollCollection?) {
        this@MapBoxTollCollection.type = collection?.type() ?: ""
        this@MapBoxTollCollection.name = collection?.name() ?: ""
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "type", type)
        addProperty(json, "name", name)

        return json
    }
}