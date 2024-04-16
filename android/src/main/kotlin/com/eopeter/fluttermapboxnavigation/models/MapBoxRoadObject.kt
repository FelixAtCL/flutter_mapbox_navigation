package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.navigation.base.trip.model.roadobject.RoadObject

class MapBoxRoadObject : MapBoxParsable {
    private val id: String
    private val objectType: Int
    private val length: Double
    private val provider: String
    private val isUrban: Boolean
    private val location: MapBoxRoadObjectLocation

    constructor(roadObject: RoadObject?) {
        this@MapBoxRoadObject.id = roadObject?.id ?: ""
        this@MapBoxRoadObject.objectType = roadObject?.objectType ?: -1
        this@MapBoxRoadObject.length = roadObject?.length ?: 0.0
        this@MapBoxRoadObject.provider = roadObject?.provider ?: ""
        this@MapBoxRoadObject.isUrban = roadObject?.isUrban ?: false
        this@MapBoxRoadObject.location = MapBoxRoadObjectLocation(roadObject?.location)
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "id", id)
        addProperty(json, "objectType", objectType)
        addProperty(json, "length", length)
        addProperty(json, "provider", provider)
        addProperty(json, "isUrban", isUrban)
        addProperty(json, "location", location)

        return json
    }
}