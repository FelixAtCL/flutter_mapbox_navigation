package com.eopeter.fluttermapboxnavigation.boundings.map.port

import android.content.Context
import com.mapbox.maps.extension.observable.*
import com.eopeter.fluttermapboxnavigation.boundings.map.application.MapApiCodec
import com.eopeter.fluttermapboxnavigation.core.*
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
        mapboxMap.subscribeMapLoaded {methodChannel.invokeMethod(MapEvent.MAP_LOADED.methodName, it.data.toFLTValue())}
        mapboxMap.subscribeMapLoadingError {methodChannel.invokeMethod(MapEvent.MAP_LOADING_ERROR.methodName, it.data.toFLTValue())}
        mapboxMap.subscribeStyleLoaded {methodChannel.invokeMethod(MapEvent.STYLE_LOADED.methodName, it.data.toFLTValue())}
        mapboxMap.subscribeStyleDataLoaded {methodChannel.invokeMethod(MapEvent.STYLE_DATA_LOADED.methodName, it.data.toFLTValue())}
        mapboxMap.subscribeCameraChange {methodChannel.invokeMethod(MapEvent.CAMERA_CHANGED.methodName, it.data.toFLTValue())}
        mapboxMap.subscribeMapIdle {methodChannel.invokeMethod(MapEvent.MAP_IDLE.methodName, it.data.toFLTValue())}
        mapboxMap.subscribeSourceAdded {methodChannel.invokeMethod(MapEvent.SOURCE_ADDED.methodName, it.data.toFLTValue())}
        mapboxMap.subscribeSourceRemoved {methodChannel.invokeMethod(MapEvent.SOURCE_REMOVED.methodName, it.data.toFLTValue())}
        mapboxMap.subscribeSourceDataLoaded {methodChannel.invokeMethod(MapEvent.SOURCE_DATA_LOADED.methodName, it.data.toFLTValue())}
        mapboxMap.subscribeStyleImageMissing {methodChannel.invokeMethod(MapEvent.STYLE_IMAGE_MISSING.methodName, it.data.toFLTValue())}
        mapboxMap.subscribeStyleImageUnused {methodChannel.invokeMethod(MapEvent.STYLE_IMAGE_REMOVE_UNUSED.methodName, it.data.toFLTValue())}
        mapboxMap.subscribeRenderFrameStarted {methodChannel.invokeMethod(MapEvent.RENDER_FRAME_STARTED.methodName, it.data.toFLTValue())}
        mapboxMap.subscribeRenderFrameFinished {methodChannel.invokeMethod(MapEvent.RENDER_FRAME_FINISHED.methodName, it.data.toFLTValue())}
        mapboxMap.subscribeResourceRequest {methodChannel.invokeMethod(MapEvent.RESOURCE_REQUEST.methodName, it.data.toFLTValue())}
    }
}