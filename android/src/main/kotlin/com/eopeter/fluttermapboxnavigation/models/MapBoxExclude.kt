package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.Exclude

class MapBoxExclude : MapBoxParsable {
    private var criteria: MutableList<String> = mutableListOf()
    private var points: MutableList<MapBoxPoint> = mutableListOf()

    constructor(exclude: Exclude?) {
        exclude?.criteria()?.run {
            forEach {
                this@MapBoxExclude.criteria.add(it)
            }
        }

        exclude?.points()?.run {
            forEach {
                this@MapBoxExclude.points.add(MapBoxPoint(it))
            }
        }
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addPropertyLS(json, "criteria", criteria)
        addPropertyLJ(json, "points", points.map{it.toJsonObject()})

        return json
    }
}