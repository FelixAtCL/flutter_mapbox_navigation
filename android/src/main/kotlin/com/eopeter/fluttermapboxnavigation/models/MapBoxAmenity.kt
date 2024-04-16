package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.Amenity

class MapBoxAmenity: MapBoxParsable {
    private val type: String
    private val name: String
    private val brand: String

    constructor(amenity: Amenity?) {
        this@MapBoxAmenity.type = amenity?.type() ?: ""
        this@MapBoxAmenity.name = amenity?.name() ?: ""
        this@MapBoxAmenity.brand = amenity?.brand() ?: ""
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "type", type)
        addProperty(json, "name", name)
        addProperty(json, "brand", brand)

        return json
    }
}