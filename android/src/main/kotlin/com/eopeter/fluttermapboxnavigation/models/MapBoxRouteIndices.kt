package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.navigation.base.internal.trip.model.RouteIndices

class MapBoxRouteIndices: MapBoxParsable {
    private val legIndex: Int
    private val stepIndex: Int
    private val routeGeometryIndex: Int
    private val legGeometryIndex: Int
    private val intersectionIndex: Int

    constructor(indice: RouteIndices?) {
        this@MapBoxRouteIndices.legIndex = indice?.legIndex ?: -1
        this@MapBoxRouteIndices.stepIndex = indice?.stepIndex ?: -1
        this@MapBoxRouteIndices.routeGeometryIndex = indice?.routeGeometryIndex ?: -1
        this@MapBoxRouteIndices.legGeometryIndex = indice?.legGeometryIndex ?: -1
        this@MapBoxRouteIndices.intersectionIndex = indice?.intersectionIndex ?: -1
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "legIndex", legIndex)
        addProperty(json, "stepIndex", stepIndex)
        addProperty(json, "routeGeometryIndex", routeGeometryIndex)
        addProperty(json, "legGeometryIndex", legGeometryIndex)
        addProperty(json, "intersectionIndex", intersectionIndex)

        return json
    }
}