package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.navigation.base.trip.model.roadobject.UpcomingRoadObject

class MapBoxUpcomingRoadObject: MapBoxParsable {
    private val roadObject: MapBoxRoadObject
    private val distanceToStart: Double
    private val distanceInfo: MapBoxRoadObjectDistanceInfo

    constructor(upcoming: UpcomingRoadObject?) {
        this@MapBoxUpcomingRoadObject.roadObject = MapBoxRoadObject(upcoming?.roadObject)
        this@MapBoxUpcomingRoadObject.distanceToStart = upcoming?.distanceToStart ?: 0.0
        this@MapBoxUpcomingRoadObject.distanceInfo = MapBoxRoadObjectDistanceInfo(upcoming?.distanceInfo)
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "roadObject", roadObject)
        addProperty(json, "distanceToStart", distanceToStart)
        addProperty(json, "distanceInfo", distanceInfo)

        return json
    }
}