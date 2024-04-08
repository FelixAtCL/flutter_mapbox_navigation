package com.eopeter.fluttermapboxnavigation.boundings.scaleBar.port

import android.content.Context
import com.eopeter.fluttermapboxnavigation.boundings.scaleBar.application.ScaleBarApiCodec
import com.eopeter.fluttermapboxnavigation.core.*
import com.mapbox.maps.MapView
import com.mapbox.maps.plugin.scalebar.scalebar
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec

class ScaleBarApi : MethodChannel.MethodCallHandler {
    private var methodChannel: MethodChannel? = null
    private val messenger: BinaryMessenger
    private val mapView: MapView
    private val context: Context
    private val viewId: Int

    constructor(messenger: BinaryMessenger, mapView: MapView, viewId: Int, context: Context) {
        this@ScaleBarApi.messenger = messenger
        this@ScaleBarApi.mapView = mapView
        this@ScaleBarApi.viewId = viewId
        this@ScaleBarApi.context = context
    }

    fun init() {
        this.methodChannel =
            MethodChannel(
                this.messenger,
                "flutter_mapbox_navigation/scalebar/${this.viewId}",
                StandardMethodCodec(ScaleBarApiCodec)
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
        result.success(mapView.scalebar.toFLT(context))
    }

    private fun updateSettings(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val settings = arguments["settings"] as? ScaleBarSettings ?: return
        mapView.scalebar.applyFromFLT(settings, context)
        result.success(null)
    }
}