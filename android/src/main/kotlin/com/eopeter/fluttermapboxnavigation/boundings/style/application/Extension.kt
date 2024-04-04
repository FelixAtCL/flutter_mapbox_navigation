package com.eopeter.fluttermapboxnavigation.boundings.style.application

import android.content.Context
import com.mapbox.bindgen.Value
import com.mapbox.maps.CameraOptions
import com.mapbox.maps.EdgeInsets
import com.mapbox.maps.ScreenCoordinate
import com.mapbox.maps.StyleObjectInfo
import com.mapbox.maps.logE

fun CameraOptions.toFLTCameraOptions(context: Context): CameraOptions {
    var builder = CameraOptions.Builder()
    builder.anchor(anchor?.toFLTScreenCoordinate(context))
    builder.center(center)
    builder.padding(padding?.toFLTEdgeInsets(context))
    builder.zoom(zoom)
    builder.bearing(bearing)
    builder.pitch(pitch)
    return builder.build()
}

fun EdgeInsets.toFLTEdgeInsets(context: Context): EdgeInsets = EdgeInsets(
    top.toLogicalPixels(context),
    left.toLogicalPixels(context),
    bottom.toLogicalPixels(context),
    right.toLogicalPixels(context)
)

fun com.mapbox.maps.ScreenCoordinate.toFLTScreenCoordinate(context: Context): ScreenCoordinate {
    return ScreenCoordinate(x.toLogicalPixels(context), y.toLogicalPixels(context))
}

fun Number.toLogicalPixels(context: Context): Double {
    return this.toDouble() / context.resources.displayMetrics.density
}

fun com.mapbox.maps.StyleObjectInfo.toFLTStyleObjectInfo(): StyleObjectInfo {
    return StyleObjectInfo(id, type)
}

fun Any.toValue(): Value {
    return if (this is String) {
        if (this.startsWith("{") || this.startsWith("[")) {
            Value.fromJson(this).value!!
        } else {
            val number = this.toDoubleOrNull()
            if (number != null) {
                Value.valueOf(number)
            } else {
                Value.valueOf(this)
            }
        }
    } else if (this is Double) {
        Value.valueOf(this)
    } else if (this is Long) {
        Value.valueOf(this)
    } else if (this is Int) {
        Value.valueOf(this.toLong())
    } else if (this is Boolean) {
        Value.valueOf(this)
    } else if (this is IntArray) {
        val valueArray = this.map { Value(it.toLong()) }
        Value(valueArray)
    } else if (this is BooleanArray) {
        val valueArray = this.map(::Value)
        Value(valueArray)
    } else if (this is DoubleArray) {
        val valueArray = this.map(::Value)
        Value(valueArray)
    } else if (this is FloatArray) {
        val valueArray = this.map { Value(it.toDouble()) }
        Value(valueArray)
    } else if (this is LongArray) {
        val valueArray = this.map(::Value)
        Value(valueArray)
    } else if (this is Array<*>) {
        val valueArray = this.map { it?.toValue() }
        Value(valueArray)
    } else if (this is List<*>) {
        val valueArray = this.map { it?.toValue() }
        Value(valueArray)
    } else {
        logE(
            "StyleAPI Extension",
            "Can not map value, type is not supported: ${this::class.java.canonicalName}"
        )
        Value.valueOf("")
    }
}
fun Value.toFLTValue(): Any? {
    return when (contents) {
        is List<*> -> {
            (contents as List<*>).map { (it as? Value)?.toFLTValue() ?: it }
        }
        is Map<*, *> -> {
            (contents as Map<*, *>)
                .mapKeys { (it.key as? Value)?.toFLTValue() ?: it.key }
                .mapValues { (it.value as? Value)?.toFLTValue() ?: it.value }
        }
        else -> {
            contents
        }
    }

}
