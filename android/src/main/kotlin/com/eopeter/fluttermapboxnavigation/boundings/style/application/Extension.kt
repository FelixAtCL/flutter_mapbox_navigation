package com.eopeter.fluttermapboxnavigation.boundings.style.application

import android.content.Context
import com.mapbox.maps.CameraOptions
import com.mapbox.maps.EdgeInsets
import com.mapbox.maps.ScreenCoordinate

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