package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.navigation.base.trip.model.RouteLegProgress

class MapBoxRouteLegProgress: MapBoxParsable {
    private val legIndex: Int
    // private val routeLeg:
    private val distanceTraveled: Float
    private val distanceRemaining: Float
    private val durationRemaining: Float
    private val fractionTraveled: Float
    //
    //
    private val geometryIndex: Int
    //

    constructor(progress: RouteLegProgress) {

    }

    override fun toJsonObject(): JsonObject {
        TODO("Not yet implemented")
    }
}