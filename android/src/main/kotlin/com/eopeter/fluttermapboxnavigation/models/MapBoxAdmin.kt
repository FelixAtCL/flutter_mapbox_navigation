package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonObject
import com.mapbox.api.directions.v5.models.Admin

class MapBoxAdmin : MapBoxParsable {
    val countryCode: String
    val countryCodeAlpha3: String

    constructor(admin: Admin) {
        this@MapBoxAdmin.countryCode = admin.countryCode() ?: ""
        this@MapBoxAdmin.countryCodeAlpha3 = admin.countryCodeAlpha3() ?: ""
    }

    override fun toJsonObject(): JsonObject {
        val json = JsonObject()

        addProperty(json, "countryCode", countryCode)
        addProperty(json, "countryCodeAlpha3", countryCodeAlpha3)

        return json
    }
}