package com.eopeter.fluttermapboxnavigation.boundings.style.application

import android.content.Context
import com.eopeter.fluttermapboxnavigation.boundings.style.domain.*
import com.mapbox.bindgen.Value
import com.mapbox.maps.extension.style.layers.properties.generated.ProjectionName
import com.mapbox.maps.extension.style.projection.generated.Projection
import com.mapbox.maps.logE

fun com.mapbox.maps.CameraOptions.toFLTCameraOptions(context: Context): CameraOptions {
    return CameraOptions(
        center = center,
        anchor = anchor?.toFLTScreenCoordinate(context),
        padding = padding?.toFLTEdgeInsets(context),
        zoom = zoom,
        pitch = pitch,
        bearing = bearing
    )
}

fun com.mapbox.maps.EdgeInsets.toFLTEdgeInsets(context: Context): MbxEdgeInsets = MbxEdgeInsets(
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

fun CoordinateBounds.toCoordinateBounds() =
    com.mapbox.maps.CoordinateBounds(southwest, northeast, infiniteBounds)

fun Projection.toFLTProjection(): StyleProjection {
    return StyleProjection(name.toFLTProjectionName())
}

fun ProjectionName.toFLTProjectionName(): StyleProjectionName {
    return when (this) {
        ProjectionName.GLOBE -> StyleProjectionName.GLOBE
        ProjectionName.MERCATOR -> StyleProjectionName.MERCATOR
        else -> { throw java.lang.RuntimeException("Projection $this is not supported.") }
    }
}

fun StyleProjection.toProjection(): com.mapbox.maps.extension.style.projection.generated.Projection {
    return com.mapbox.maps.extension.style.projection.generated.Projection(name.toProjectionName())
}

fun StyleProjectionName.toProjectionName(): ProjectionName {
    return when (this) {
        StyleProjectionName.GLOBE -> ProjectionName.GLOBE
        StyleProjectionName.MERCATOR -> ProjectionName.MERCATOR
    }
}
