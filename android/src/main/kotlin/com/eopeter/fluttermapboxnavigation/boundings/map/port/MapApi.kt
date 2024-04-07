package com.eopeter.fluttermapboxnavigation.boundings.map.port

import android.content.Context
import com.eopeter.fluttermapboxnavigation.boundings.map.application.MapApiCodec
import com.eopeter.fluttermapboxnavigation.core.*
import com.google.gson.GsonBuilder
import com.mapbox.geojson.Point
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.extension.observable.*
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
        this.methodChannel =
            MethodChannel(
                this.messenger,
                "flutter_mapbox_navigation/map/${this.viewId}",
                StandardMethodCodec(MapApiCodec)
            )
        this.methodChannel?.setMethodCallHandler(this)
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            "subscribe" -> {
                this.subscribe(methodCall, result)
            }
            "pixelForCoordinate" -> {
                this.pixelForCoordinate(methodCall, result)
            }
            "queryRenderedFeatures" -> {
                this.queryRenderedFeatures(methodCall, result)
            }
            else -> result.notImplemented()
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

    private fun subscribe(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val event = arguments["event"] as? String ?: return
        val mapEvent = MapEvent.ofName(event) ?: return
        when (mapEvent) {
            MapEvent.MAP_LOADED -> mapboxMap.subscribeMapLoaded {
                methodChannel?.invokeMethod(mapEvent.methodName, gson.toJson(it))
            }
            MapEvent.MAP_LOADING_ERROR -> mapboxMap.subscribeMapLoadingError {
                methodChannel?.invokeMethod(mapEvent.methodName, gson.toJson(it))
            }
            MapEvent.STYLE_LOADED -> mapboxMap.subscribeStyleLoaded {
                methodChannel?.invokeMethod(mapEvent.methodName, gson.toJson(it))
            }
            MapEvent.STYLE_DATA_LOADED -> mapboxMap.subscribeStyleDataLoaded {
                methodChannel?.invokeMethod(mapEvent.methodName, gson.toJson(it))
            }
            MapEvent.CAMERA_CHANGED -> mapboxMap.subscribeCameraChange {
                methodChannel?.invokeMethod(mapEvent.methodName, gson.toJson(it))
            }
            MapEvent.MAP_IDLE -> mapboxMap.subscribeMapIdle {
                methodChannel?.invokeMethod(mapEvent.methodName, gson.toJson(it))
            }
            MapEvent.SOURCE_ADDED -> mapboxMap.subscribeSourceAdded {
                methodChannel?.invokeMethod(mapEvent.methodName, gson.toJson(it))
            }
            MapEvent.SOURCE_REMOVED -> mapboxMap.subscribeSourceRemoved {
                methodChannel?.invokeMethod(mapEvent.methodName, gson.toJson(it))
            }
            MapEvent.SOURCE_DATA_LOADED -> mapboxMap.subscribeSourceDataLoaded {
                methodChannel?.invokeMethod(mapEvent.methodName, gson.toJson(it))
            }
            MapEvent.STYLE_IMAGE_MISSING -> mapboxMap.subscribeStyleImageMissing {
                methodChannel?.invokeMethod(mapEvent.methodName, gson.toJson(it))
            }
            MapEvent.STYLE_IMAGE_REMOVE_UNUSED -> mapboxMap.subscribeStyleImageUnused {
                methodChannel?.invokeMethod(mapEvent.methodName, gson.toJson(it))
            }
            MapEvent.RENDER_FRAME_STARTED -> mapboxMap.subscribeRenderFrameStarted {
                methodChannel?.invokeMethod(mapEvent.methodName, gson.toJson(it))
            }
            MapEvent.RENDER_FRAME_FINISHED -> mapboxMap.subscribeRenderFrameFinished {
                methodChannel?.invokeMethod(mapEvent.methodName, gson.toJson(it))
            }
            MapEvent.RESOURCE_REQUEST -> mapboxMap.subscribeResourceRequest {
                methodChannel?.invokeMethod(mapEvent.methodName, gson.toJson(it))
            }
        }
        result.success(null)
    }
}