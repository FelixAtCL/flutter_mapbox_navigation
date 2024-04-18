package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.RestStop

class MapBoxRestStop: MapBoxParsable {
    private val type: String
    private val name: String
    private val amenities: MutableList<MapBoxAmenity?> = mutableListOf()
    private val guideMap: String

    constructor(stop: RestStop?) {
        this@MapBoxRestStop.type = stop?.type() ?: ""
        this@MapBoxRestStop.name = stop?.name() ?: ""
        stop?.amenities()?.run {
            forEach {
                this@MapBoxRestStop.amenities.add(MapBoxAmenity(it))
            }
        }
        this@MapBoxRestStop.guideMap = stop?.guideMap() ?: ""
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "type", type)
        addProperty(json, "name", name)
        addPropertyLMP(json, "amenities", amenities)
        addProperty(json, "guideMap", guideMap)

        return json
    }
}