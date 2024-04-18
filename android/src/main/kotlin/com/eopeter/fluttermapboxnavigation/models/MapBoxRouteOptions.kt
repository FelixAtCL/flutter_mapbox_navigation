package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.RouteOptions

class MapBoxRouteOptions : MapBoxParsable {
    private val baseUrl: String
    private val user: String
    private val profile: String
    private val coordinates: String
    private val coordinatesList: MutableList<MapBoxPoint> = mutableListOf()
    private val alternatives: Boolean
    private val language: String
    private val radiuses: String
    private val radiusesList: MutableList<Double> = mutableListOf()
    private val bearings: String
    private val bearingsList: MutableList<MapBoxBearing> = mutableListOf()
    private val avoidManeuverRadius: Double
    private val layers: String
    private val layersList: MutableList<Int> = mutableListOf()
    private val continueStraight: Boolean
    private val roundaboutExists: Boolean
    private val geometries: String
    private val overview: String
    private val steps: Boolean
    private val annotations: String
    private val annotationsList: MutableList<String> = mutableListOf()
    private val exclude: String
    private val excludeList: MutableList<String> = mutableListOf()
    private val excludeObject: MapBoxExclude
    private val include: String
    private val includeList: MutableList<String> = mutableListOf()
    private val voiceInstructions: Boolean
    private val bannerInstructions: Boolean
    private val voiceUnits: String
    private val approaches: String
    private val approachesList: MutableList<String> = mutableListOf()
    private val waypointIndices: String
    private val waypointIndicesList: MutableList<Int> = mutableListOf()
    private val waypointNames: String
    private val waypointNamesList: MutableList<String> = mutableListOf()
    private val waypointTargets: String
    private val waypointTargetsList: MutableList<MapBoxPoint> = mutableListOf()
    private val waypointsPerRoute: Boolean
    private val alleyBias: Double
    private val walkingSpeed: Double
    private val walkwayBias: Double
    private val snappingIncludeClosures: String
    private val snappingIncludeStaticClosures: String
    private val snappingIncludeClosuresList: MutableList<Boolean> = mutableListOf()
    private val snappingIncludeStaticClosuresList: MutableList<Boolean> = mutableListOf()
    private val arriveBy: String
    private val departAt: String
    private val maxHeight: Double
    private val maxWidth: Double
    private val maxWeight: Double
    private val enableRefresh: Boolean
    private val computeTollCost: Boolean
    private val metadata: Boolean
    private val paymantMethods: String
    private val paymentMethodsList: MutableList<String> = mutableListOf()
    private val suppressVoiceInstructionLocalNames: Boolean

    constructor(options: RouteOptions?) {
        this@MapBoxRouteOptions.baseUrl = options?.baseUrl() ?: ""
        this@MapBoxRouteOptions.user = options?.user() ?: ""
        this@MapBoxRouteOptions.profile = options?.profile() ?: ""
        this@MapBoxRouteOptions.coordinates = options?.coordinates() ?: ""
        options?.coordinatesList()?.run{
            forEach {
                this@MapBoxRouteOptions.coordinatesList.add(MapBoxPoint(it))
            }
        }
        this@MapBoxRouteOptions.alternatives = options?.alternatives() ?: false
        this@MapBoxRouteOptions.language = options?.language() ?: ""
        this@MapBoxRouteOptions.radiuses = options?.radiuses() ?: ""
        options?.radiusesList()?.run {
            forEach {
                this@MapBoxRouteOptions.radiusesList.add(it)
            }
        }
        this@MapBoxRouteOptions.bearings = options?.bearings() ?: ""
        options?.bearingsList()?.run {
            forEach {
                this@MapBoxRouteOptions.bearingsList.add(MapBoxBearing(it))
            }
        }
        this@MapBoxRouteOptions.avoidManeuverRadius = options?.avoidManeuverRadius() ?: 0.0
        this@MapBoxRouteOptions.layers = options?.layers() ?: ""
        options?.layersList()?.run {
            forEach {
                this@MapBoxRouteOptions.layersList.add(it)
            }
        }
        this@MapBoxRouteOptions.continueStraight = options?.continueStraight() ?: false
        this@MapBoxRouteOptions.roundaboutExists = options?.roundaboutExits() ?: false
        this@MapBoxRouteOptions.geometries = options?.geometries() ?: ""
        this@MapBoxRouteOptions.overview = options?.overview() ?: ""
        this@MapBoxRouteOptions.steps = options?.steps() ?: false
        this@MapBoxRouteOptions.annotations = options?.annotations() ?: ""
        options?.annotationsList()?.run {
            forEach {
                this@MapBoxRouteOptions.annotationsList.add(it)
            }
        }
        this@MapBoxRouteOptions.exclude = options?.exclude() ?: ""
        options?.excludeList()?.run {
            forEach {
                this@MapBoxRouteOptions.excludeList.add(it)
            }
        }
        this@MapBoxRouteOptions.excludeObject = MapBoxExclude(options?.excludeObject())
        this@MapBoxRouteOptions.include = options?.include() ?: ""
        options?.includeList()?.run {
            forEach {
                this@MapBoxRouteOptions.includeList.add(it)
            }
        }
        this@MapBoxRouteOptions.voiceInstructions = options?.voiceInstructions() ?: false
        this@MapBoxRouteOptions.bannerInstructions = options?.bannerInstructions() ?: false
        this@MapBoxRouteOptions.voiceUnits = options?.voiceUnits() ?: ""
        this@MapBoxRouteOptions.approaches = options?.approaches() ?: ""
        options?.approachesList()?.run {
            forEach {
                this@MapBoxRouteOptions.approachesList.add(it)
            }
        }
        this@MapBoxRouteOptions.waypointIndices = options?.waypointIndices() ?: ""
        options?.waypointIndicesList()?.run {
            forEach {
                this@MapBoxRouteOptions.waypointIndicesList.add(it)
            }
        }
        this@MapBoxRouteOptions.waypointNames = options?.waypointNames() ?: ""
        options?.waypointNamesList()?.run {
            forEach{
                this@MapBoxRouteOptions.waypointNamesList.add(it)
            }
        }
        this@MapBoxRouteOptions.waypointTargets = options?.waypointTargets() ?: ""
        options?.waypointTargetsList()?.run {
            forEach{
                this@MapBoxRouteOptions.waypointTargetsList.add(MapBoxPoint(it))
            }
        }
        this@MapBoxRouteOptions.waypointsPerRoute = options?.waypointsPerRoute() ?: false
        this@MapBoxRouteOptions.alleyBias = options?.alleyBias() ?: 0.0
        this@MapBoxRouteOptions.walkingSpeed = options?.walkingSpeed() ?: 0.0
        this@MapBoxRouteOptions.walkwayBias = options?.walkwayBias() ?: 0.0
        this@MapBoxRouteOptions.snappingIncludeClosures = options?.snappingIncludeClosures() ?: ""
        this@MapBoxRouteOptions.snappingIncludeStaticClosures = options?.snappingIncludeStaticClosures() ?: ""
        options?.snappingIncludeClosuresList()?.run {
            forEach {
                this@MapBoxRouteOptions.snappingIncludeClosuresList.add(it)
            }
        }
        options?.snappingIncludeStaticClosuresList()?.run {
            forEach {
                this@MapBoxRouteOptions.snappingIncludeStaticClosuresList.add(it)
            }
        }
        this@MapBoxRouteOptions.arriveBy = options?.arriveBy() ?: ""
        this@MapBoxRouteOptions.departAt = options?.departAt() ?: ""
        this@MapBoxRouteOptions.maxHeight = options?.maxHeight() ?: 1.6
        this@MapBoxRouteOptions.maxWidth = options?.maxWidth() ?: 1.9
        this@MapBoxRouteOptions.maxWeight = options?.maxWeight() ?: 2.5
        this@MapBoxRouteOptions.enableRefresh = options?.enableRefresh() ?: false
        this@MapBoxRouteOptions.computeTollCost = options?.computeTollCost() ?: false
        this@MapBoxRouteOptions.metadata = options?.metadata() ?: false
        this@MapBoxRouteOptions.paymantMethods = options?.paymentMethods() ?: ""
        options?.paymentMethodsList()?.run {
            forEach {
                this@MapBoxRouteOptions.paymentMethodsList.add(it)
            }
        }
        this@MapBoxRouteOptions.suppressVoiceInstructionLocalNames = options?.suppressVoiceInstructionLocalNames() ?: false
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "baseUrl", baseUrl)
        addProperty(json, "user", user)
        addProperty(json, "profile", profile)
        addProperty(json, "coordinates", coordinates)
        addPropertyLMP(json, "coordinatesList", coordinatesList)
        addProperty(json, "alternatives", alternatives)
        addProperty(json, "language", language)
        addProperty(json, "radiuses", radiuses)
        addPropertyLD(json, "radiusesList", radiusesList)
        addProperty(json, "bearings", bearings)
        addPropertyLMP(json, "bearingsList", bearingsList)
        addProperty(json, "avoidManeuverRadius", avoidManeuverRadius)
        addProperty(json, "layers", layers)
        addPropertyLI(json, "layersList", layersList)
        addProperty(json, "continueStraight", continueStraight)
        addProperty(json, "roundaboutExits", roundaboutExists)
        addProperty(json, "geometries", geometries)
        addProperty(json, "overview", overview)
        addProperty(json, "steps", steps)
        addProperty(json, "annotiations", annotations)
        addPropertyLS(json, "annotationsList", annotationsList)
        addPropertyLI(json, "layersList", layersList)
        addProperty(json, "exclude", exclude)
        addPropertyLS(json, "excludeList", excludeList)
        addProperty(json, "excludeObject", excludeObject)
        addPropertyLI(json, "layersList", layersList)
        addProperty(json, "include", include)
        addPropertyLS(json, "includeList", includeList)
        addProperty(json, "voiceInstructions", voiceInstructions)
        addProperty(json, "bannerInstructions", bannerInstructions)
        addProperty(json, "voiceUnits", voiceUnits)
        addProperty(json, "approaches", approaches)
        addPropertyLS(json, "approachesList", approachesList)
        addProperty(json, "waypointIndices", waypointIndices)
        addPropertyLI(json, "waypointIndicesList", waypointIndicesList)
        addProperty(json, "waypointNames", waypointNames)
        addPropertyLS(json, "waypointNamesList", waypointNamesList)
        addProperty(json, "waypointTargets", waypointTargets)
        addPropertyLMP(json, "waypointTargetsList", waypointTargetsList)
        addProperty(json, "waypointsPerRoute", waypointsPerRoute)
        addProperty(json, "alleyBias", alleyBias)
        addProperty(json, "walkingSpeed", walkingSpeed)
        addProperty(json, "walkwayBias", walkwayBias)
        addProperty(json, "snappingIncludeClosures", snappingIncludeClosures)
        addProperty(json, "snappingIncludeStaticClosures", snappingIncludeStaticClosures)
        addPropertyLB(json, "snappingIncludeClosuresList", snappingIncludeClosuresList)
        addPropertyLB(json, "snappingIncludeStaticClosuresList", snappingIncludeStaticClosuresList)
        addProperty(json, "arriveBy", arriveBy)
        addProperty(json, "departAt", departAt)
        addProperty(json, "maxHeight", maxHeight)
        addProperty(json, "maxWidth", maxWidth)
        addProperty(json, "maxWeight", maxWeight)
        addProperty(json, "enableRefresh", enableRefresh)
        addProperty(json, "computeTollCost", computeTollCost)
        addProperty(json, "metadata", metadata)
        addProperty(json, "paymentMethods", paymantMethods)
        addPropertyLS(json, "paymentMethodsList", paymentMethodsList)
        addProperty(json, "suppressVoiceInstructionLocalNames", suppressVoiceInstructionLocalNames)

        return json
    }
}