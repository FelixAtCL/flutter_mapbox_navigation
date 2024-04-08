package com.eopeter.fluttermapboxnavigation.boundings.location.port

import android.content.Context
import com.eopeter.fluttermapboxnavigation.boundings.location.application.LocationApiCodec
import com.eopeter.fluttermapboxnavigation.core.*
import com.mapbox.maps.MapView
import com.mapbox.maps.plugin.locationcomponent.location
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec

class LocationApi: MethodChannel.MethodCallHandler {
    private var methodChannel: MethodChannel? = null
    private val messenger: BinaryMessenger
    private val mapView: MapView
    private val context: Context
    private val viewId: Int

    constructor(messenger: BinaryMessenger, mapView: MapView, viewId: Int, context: Context) {
        this@LocationApi.messenger = messenger
        this@LocationApi.mapView = mapView
        this@LocationApi.viewId = viewId
        this@LocationApi.context = context
    }

    fun init() {
        this.methodChannel =
            MethodChannel(
                this.messenger,
                "flutter_mapbox_navigation/location/${this.viewId}",
                StandardMethodCodec(LocationApiCodec)
            )
        this.methodChannel?.setMethodCallHandler(this)
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            "getSettings" -> {
                this.getSettings(methodCall, result)
            }
            "updateSettings" -> {
                this.updateSettings(methodCall, result)
            }
            else -> result.notImplemented()
        }
    }

    private fun getSettings(methodCall: MethodCall, result: MethodChannel.Result) {
        result.success(mapView.location.toFLT(context))
    }

    private fun updateSettings(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val settings = arguments["settings"] as? LocationComponentSettings ?: return
        mapView.location.applyFromFLT(settings,true, context)
        result.success(null)
    }
}