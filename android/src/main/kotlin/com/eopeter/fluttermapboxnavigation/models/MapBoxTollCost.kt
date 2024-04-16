package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.TollCost

class MapBoxTollCost : MapBoxParsable {
    private val currency: String
    private val paymentMethods: MapBoxPaymentMethods

    constructor(cost: TollCost) {
        this@MapBoxTollCost.currency = cost.currency() ?: ""
        this@MapBoxTollCost.paymentMethods = MapBoxPaymentMethods(cost.paymentMethods())
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "currency", currency)
        addProperty(json, "paymentMethods", paymentMethods)

        return json
    }
}