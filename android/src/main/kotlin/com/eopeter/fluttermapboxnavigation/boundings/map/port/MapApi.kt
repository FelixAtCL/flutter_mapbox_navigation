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
        this.listenOnEvents(methodChannel)
        this.methodChannel = methodChannel
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

    private fun listenOnEvents(methodChannel: MethodChannel) {
        mapboxMap.subscribeMapLoaded {methodChannel.invokeMethod(MapEvent.MAP_LOADED.methodName, gson.toJson(it))}
        mapboxMap.subscribeMapLoadingError {methodChannel.invokeMethod(MapEvent.MAP_LOADING_ERROR.methodName, gson.toJson(it))}
        mapboxMap.subscribeStyleLoaded {methodChannel.invokeMethod(MapEvent.STYLE_LOADED.methodName, gson.toJson(it))}
        mapboxMap.subscribeStyleDataLoaded {methodChannel.invokeMethod(MapEvent.STYLE_DATA_LOADED.methodName, gson.toJson(it))}
        mapboxMap.subscribeCameraChange {methodChannel.invokeMethod(MapEvent.CAMERA_CHANGED.methodName, gson.toJson(it))}
        mapboxMap.subscribeMapIdle {methodChannel.invokeMethod(MapEvent.MAP_IDLE.methodName, gson.toJson(it))}
        mapboxMap.subscribeSourceAdded {methodChannel.invokeMethod(MapEvent.SOURCE_ADDED.methodName, gson.toJson(it))}
        mapboxMap.subscribeSourceRemoved {methodChannel.invokeMethod(MapEvent.SOURCE_REMOVED.methodName, gson.toJson(it))}
        mapboxMap.subscribeSourceDataLoaded {methodChannel.invokeMethod(MapEvent.SOURCE_DATA_LOADED.methodName, gson.toJson(it))}
        mapboxMap.subscribeStyleImageMissing {methodChannel.invokeMethod(MapEvent.STYLE_IMAGE_MISSING.methodName, gson.toJson(it))}
        mapboxMap.subscribeStyleImageUnused {methodChannel.invokeMethod(MapEvent.STYLE_IMAGE_REMOVE_UNUSED.methodName, gson.toJson(it))}
        mapboxMap.subscribeRenderFrameStarted {methodChannel.invokeMethod(MapEvent.RENDER_FRAME_STARTED.methodName, gson.toJson(it))}
        mapboxMap.subscribeRenderFrameFinished {methodChannel.invokeMethod(MapEvent.RENDER_FRAME_FINISHED.methodName, gson.toJson(it))}
        mapboxMap.subscribeResourceRequest {methodChannel.invokeMethod(MapEvent.RESOURCE_REQUEST.methodName, gson.toJson(it))}
    }
}