package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.StepIntersection

class MapBoxStepIntersection: MapBoxParsable {
    private val location: MapBoxPoint
    private val bearings: MutableList<Int?> = mutableListOf()
    private val classes: MutableList<String?> = mutableListOf()
    private val entry: MutableList<Boolean?> = mutableListOf()
    private val inside: Int
    private val outside: Int
    private val lanes: MutableList<MapBoxIntersectionLanes?> = mutableListOf()
    private val geometryIndex: Int
    private val isUrban: Boolean
    private val adminIndex: Int
    private val restStop: MapBoxRestStop
    private val tollCollection: MapBoxTollCollection
    private val mapboxStreetsV8: String
    private val tunnelName: String
    private val railwayCrossing: Boolean
    private val trafficSignal: Boolean
    private val stopSign: Boolean
    private val yieldSign: Boolean
    private val interchange: String
    private val junction: String
    private val mergingArea: String

    constructor(intersection: StepIntersection?) {
        this@MapBoxStepIntersection.location = MapBoxPoint(intersection?.location())
        intersection?.bearings()?.run {
            forEach {
                this@MapBoxStepIntersection.bearings.add(it)
            }
        }
        intersection?.classes()?.run {
            forEach {
                this@MapBoxStepIntersection.classes.add(it)
            }
        }
        intersection?.entry()?.run {
            forEach {
                this@MapBoxStepIntersection.entry.add(it)
            }
        }
        this@MapBoxStepIntersection.inside = intersection?.`in`() ?: 0
        this@MapBoxStepIntersection.outside = intersection?.out() ?: 0
        intersection?.lanes()?.run {
            forEach {
                this@MapBoxStepIntersection.lanes.add(MapBoxIntersectionLanes(it))
            }
        }
        this@MapBoxStepIntersection.geometryIndex = intersection?.geometryIndex() ?: 0
        this@MapBoxStepIntersection.isUrban = intersection?.isUrban ?: false
        this@MapBoxStepIntersection.adminIndex = intersection?.adminIndex() ?: 0
        this@MapBoxStepIntersection.restStop = MapBoxRestStop(intersection?.restStop())
        this@MapBoxStepIntersection.tollCollection = MapBoxTollCollection(intersection?.tollCollection())
        this@MapBoxStepIntersection.mapboxStreetsV8 = intersection?.mapboxStreetsV8()?.roadClass() ?: ""
        this@MapBoxStepIntersection.tunnelName = intersection?.tunnelName() ?: ""
        this@MapBoxStepIntersection.railwayCrossing = intersection?.railwayCrossing() ?: false
        this@MapBoxStepIntersection.trafficSignal = intersection?.trafficSignal() ?: false
        this@MapBoxStepIntersection.stopSign = intersection?.stopSign() ?: false
        this@MapBoxStepIntersection.yieldSign = intersection?.yieldSign() ?: false
        this@MapBoxStepIntersection.interchange = intersection?.interchange()?.name() ?: ""
        this@MapBoxStepIntersection.junction = intersection?.junction()?.name() ?: ""
        this@MapBoxStepIntersection.mergingArea = intersection?.mergingArea()?.type() ?: ""
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "location", location)
        addPropertyLI(json, "bearings", bearings)
        addPropertyLS(json, "classes", classes)
        addPropertyLB(json, "entry", entry)
        addProperty(json, "inside", inside)
        addProperty(json, "outside", outside)
        addPropertyLMP(json, "lanes", lanes)
        addProperty(json, "geometryIndex", geometryIndex)
        addProperty(json, "isUrban", isUrban)
        addProperty(json, "adminIndex", adminIndex)
        addProperty(json, "restStop", restStop)
        addProperty(json, "tollCollection", tollCollection)
        addProperty(json, "mapboxStreetsV8", mapboxStreetsV8)
        addProperty(json, "tunnelName", tunnelName)
        addProperty(json, "railwayCrossing", railwayCrossing)
        addProperty(json, "trafficSignal", trafficSignal)
        addProperty(json, "stopSign", stopSign)
        addProperty(json, "yieldSign", yieldSign)
        addProperty(json, "interchange", interchange)
        addProperty(json, "junction", junction)
        addProperty(json, "mergingArea", mergingArea)

        return json
    }
}