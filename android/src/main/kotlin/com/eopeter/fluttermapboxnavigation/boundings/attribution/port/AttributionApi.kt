package com.eopeter.fluttermapboxnavigation.boundings.attribution.port

import android.content.Context
import com.eopeter.fluttermapboxnavigation.boundings.attribution.application.AttributionApiCodec
import com.eopeter.fluttermapboxnavigation.core.*
import com.mapbox.maps.MapView
import com.mapbox.maps.plugin.attribution.attribution
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec

class AttributionApi : MethodChannel.MethodCallHandler {
    private var methodChannel: MethodChannel? = null
    private val messenger: BinaryMessenger
    private val mapView: MapView
    private val context: Context
    private val viewId: Int

    constructor(messenger: BinaryMessenger, mapView: MapView, viewId: Int, context: Context) {
        this@AttributionApi.messenger = messenger
        this@AttributionApi.mapView = mapView
        this@AttributionApi.viewId = viewId
        this@AttributionApi.context = context
    }

    fun init() {
        this.methodChannel =
            MethodChannel(
                this.messenger,
                "flutter_mapbox_navigation/attribution/${this.viewId}",
                StandardMethodCodec(AttributionApiCodec)
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
        result.success(mapView.attribution.toFLT(context))
    }

    private fun updateSettings(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val settings = arguments["settings"] as? AttributionSettings ?: return
        mapView.attribution.applyFromFLT(settings, context)
        result.success(true)
    }
}