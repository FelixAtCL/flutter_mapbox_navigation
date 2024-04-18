package com.eopeter.fluttermapboxnavigation.models

import com.google.gson.JsonArray
import com.google.gson.JsonElement
import com.google.gson.JsonObject

abstract class MapBoxParsable {

    abstract fun toJsonObject(): JsonObject

    protected fun addProperty(json: JsonObject, prop: String, value: Boolean?) {
        if(value != null) {
            json.addProperty(prop, value)
        }
    }

    protected fun addProperty(json: JsonObject, prop: String, value: Double?) {
        if (value != null) {
            json.addProperty(prop, value)
        }
    }

    protected fun addProperty(json: JsonObject, prop: String, value: Int?) {
        if (value != null) {
            json.addProperty(prop, value)
        }
    }

    protected fun addProperty(json: JsonObject, prop: String, value: String?) {
        if (value?.isNotEmpty() == true) {
            json.addProperty(prop, value)
        }
    }

    protected fun addProperty(json: JsonObject, prop: String, value: Float?) {
        if (value != null) {
            json.addProperty(prop, value)
        }
    }

    protected fun addPropertyMSS(json: JsonObject, prop: String, value: Map<String,String>) {
        val map = JsonObject()
        value.run {
            forEach {
                map.addProperty(it.key, it.value)
            }
        }

        json.add(prop, map)
    }

    protected fun addPropertyMSJ(json: JsonObject, prop: String, value: Map<String,JsonElement>) {
        val map = JsonObject()
        value.run {
            forEach {
                map.add(it.key, it.value)
            }
        }

        json.add(prop, map)
    }

    protected fun addPropertyMSMP(json: JsonObject, prop: String, value: Map<String,MapBoxParsable>) {
        val map = JsonObject()
        value.run {
            forEach {
                map.add(it.key, it.value.toJsonObject())
            }
        }

        json.add(prop, map)
    }

    protected fun addProperty(json: JsonObject, prop: String, value: MapBoxParsable) {
        json.add(prop, value.toJsonObject())
    }

    protected fun addPropertyLS(json: JsonObject, prop: String, value: List<String>) {
        val array = JsonArray()
        value.run {
            forEach {
                array.add(it)
            }
        }
        json.add(prop, array)
    }

    protected fun addPropertyLD(json: JsonObject, prop: String, value: List<Double>) {
        val array = JsonArray()
        value.run {
            forEach {
                array.add(it)
            }
        }
        json.add(prop, array)
    }

    protected fun addPropertyLI(json: JsonObject, prop: String, value: List<Int>) {
        val array = JsonArray()
        value.run {
            forEach {
                array.add(it)
            }
        }
        json.add(prop, array)
    }

    protected fun addPropertyLB(json: JsonObject, prop: String, value: List<Boolean>) {
        val array = JsonArray()
        value.run {
            forEach {
                array.add(it)
            }
        }
        json.add(prop, array)
    }

    protected fun addPropertyLMP(json: JsonObject, prop: String, value: List<MapBoxParsable>) {
        val array = JsonArray()
        value.run {
            forEach {
                array.add(it.toJsonObject())
            }
        }
        json.add(prop, array)
    }

    protected fun addPropertyLJ(json: JsonObject, prop: String, value: List<JsonObject>) {
        val array = JsonArray()
        value.run {
            forEach {
                array.add(it)
            }
        }
        json.add(prop, array)
    }
}