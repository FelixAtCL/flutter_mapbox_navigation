package com.eopeter.fluttermapboxnavigation.core

import android.content.Context
import android.view.Gravity
import com.google.gson.Gson
import com.mapbox.bindgen.Value
import com.mapbox.geojson.Point
import com.mapbox.maps.EdgeInsets
import com.mapbox.maps.extension.style.layers.properties.generated.ProjectionName
import com.mapbox.maps.extension.style.projection.generated.Projection
import com.mapbox.maps.logE
import com.mapbox.maps.plugin.attribution.generated.AttributionSettingsInterface
import com.mapbox.maps.plugin.compass.generated.CompassSettingsInterface
import com.mapbox.maps.plugin.locationcomponent.generated.LocationComponentSettingsInterface
import com.mapbox.maps.plugin.logo.generated.LogoSettingsInterface
import com.mapbox.maps.plugin.locationcomponent.createDefault2DPuck
import com.mapbox.maps.plugin.scalebar.generated.ScaleBarSettingsInterface
import org.json.JSONArray
import org.json.JSONObject

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

fun MapAnimationOptions.toMapAnimationOptions(): com.mapbox.maps.plugin.animation.MapAnimationOptions {
    val builder = com.mapbox.maps.plugin.animation.MapAnimationOptions.Builder()
    duration?.let {
        builder.duration(it)
    }
    startDelay?.let {
        builder.startDelay(it)
    }
    return builder.build()
}

fun Number.toDevicePixels(context: Context): Float {
    return this.toFloat() * context.resources.displayMetrics.density
}
fun MbxEdgeInsets.toEdgeInsets(context: Context): EdgeInsets {
    return EdgeInsets(
        top.toDevicePixels(context).toDouble(),
        left.toDevicePixels(context).toDouble(),
        bottom.toDevicePixels(context).toDouble(),
        right.toDevicePixels(context).toDouble()
    )
}

fun ScreenCoordinate.toScreenCoordinate(context: Context): com.mapbox.maps.ScreenCoordinate {
    return com.mapbox.maps.ScreenCoordinate(x.toDevicePixels(context).toDouble(), y.toDevicePixels(context).toDouble())
}

fun com.mapbox.maps.CoordinateBounds.toFLTCoordinateBounds(): CoordinateBounds =
    CoordinateBounds(southwest, northeast, infiniteBounds)

fun CameraOptions.toCameraOptions(context: Context): com.mapbox.maps.CameraOptions = com.mapbox.maps.CameraOptions.Builder()
    .anchor(anchor?.toScreenCoordinate(context))
    .bearing(bearing)
    .center(center)
    .padding(padding?.toEdgeInsets(context))
    .zoom(zoom)
    .pitch(pitch)
    .build()


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

fun com.mapbox.maps.CameraState.toCameraState(context: Context): CameraState = CameraState(
    bearing = bearing,
    padding = padding.toFLTEdgeInsets(context),
    pitch = pitch,
    zoom = zoom,
    center = center
)

fun Point.toFLTScreenCoordinate(): ScreenCoordinate {
    return ScreenCoordinate(x = latitude(), y = longitude())
}

fun RenderedQueryGeometry.toRenderedQueryGeometry(context: Context): com.mapbox.maps.RenderedQueryGeometry {
    return when (type) {
        Type.SCREEN_BOX -> {
            val screenBoxArray = Gson().fromJson(
                value,
                Array<Array<Double>>::class.java
            )
            val minCoord = screenBoxArray[0]
            val maxCoord = screenBoxArray[1]
            com.mapbox.maps.RenderedQueryGeometry.valueOf(
                com.mapbox.maps.ScreenBox(
                    com.mapbox.maps.ScreenCoordinate(
                        minCoord[0].toDevicePixels(context).toDouble(),
                        minCoord[1].toDevicePixels(context).toDouble()
                    ),
                    com.mapbox.maps.ScreenCoordinate(
                        maxCoord[0].toDevicePixels(context).toDouble(),
                        maxCoord[1].toDevicePixels(context).toDouble()
                    )
                )
            )
        }
        Type.LIST -> {
            val array: Array<Array<Double>> =
                Gson().fromJson(value, Array<Array<Double>>::class.java)
            com.mapbox.maps.RenderedQueryGeometry.valueOf(
                array.map {
                    com.mapbox.maps.ScreenCoordinate(it[0].toDevicePixels(context).toDouble(), it[1].toDevicePixels(context).toDouble())
                }.toList()
            )
        }
        Type.SCREEN_COORDINATE -> {
            val pointArray = Gson().fromJson(
                value,
                Array<Double>::class.java
            )

            com.mapbox.maps.RenderedQueryGeometry.valueOf(
                com.mapbox.maps.ScreenCoordinate(
                    pointArray[0].toDevicePixels(context).toDouble(),
                    pointArray[1].toDevicePixels(context).toDouble()
                )
            )
        }
    }
}

fun RenderedQueryOptions.toRenderedQueryOptions(): com.mapbox.maps.RenderedQueryOptions {
    return com.mapbox.maps.RenderedQueryOptions(layerIds, filter?.toValue())
}

fun com.mapbox.maps.QueriedFeature.toFLTQueriedFeature(): QueriedFeature {
    return QueriedFeature(JSONObject(this.feature.toJson()).toMap(), source, sourceLayer, state.toJson())
}

fun JSONObject.toMap(): Map<String?, Any?> = keys().asSequence().associateWith {
    when (val value = this[it]) {
        is JSONArray -> {
            val map = (0 until value.length()).associate { Pair(it.toString(), value[it]) }
            JSONObject(map).toMap().values.toList()
        }
        is JSONObject -> value.toMap()
        JSONObject.NULL -> null
        else -> value
    }
}

fun AttributionSettingsInterface.applyFromFLT(settings: AttributionSettings, context: Context) {
    settings.iconColor?.let { iconColor = it.toInt() }
    settings.position?.let { position = it.toPosition() }
    settings.marginLeft?.let { marginLeft = it.toDevicePixels(context) }
    settings.marginTop?.let { marginTop = it.toDevicePixels(context) }
    settings.marginRight?.let { marginRight = it.toDevicePixels(context) }
    settings.marginBottom?.let { marginBottom = it.toDevicePixels(context) }
    settings.clickable?.let { clickable = it }
}

fun AttributionSettingsInterface.toFLT(context: Context) = AttributionSettings(
    iconColor = iconColor.toUInt().toLong(),
    position = position.toOrnamentPosition(),
    marginLeft = marginLeft.toLogicalPixels(context),
    marginTop = marginTop.toLogicalPixels(context),
    marginRight = marginRight.toLogicalPixels(context),
    marginBottom = marginBottom.toLogicalPixels(context),
    clickable = clickable,
)

fun OrnamentPosition.toPosition(): Int {
    return when (this) {
        OrnamentPosition.BOTTOM_LEFT -> Gravity.BOTTOM or Gravity.START
        OrnamentPosition.BOTTOM_RIGHT -> Gravity.BOTTOM or Gravity.END
        OrnamentPosition.TOP_LEFT -> Gravity.TOP or Gravity.START
        OrnamentPosition.TOP_RIGHT -> Gravity.TOP or Gravity.END
    }
}

fun Int.toOrnamentPosition(): OrnamentPosition {
    return when (this) {
        Gravity.BOTTOM or Gravity.START -> OrnamentPosition.BOTTOM_LEFT
        Gravity.BOTTOM or Gravity.END -> OrnamentPosition.BOTTOM_RIGHT
        Gravity.TOP or Gravity.START -> OrnamentPosition.TOP_LEFT
        else -> {
            OrnamentPosition.TOP_RIGHT
        }
    }
}

fun CompassSettingsInterface.applyFromFLT(settings: CompassSettings, context: Context) {
    settings.enabled?.let { enabled = it }
    settings.position?.let { position = it.toPosition() }
    settings.marginLeft?.let { marginLeft = it.toDevicePixels(context) }
    settings.marginTop?.let { marginTop = it.toDevicePixels(context) }
    settings.marginRight?.let { marginRight = it.toDevicePixels(context) }
    settings.marginBottom?.let { marginBottom = it.toDevicePixels(context) }
    settings.opacity?.let { opacity = it.toFloat() }
    settings.rotation?.let { rotation = it.toFloat() }
    settings.visibility?.let { visibility = it }
    settings.fadeWhenFacingNorth?.let { fadeWhenFacingNorth = it }
    settings.clickable?.let { clickable = it }
}

fun CompassSettingsInterface.toFLT(context: Context) = CompassSettings(
    enabled = enabled,
    position = position.toOrnamentPosition(),
    marginLeft = marginLeft.toLogicalPixels(context),
    marginTop = marginTop.toLogicalPixels(context),
    marginRight = marginRight.toLogicalPixels(context),
    marginBottom = marginBottom.toLogicalPixels(context),
    opacity = opacity.toDouble(),
    rotation = rotation.toDouble(),
    visibility = visibility,
    fadeWhenFacingNorth = fadeWhenFacingNorth,
    clickable = clickable,
)

fun LogoSettingsInterface.applyFromFLT(settings: LogoSettings, context: Context) {
    settings.position?.let { position = it.toPosition() }
    settings.marginLeft?.let { marginLeft = it.toDevicePixels(context) }
    settings.marginTop?.let { marginTop = it.toDevicePixels(context) }
    settings.marginRight?.let { marginRight = it.toDevicePixels(context) }
    settings.marginBottom?.let { marginBottom = it.toDevicePixels(context) }
}

fun LogoSettingsInterface.toFLT(context: Context) = LogoSettings(
    position = position.toOrnamentPosition(),
    marginLeft = marginLeft.toLogicalPixels(context),
    marginTop = marginTop.toLogicalPixels(context),
    marginRight = marginRight.toLogicalPixels(context),
    marginBottom = marginBottom.toLogicalPixels(context),
)

fun ScaleBarSettingsInterface.applyFromFLT(settings: ScaleBarSettings, context: Context) {
    settings.enabled?.let { enabled = it }
    settings.position?.let { position = it.toPosition() }
    settings.marginLeft?.let { marginLeft = it.toDevicePixels(context) }
    settings.marginTop?.let { marginTop = it.toDevicePixels(context) }
    settings.marginRight?.let { marginRight = it.toDevicePixels(context) }
    settings.marginBottom?.let { marginBottom = it.toDevicePixels(context) }
    settings.textColor?.let { textColor = it.toInt() }
    settings.primaryColor?.let { primaryColor = it.toInt() }
    settings.secondaryColor?.let { secondaryColor = it.toInt() }
    settings.borderWidth?.let { borderWidth = it.toDevicePixels(context) }
    settings.height?.let { height = it.toDevicePixels(context) }
    settings.textBarMargin?.let { textBarMargin = it.toDevicePixels(context) }
    settings.textBorderWidth?.let { textBorderWidth = it.toDevicePixels(context) }
    settings.textSize?.let { textSize = it.toFloat() }
    settings.isMetricUnits?.let { isMetricUnits = it }
    settings.refreshInterval?.let { refreshInterval = it }
    settings.showTextBorder?.let { showTextBorder = it }
    settings.ratio?.let { ratio = it.toFloat() }
    settings.useContinuousRendering?.let { useContinuousRendering = it }
}

fun ScaleBarSettingsInterface.toFLT(context: Context) = ScaleBarSettings(
    enabled = enabled,
    position = position.toOrnamentPosition(),
    marginLeft = marginLeft.toLogicalPixels(context),
    marginTop = marginTop.toLogicalPixels(context),
    marginRight = marginRight.toLogicalPixels(context),
    marginBottom = marginBottom.toLogicalPixels(context),
    textColor = textColor.toUInt().toLong(),
    primaryColor = primaryColor.toUInt().toLong(),
    secondaryColor = secondaryColor.toUInt().toLong(),
    borderWidth = borderWidth.toLogicalPixels(context),
    height = height.toLogicalPixels(context),
    textBarMargin = textBarMargin.toLogicalPixels(context),
    textBorderWidth = textBorderWidth.toLogicalPixels(context),
    textSize = textSize.toDouble(),
    isMetricUnits = isMetricUnits,
    refreshInterval = refreshInterval,
    showTextBorder = showTextBorder,
    ratio = ratio.toDouble(),
    useContinuousRendering = useContinuousRendering,
)

fun LocationComponentSettingsInterface.applyFromFLT(settings: LocationComponentSettings, useDefaultPuck2DIfNeeded: Boolean, context: Context) {
    settings.enabled?.let { enabled = it }
    settings.pulsingEnabled?.let { pulsingEnabled = it }
    settings.pulsingColor?.let { pulsingColor = it.toInt() }
    settings.pulsingMaxRadius?.let { pulsingMaxRadius = it.toFloat() }
    settings.layerAbove?.let { layerAbove = it }
    settings.layerBelow?.let { layerBelow = it }
}

fun LocationComponentSettingsInterface.toFLT(context: Context) = LocationComponentSettings(
    enabled = enabled,
    pulsingEnabled = pulsingEnabled,
    pulsingColor = pulsingColor.toUInt().toLong(),
    pulsingMaxRadius = pulsingMaxRadius.toDouble(),
    layerAbove = layerAbove,
    layerBelow = layerBelow,
)

