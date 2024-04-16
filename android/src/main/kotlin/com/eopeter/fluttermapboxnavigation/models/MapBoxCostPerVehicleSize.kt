package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.CostPerVehicleSize

class MapBoxCostPerVehicleSize : MapBoxParsable {
    private val small: Double
    private val standard: Double
    private val middle: Double
    private val large: Double
    private val jumbo: Double

    constructor(cost: CostPerVehicleSize?) {
        this@MapBoxCostPerVehicleSize.small = cost?.small() ?: -1.0
        this@MapBoxCostPerVehicleSize.standard = cost?.standard() ?: -1.0
        this@MapBoxCostPerVehicleSize.middle = cost?.middle() ?: -1.0
        this@MapBoxCostPerVehicleSize.large = cost?.large() ?: -1.0
        this@MapBoxCostPerVehicleSize.jumbo = cost?.jumbo() ?: -1.0
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "small", small)
        addProperty(json, "standard", standard)
        addProperty(json, "middle", middle)
        addProperty(json, "large", large)
        addProperty(json, "jumbo", jumbo)

        return json
    }
}