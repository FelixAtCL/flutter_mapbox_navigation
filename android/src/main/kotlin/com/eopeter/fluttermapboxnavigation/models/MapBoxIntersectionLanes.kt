package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.IntersectionLanes

class MapBoxIntersectionLanes: MapBoxParsable {
    private val valid: Boolean
    private val active: Boolean
    private val validIndication: String
    private val indications: MutableList<String?> = mutableListOf()
    private val paymentMethods: MutableList<String?> = mutableListOf()

    constructor(lanes: IntersectionLanes?) {
        this@MapBoxIntersectionLanes.valid = lanes?.valid() ?: false
        this@MapBoxIntersectionLanes.active = lanes?.active() ?: false
        this@MapBoxIntersectionLanes.validIndication = lanes?.validIndication() ?: ""
        lanes?.indications()?.run {
            forEach {
                this@MapBoxIntersectionLanes.indications.add(it)
            }
        }
        lanes?.paymentMethods()?.run {
            forEach {
                this@MapBoxIntersectionLanes.paymentMethods.add(it)
            }
        }
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "valid", valid)
        addProperty(json, "active", active)
        addProperty(json, "validIndication", validIndication)
        addPropertyLS(json, "indications", indications)
        addPropertyLS(json, "paymentMethods", paymentMethods)

        return json
    }
}