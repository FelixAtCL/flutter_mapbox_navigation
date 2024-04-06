package com.eopeter.fluttermapboxnavigation.boundings.camera.port

import android.content.Context
import com.eopeter.fluttermapboxnavigation.boundings.camera.application.*
import com.eopeter.fluttermapboxnavigation.core.*
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.plugin.animation.Cancelable
import com.mapbox.maps.plugin.animation.easeTo
import com.mapbox.maps.plugin.animation.flyTo
import com.mapbox.maps.plugin.animation.moveBy
import com.mapbox.maps.plugin.animation.pitchBy
import com.mapbox.maps.plugin.animation.rotateBy
import com.mapbox.maps.plugin.animation.scaleBy
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec
import java.util.*

class CameraApi : MethodChannel.MethodCallHandler {
    private var methodChannel: MethodChannel? = null
    private val messenger: BinaryMessenger
    private val mapboxMap: MapboxMap
    private val context: Context
    private val viewId: Int
    private var cancelable: Cancelable? = null

    constructor(messenger: BinaryMessenger, mapboxMap: MapboxMap, viewId: Int, context: Context) {
        this@CameraApi.messenger = messenger
        this@CameraApi.mapboxMap = mapboxMap
        this@CameraApi.viewId = viewId
        this@CameraApi.context = context
    }

    fun init() {
        this.methodChannel =
                MethodChannel(
                        this.messenger,
                        "flutter_mapbox_navigation/camera/${this.viewId}",
                        StandardMethodCodec(CameraApiCodec)
                )
        this.methodChannel?.setMethodCallHandler(this)
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            "easeTo" -> {
                this.easeTo(methodCall, result)
            }
            "flyTo" -> {
                this.flyTo(methodCall, result)
            }
            "pitchBy" -> {
                this.pitchBy(methodCall, result)
            }
            "scaleBy" -> {
                this.scaleBy(methodCall, result)
            }
            "moveBy" -> {
                this.moveBy(methodCall, result)
            }
            "rotateBy" -> {
                this.rotateBy(methodCall, result)
            }
            "getState" -> {
                this.getState(methodCall, result)
            }
            "getCoordinateBounds" -> {
                this.getCoordinateBounds(methodCall, result)
            }
            "cancelCameraAnimation" -> {
                this.cancelCameraAnimation(methodCall, result)
            }
            else -> result.notImplemented()
        }
    }

    private fun easeTo(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val cameraOptions = arguments["cameraoptions"] as? CameraOptions ?: return
        val animationOptions = arguments["animationoptions"] as? MapAnimationOptions
        cancelable =
                mapboxMap.easeTo(
                        cameraOptions.toCameraOptions(context),
                        animationOptions?.toMapAnimationOptions()
                )
        result.success(null)
    }

    private fun flyTo(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val cameraOptions = arguments["cameraoptions"] as? CameraOptions ?: return
        val animationOptions = arguments["animationoptions"] as? MapAnimationOptions
        cancelable =
                mapboxMap.flyTo(
                        cameraOptions.toCameraOptions(context),
                        animationOptions?.toMapAnimationOptions()
                )
        result.success(null)
    }

    private fun pitchBy(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val pitch = arguments["pitch"] as? Double ?: return
        val animationOptions = arguments["animationoptions"] as? MapAnimationOptions
        cancelable = mapboxMap.pitchBy(pitch, animationOptions?.toMapAnimationOptions())
        result.success(null)
    }

    private fun scaleBy(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val amount = arguments["amount"] as? Double ?: return
        val coordinate = arguments["coordinate"] as? ScreenCoordinate
        val animationOptions = arguments["animationoptions"] as? MapAnimationOptions
        cancelable =
                mapboxMap.scaleBy(
                        amount,
                        coordinate?.toScreenCoordinate(context),
                        animationOptions?.toMapAnimationOptions()
                )
        result.success(null)
    }

    private fun moveBy(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val coordinate = arguments["coordinate"] as? ScreenCoordinate ?: return
        val animationOptions = arguments["animationoptions"] as? MapAnimationOptions
        cancelable =
                mapboxMap.moveBy(
                        coordinate.toScreenCoordinate(context),
                        animationOptions?.toMapAnimationOptions()
                )
        result.success(null)
    }

    private fun rotateBy(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val first = arguments["first"] as? ScreenCoordinate ?: return
        val second = arguments["second"] as? ScreenCoordinate ?: return
        val animationOptions = arguments["animationoptions"] as? MapAnimationOptions
        cancelable =
                mapboxMap.rotateBy(
                        first.toScreenCoordinate(context),
                        second.toScreenCoordinate(context),
                        animationOptions?.toMapAnimationOptions()
                )
        result.success(null)
    }

    private fun getState(methodCall: MethodCall, result: MethodChannel.Result) {
        result.success(mapboxMap.cameraState.toCameraState(context))
    }

    private fun getCoordinateBounds(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val camera = arguments["camera"] as? CameraOptions ?: return
        val coordinateBounds = mapboxMap.coordinateBoundsForCamera(camera.toCameraOptions(context))
        result.success(coordinateBounds.toFLTCoordinateBounds())
    }

    private fun cancelCameraAnimation(methodCall: MethodCall, result: MethodChannel.Result) {
        cancelable?.cancel()
        result.success(null)
    }
}
