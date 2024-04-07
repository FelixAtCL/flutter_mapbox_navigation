package com.eopeter.fluttermapboxnavigation.boundings.gesture.port

import android.content.Context
import com.eopeter.fluttermapboxnavigation.boundings.gesture.application.GestureApiCodec
import com.eopeter.fluttermapboxnavigation.core.*
import com.mapbox.android.gestures.MoveGestureDetector
import com.mapbox.geojson.Point
import com.mapbox.maps.MapView
import com.mapbox.maps.plugin.gestures.OnMapClickListener
import com.mapbox.maps.plugin.gestures.OnMapLongClickListener
import com.mapbox.maps.plugin.gestures.OnMoveListener
import com.mapbox.maps.plugin.gestures.gestures
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec

class GestureApi: MethodChannel.MethodCallHandler, OnMapClickListener, OnMapLongClickListener, OnMoveListener {
    private var methodChannel: MethodChannel? = null
    private val messenger: BinaryMessenger
    private val mapView: MapView
    private val context: Context
    private val viewId: Int

    constructor(messenger: BinaryMessenger, mapView: MapView, viewId: Int, context: Context) {
        this@GestureApi.messenger = messenger
        this@GestureApi.mapView = mapView
        this@GestureApi.viewId = viewId
        this@GestureApi.context = context
    }

    fun init() {
        this.methodChannel =
            MethodChannel(
                this.messenger,
                "flutter_mapbox_navigation/gestures/${this.viewId}",
                StandardMethodCodec(GestureApiCodec)
            )
        this.methodChannel?.setMethodCallHandler(this)
        this.mapView.gestures.addOnMapClickListener(this)
        this.mapView.gestures.addOnMapLongClickListener(this)
    }

    fun close() {
        this.mapView.gestures.removeOnMapClickListener(this)
        this.mapView.gestures.removeOnMapLongClickListener(this)
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            else -> result.notImplemented()
        }
    }

    override fun onMapClick(point: Point): Boolean {
        this.methodChannel?.invokeMethod("onTapMap", point.toFLTScreenCoordinate())
        return false
    }

    override fun onMapLongClick(point: Point): Boolean {
        this.methodChannel?.invokeMethod("onLongTapMap", point.toFLTScreenCoordinate())
        return false
    }

    override fun onMove(detector: MoveGestureDetector): Boolean {
        val coordinate = mapView.getMapboxMap().coordinateForPixel(
                com.mapbox.maps.ScreenCoordinate(detector.currentEvent.x.toDouble(), detector.currentEvent.y.toDouble())
            ).toFLTScreenCoordinate()
        this.methodChannel?.invokeMethod("onScrollMap", coordinate)
        return false
    }

    override fun onMoveBegin(detector: MoveGestureDetector) {
        TODO("Not yet implemented")
    }

    override fun onMoveEnd(detector: MoveGestureDetector) {
        TODO("Not yet implemented")
    }
}