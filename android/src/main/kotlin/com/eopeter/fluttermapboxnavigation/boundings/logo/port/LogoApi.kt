package com.eopeter.fluttermapboxnavigation.boundings.logo.port

import android.content.Context
import com.eopeter.fluttermapboxnavigation.boundings.logo.application.LogoApiCodec
import com.eopeter.fluttermapboxnavigation.core.*
import com.mapbox.maps.MapView
import com.mapbox.maps.plugin.logo.logo
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec

class LogoApi : MethodChannel.MethodCallHandler {
    private var methodChannel: MethodChannel? = null
    private val messenger: BinaryMessenger
    private val mapView: MapView
    private val context: Context
    private val viewId: Int

    constructor(messenger: BinaryMessenger, mapView: MapView, viewId: Int, context: Context) {
        this@LogoApi.messenger = messenger
        this@LogoApi.mapView = mapView
        this@LogoApi.viewId = viewId
        this@LogoApi.context = context
    }

    fun init() {
        this.methodChannel =
            MethodChannel(
                this.messenger,
                "flutter_mapbox_navigation/logo/${this.viewId}",
                StandardMethodCodec(LogoApiCodec)
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
        result.success(mapView.logo.toFLT(context))
    }

    private fun updateSettings(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val settings = arguments["settings"] as? LogoSettings ?: return
        mapView.logo.applyFromFLT(settings, context)
        result.success(null)
    }
}