package com.eopeter.fluttermapboxnavigation.boundings.map.port

import android.content.Context
import com.mapbox.maps.extension.observable.*
import com.eopeter.fluttermapboxnavigation.boundings.map.application.MapApiCodec
import com.eopeter.fluttermapboxnavigation.core.*
import com.google.gson.GsonBuilder
import com.mapbox.geojson.Point
import com.mapbox.maps.MapboxMap
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec

class MapApi : MethodChannel.MethodCallHandler {
    private var methodChannel: MethodChannel? = null
    private val messenger: BinaryMessenger
    private val mapboxMap: MapboxMap
    private val context: Context
    private val viewId: Int
    private val gson = GsonBuilder().create()

    constructor(messenger: BinaryMessenger, mapboxMap: MapboxMap, viewId: Int, context: Context) {
        this@MapApi.messenger = messenger
        this@MapApi.mapboxMap = mapboxMap
        this@MapApi.viewId = viewId
        this@MapApi.context = context
    }

    fun init() {
        val methodChannel =
            MethodChannel(
                this.messenger,
                "flutter_mapbox_navigation/map/${this.viewId}",
                StandardMethodCodec(MapApiCodec)
            )
        methodChannel.setMethodCallHandler(this)
        this.subscribeEvents(methodChannel)
        this.methodChannel = methodChannel
    }

    fun close() {
        if(this.methodChannel == null) return
        unsubscribeEvents(this.methodChannel)
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            "pixelForCoordinate" -> {
                this.pixelForCoordinate(methodCall, result)
            }
            "queryRenderedFeatures" -> {
                this.queryRenderedFeatures(methodCall, result)
            }
        }
    }

    private fun queryRenderedFeatures(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val geometry = arguments["geometry"] as? RenderedQueryGeometry ?: return
        val options = arguments["options"] as? RenderedQueryOptions ?: return
        mapboxMap.queryRenderedFeatures(
            geometry.toRenderedQueryGeometry(context),
            options.toRenderedQueryOptions()
        ) {
            if (it.isError) {
                result.success(it.error)
            } else {
                result.success(it.value!!.map { feature -> feature.toFLTQueriedFeature() }.toMutableList())
            }
        }
    }

    private fun pixelForCoordinate(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val latitude = arguments["latitude"] as? Double ?: return
        val longitude = arguments["longitude"] as? Double ?: return
        val point = Point.fromLngLat(longitude, latitude)
        val screenCoordinate = mapboxMap.pixelForCoordinate(point)
        result.success(screenCoordinate.toFLTScreenCoordinate(context))
    }

    private fun subscribeEvents(methodChannel: MethodChannel) {
        mapboxMap.addOnMapLoadedListener {methodChannel.invokeMethod(MapEvent.MAP_LOADED.methodName, gson.toJson(it))}
        mapboxMap.addOnStyleLoadedListener{methodChannel.invokeMethod(MapEvent.STYLE_LOADED.methodName, gson.toJson(it))}
        mapboxMap.addOnStyleDataLoadedListener {methodChannel.invokeMethod(MapEvent.STYLE_DATA_LOADED.methodName, gson.toJson(it))}
        mapboxMap.addOnCameraChangeListener {methodChannel.invokeMethod(MapEvent.CAMERA_CHANGED.methodName, gson.toJson(it))}
        mapboxMap.addOnMapIdleListener {methodChannel.invokeMethod(MapEvent.MAP_IDLE.methodName, gson.toJson(it))}
        mapboxMap.addOnSourceAddedListener {methodChannel.invokeMethod(MapEvent.SOURCE_ADDED.methodName, gson.toJson(it))}
        mapboxMap.addOnSourceRemovedListener {methodChannel.invokeMethod(MapEvent.SOURCE_REMOVED.methodName, gson.toJson(it))}
        mapboxMap.addOnSourceDataLoadedListener {methodChannel.invokeMethod(MapEvent.SOURCE_DATA_LOADED.methodName, gson.toJson(it))}
        mapboxMap.addOnStyleImageMissingListener {methodChannel.invokeMethod(MapEvent.STYLE_IMAGE_MISSING.methodName, gson.toJson(it))}
        mapboxMap.addOnStyleImageUnusedListener {methodChannel.invokeMethod(MapEvent.STYLE_IMAGE_REMOVE_UNUSED.methodName, gson.toJson(it))}
        mapboxMap.addOnRenderFrameStartedListener {methodChannel.invokeMethod(MapEvent.RENDER_FRAME_STARTED.methodName, gson.toJson(it))}
        mapboxMap.addOnRenderFrameFinishedListener {methodChannel.invokeMethod(MapEvent.RENDER_FRAME_FINISHED.methodName, gson.toJson(it))}
    }

    private fun unsubscribeEvents(methodChannel: MethodChannel) {
        mapboxMap.removeOnMapLoadedListener {methodChannel.invokeMethod(MapEvent.MAP_LOADED.methodName, gson.toJson(it))}
        mapboxMap.removeOnStyleLoadedListener{methodChannel.invokeMethod(MapEvent.STYLE_LOADED.methodName, gson.toJson(it))}
        mapboxMap.removeOnStyleDataLoadedListener {methodChannel.invokeMethod(MapEvent.STYLE_DATA_LOADED.methodName, gson.toJson(it))}
        mapboxMap.removeOnCameraChangeListener {methodChannel.invokeMethod(MapEvent.CAMERA_CHANGED.methodName, gson.toJson(it))}
        mapboxMap.removeOnMapIdleListener {methodChannel.invokeMethod(MapEvent.MAP_IDLE.methodName, gson.toJson(it))}
        mapboxMap.removeOnSourceAddedListener {methodChannel.invokeMethod(MapEvent.SOURCE_ADDED.methodName, gson.toJson(it))}
        mapboxMap.removeOnSourceRemovedListener {methodChannel.invokeMethod(MapEvent.SOURCE_REMOVED.methodName, gson.toJson(it))}
        mapboxMap.removeOnSourceDataLoadedListener {methodChannel.invokeMethod(MapEvent.SOURCE_DATA_LOADED.methodName, gson.toJson(it))}
        mapboxMap.removeOnStyleImageMissingListener {methodChannel.invokeMethod(MapEvent.STYLE_IMAGE_MISSING.methodName, gson.toJson(it))}
        mapboxMap.removeOnStyleImageUnusedListener {methodChannel.invokeMethod(MapEvent.STYLE_IMAGE_REMOVE_UNUSED.methodName, gson.toJson(it))}
        mapboxMap.removeOnRenderFrameStartedListener {methodChannel.invokeMethod(MapEvent.RENDER_FRAME_STARTED.methodName, gson.toJson(it))}
        mapboxMap.removeOnRenderFrameFinishedListener {methodChannel.invokeMethod(MapEvent.RENDER_FRAME_FINISHED.methodName, gson.toJson(it))}
    }
}