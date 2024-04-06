package com.eopeter.fluttermapboxnavigation.boundings.camera.port

import android.content.Context
import com.eopeter.fluttermapboxnavigation.boundings.camera.application.*
import com.mapbox.maps.MapboxMap
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

class CameraApi : MethodChannel.MethodCallHandler {
    private var methodChannel: MethodChannel? = null
    private val messenger: BinaryMessenger
    private val mapboxMap: MapboxMap
    private val context: Context
    private val viewId: Int

    constructor(messenger: BinaryMessenger, mapboxMap: MapboxMap, viewId: Int, context: Context) {
        this@CameraApi.messenger = messenger
        this@CameraApi.mapboxMap = mapboxMap
        this@CameraApi.viewId = viewId
        this@CameraApi.context = context
    }

    fun init() {
        this.methodChannel = MethodChannel(this.messenger, "flutter_mapbox_navigation/camera/${this.viewId}", StandardMethodCodec(CameraApiCodec))
        this.methodChannel?.setMethodCallHandler(this)
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            "getState" -> {
                this.getState(methodCall, result)
            }
            else -> result.notImplemented()
        }
    }

    private fun getState(methodCall: MethodCall, result: MethodChannel.Result) {
        result.success(mapboxMap.cameraState.toCameraState(context))
    }
}
