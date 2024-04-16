package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.PaymentMethods

class MapBoxPaymentMethods : MapBoxParsable {
    private val etc: MapBoxCostPerVehicleSize
    private val cash: MapBoxCostPerVehicleSize

    constructor(method: PaymentMethods?) {
        this@MapBoxPaymentMethods.etc = MapBoxCostPerVehicleSize(method?.etc())
        this@MapBoxPaymentMethods.cash = MapBoxCostPerVehicleSize(method?.cash())
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "etc", etc)
        addProperty(json, "cash", cash)

        return json
    }
}