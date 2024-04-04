package com.eopeter.fluttermapboxnavigation.boundings.style

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Application
import android.content.Context
import android.location.Location
import android.os.Bundle
import android.util.Log
import androidx.lifecycle.LifecycleOwner
import com.eopeter.fluttermapboxnavigation.databinding.NavigationActivityBinding
import com.eopeter.fluttermapboxnavigation.models.MapBoxEvents
import com.eopeter.fluttermapboxnavigation.models.MapBoxRouteProgressEvent
import com.eopeter.fluttermapboxnavigation.models.Waypoint
import com.eopeter.fluttermapboxnavigation.models.WaypointSet
import com.eopeter.fluttermapboxnavigation.utilities.CustomInfoPanelEndNavButtonBinder
import com.eopeter.fluttermapboxnavigation.utilities.PluginUtilities
import com.google.gson.Gson
import com.mapbox.bindgen.DataRef
import com.mapbox.bindgen.Value
import com.mapbox.maps.Image
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.extension.localization.localizeLabels
import com.mapbox.maps.extension.style.light.setLight
import com.mapbox.maps.extension.style.projection.generated.getProjection
import com.mapbox.maps.extension.style.projection.generated.setProjection
import com.mapbox.maps.logE
import com.mapbox.maps.mapbox_maps.pigeons.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

class StyleApi : MethodChannel.MethodCallHandler {
    open var methodChannel: MethodChannel? = null
    private val messenger: BinaryMessenger
    private val mapboxMap: MapboxMap?
    private val viewId: Int

    constructor(messenger: BinaryMessenger, mapboxMap: MapboxMap?, viewId: Int) {
        this@StyleApi.messenger = messenger
        this@StyleApi.mapboxMap = mapboxMap
        this@StyleApi.viewId = viewId
        methodChannel = MethodChannel(this@StyleApi.messenger, "flutter_mapbox_navigation/style/${this@StyleApi.viewId}")
    }

    fun getStyleURI(methodCall: MethodCall, result: MethodChannel.Result) {
        result.success(mapboxMap?.style?.styleURI ?: "")
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            "getStyleURI" -> {
                this.getStyleURI(methodCall, result)
            }
            else -> result.notImplemented()
        }
    }
}
