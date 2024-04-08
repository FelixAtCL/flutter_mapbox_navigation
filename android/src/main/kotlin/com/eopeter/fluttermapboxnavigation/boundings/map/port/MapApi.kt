package com.eopeter.fluttermapboxnavigation.boundings.map.port

import android.content.Context
import com.eopeter.fluttermapboxnavigation.boundings.map.application.MapApiCodec
import com.eopeter.fluttermapboxnavigation.core.*
import com.mapbox.geojson.Point
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.extension.observable.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.StandardMethodCodec

class MapApi : MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private var methodChannel: MethodChannel? = null
    private val messenger: BinaryMessenger
    private val mapboxMap: MapboxMap
    private val context: Context
    private val viewId: Int
    private var eventChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null

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

        this.eventChannel =
            EventChannel(
                this.messenger,
                "flutter_mapbox_navigation/map/${viewId}/events"
            )
        this.eventChannel?.setStreamHandler(this)
    }

    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
        this.eventSink = eventSink
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        eventChannel = null
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            "addEventListener" -> {
                this.addEventListener(methodCall, result)
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

    private fun addEventListener(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val event = arguments["event"] as? String ?: return
        val mapEvent = MapEvent.ofName(event) ?: return
        when (mapEvent) {
            MapEvent.MAP_LOADED -> mapboxMap.subscribeMapLoaded {
                eventSink?.success(Event(mapEvent.methodName, it.toJson()))
            }
            MapEvent.MAP_LOADING_ERROR -> mapboxMap.subscribeMapLoadingError {
                eventSink?.success(Event(mapEvent.methodName, it.toJson()))
            }
            MapEvent.STYLE_LOADED -> mapboxMap.subscribeStyleLoaded {
                eventSink?.success(Event(mapEvent.methodName, it.toJson()))
            }
            MapEvent.STYLE_DATA_LOADED -> mapboxMap.subscribeStyleDataLoaded {
                eventSink?.success(Event(mapEvent.methodName, it.toJson()))
            }
            MapEvent.CAMERA_CHANGED -> mapboxMap.subscribeCameraChange {
                eventSink?.success(Event(mapEvent.methodName, it.toJson()))
            }
            MapEvent.MAP_IDLE -> mapboxMap.subscribeMapIdle {
                eventSink?.success(Event(mapEvent.methodName, it.toJson()))
            }
            MapEvent.SOURCE_ADDED -> mapboxMap.subscribeSourceAdded {
                eventSink?.success(Event(mapEvent.methodName, it.toJson()))
            }
            MapEvent.SOURCE_REMOVED -> mapboxMap.subscribeSourceRemoved {
                eventSink?.success(Event(mapEvent.methodName, it.toJson()))
            }
            MapEvent.SOURCE_DATA_LOADED -> mapboxMap.subscribeSourceDataLoaded {
                eventSink?.success(Event(mapEvent.methodName, it.toJson()))
            }
            MapEvent.STYLE_IMAGE_MISSING -> mapboxMap.subscribeStyleImageMissing {
                eventSink?.success(Event(mapEvent.methodName, it.toJson()))
            }
            MapEvent.STYLE_IMAGE_REMOVE_UNUSED -> mapboxMap.subscribeStyleImageUnused {
                eventSink?.success(Event(mapEvent.methodName, it.toJson()))
            }
            MapEvent.RENDER_FRAME_STARTED -> mapboxMap.subscribeRenderFrameStarted {
                eventSink?.success(Event(mapEvent.methodName, it.toJson()))
            }
            MapEvent.RENDER_FRAME_FINISHED -> mapboxMap.subscribeRenderFrameFinished {
                eventSink?.success(Event(mapEvent.methodName, it.toJson()))
            }
            MapEvent.RESOURCE_REQUEST -> mapboxMap.subscribeResourceRequest {
                eventSink?.success(Event(mapEvent.methodName, it.toJson()))
            }
        }
        result.success(null)
    }
}