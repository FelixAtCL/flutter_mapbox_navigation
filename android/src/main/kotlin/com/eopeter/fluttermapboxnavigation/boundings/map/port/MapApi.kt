package com.eopeter.fluttermapboxnavigation.boundings.map.port

import android.content.Context
import com.mapbox.maps.extension.observable.*
import com.eopeter.fluttermapboxnavigation.boundings.map.application.MapApiCodec
import com.eopeter.fluttermapboxnavigation.core.*
import com.mapbox.geojson.Point
import com.mapbox.maps.MapboxMap
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec

class MapApi :
    MethodChannel.MethodCallHandler,
    EventChannel.StreamHandler
{
    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null
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
                "flutter_mapbox_navigation/map/${this.viewId}/events"
            )
        this.eventChannel?.setStreamHandler(this)
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            "pixelForCoordinate" -> {
                this.pixelForCoordinate(methodCall, result)
            }
            "queryRenderedFeatures" -> {
                this.queryRenderedFeatures(methodCall, result)
            }
            "queryListener" -> {
                result.success("listened")
            }
            else -> result.notImplemented()
        }
    }

    // Flutter stream listener delegate methods
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        this.eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        this.eventSink = null
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

    private fun listenOnEvents() {
        mapboxMap.subscribeMapLoaded {this.eventSink?.success(SubscriptionEvent.fromEvent(MapEvent.MAP_LOADED, it).toJsonString())}
        mapboxMap.subscribeMapLoadingError {this.eventSink?.success(SubscriptionEvent.fromEvent(MapEvent.MAP_LOADED, it).toJsonString())}
        mapboxMap.subscribeStyleLoaded {this.eventSink?.success(SubscriptionEvent.fromEvent(MapEvent.STYLE_LOADED, it).toJsonString())}
        mapboxMap.subscribeStyleDataLoaded {this.eventSink?.success(SubscriptionEvent.fromEvent(MapEvent.STYLE_DATA_LOADED, it).toJsonString())}
        mapboxMap.subscribeCameraChange {
            this.methodChannel?.invokeMethod("event", "received event")
            this.eventSink?.success(SubscriptionEvent.fromEvent(MapEvent.CAMERA_CHANGED, it).toJsonString())}
        mapboxMap.subscribeMapIdle {this.eventSink?.success(SubscriptionEvent.fromEvent(MapEvent.MAP_IDLE, it).toJsonString())}
        mapboxMap.subscribeSourceAdded {this.eventSink?.success(SubscriptionEvent.fromEvent(MapEvent.SOURCE_ADDED, it).toJsonString())}
        mapboxMap.subscribeSourceRemoved {this.eventSink?.success(SubscriptionEvent.fromEvent(MapEvent.SOURCE_REMOVED, it).toJsonString())}
        mapboxMap.subscribeSourceDataLoaded {this.eventSink?.success(SubscriptionEvent.fromEvent(MapEvent.SOURCE_DATA_LOADED, it).toJsonString())}
        mapboxMap.subscribeStyleImageMissing {this.eventSink?.success(SubscriptionEvent.fromEvent(MapEvent.STYLE_IMAGE_MISSING, it).toJsonString())}
        mapboxMap.subscribeStyleImageUnused {this.eventSink?.success(SubscriptionEvent.fromEvent(MapEvent.STYLE_IMAGE_REMOVE_UNUSED, it).toJsonString())}
        mapboxMap.subscribeRenderFrameStarted {this.eventSink?.success(SubscriptionEvent.fromEvent(MapEvent.RENDER_FRAME_STARTED, it).toJsonString())}
        mapboxMap.subscribeRenderFrameFinished {this.eventSink?.success(SubscriptionEvent.fromEvent(MapEvent.RENDER_FRAME_FINISHED, it).toJsonString())}
        mapboxMap.subscribeResourceRequest {this.eventSink?.success(SubscriptionEvent.fromEvent(MapEvent.RESOURCE_REQUEST, it).toJsonString())}
    }
}