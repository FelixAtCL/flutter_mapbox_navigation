package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.navigation.base.trip.model.roadobject.distanceinfo.RoadObjectDistanceInfo

class MapBoxRoadObjectDistanceInfo: MapBoxParsable {
    private val roadObjectId: String
    private val roadObjectType: String
    private val distanceInfoType: String

    constructor(info: RoadObjectDistanceInfo?){
        this@MapBoxRoadObjectDistanceInfo.roadObjectId = info?.roadObjectId ?: ""
        this@MapBoxRoadObjectDistanceInfo.roadObjectType = mapRoadObjectTypeId(info?.roadObjectType ?: -1)
        this@MapBoxRoadObjectDistanceInfo.distanceInfoType = mapDistanceInfoTypeId(info?.distanceInfoType ?: -1)
    }

    private fun mapRoadObjectTypeId(id: Int) : String {
        return when(id) {
            0 -> "tunnel"
            1 -> "country_border_crossing"
            2 -> "toll_collection"
            3 -> "rest_stop"
            4 -> "restricted_area"
            5 -> "bridge"
            6 -> "incident"
            7 -> "custom"
            8 -> "railway_crossing"
            9 -> "ic"
            10 -> "jct"
            11 -> "merging_area"
            else -> "Unknown"
        }
    }

    private fun mapDistanceInfoTypeId(id: Int) : String {
        return when(id) {
            0 -> "gantry"
            1 -> "line"
            2 -> "point"
            3 -> "polygon"
            4 -> "sub_graph"
            else -> "Unknown"
        }
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "roadObjectId", roadObjectId)
        addProperty(json, "roadObjectType", roadObjectType)
        addProperty(json, "distanceInfoType", distanceInfoType)

        return json
    }
}