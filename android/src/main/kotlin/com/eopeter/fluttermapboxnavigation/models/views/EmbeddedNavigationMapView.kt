package com.eopeter.fluttermapboxnavigation.models.views

import android.app.Activity
import android.content.Context
import android.view.View
import com.eopeter.fluttermapboxnavigation.TurnByTurn
import com.eopeter.fluttermapboxnavigation.boundings.attribution.port.AttributionApi
import com.eopeter.fluttermapboxnavigation.databinding.NavigationActivityBinding
import com.eopeter.fluttermapboxnavigation.boundings.style.port.StyleApi
import com.eopeter.fluttermapboxnavigation.boundings.camera.port.CameraApi
import com.eopeter.fluttermapboxnavigation.boundings.gesture.port.GestureApi
import com.eopeter.fluttermapboxnavigation.boundings.map.port.MapApi
import com.mapbox.maps.MapView
import com.mapbox.maps.MapboxMap
import com.mapbox.navigation.dropin.map.MapViewObserver
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class EmbeddedNavigationMapView(
    context: Context,
    activity: Activity,
    binding: NavigationActivityBinding,
    binaryMessenger: BinaryMessenger,
    vId: Int,
    args: Any?,
    accessToken: String
) : PlatformView, TurnByTurn(context, activity, binding, accessToken) {
    private val viewId: Int = vId
    private val messenger: BinaryMessenger = binaryMessenger
    private val arguments = args as Map<*, *>
    private var mapView: MapView? = null
    private var mapboxMap: MapboxMap? = null
    private var attribution: AttributionApi? = null
    private var camera: CameraApi? = null
    private var gesture: GestureApi? = null
    private var map: MapApi? = null
    private var style: StyleApi? = null
    private var enableOnMapTapCallback: Boolean = false

    override fun initFlutterChannelHandlers() {
        methodChannel = MethodChannel(messenger, "flutter_mapbox_navigation/${viewId}")
        eventChannel = EventChannel(messenger, "flutter_mapbox_navigation/${viewId}/events")
        super.initFlutterChannelHandlers()
    }

    open fun initialize() {
        initFlutterChannelHandlers()
        initNavigation()

        if(!(this.arguments?.get("longPressDestinationEnabled") as Boolean)) {
            this.binding.navigationView.customizeViewOptions {
                enableMapLongClickIntercept = false;
            }
        }

        var enableOMTC = this.arguments?.get("enableOnMapTapCallback") as? Boolean
        if(enableOMTC != null) {
            this.enableOnMapTapCallback = enableOMTC
        }
        this.binding.navigationView.registerMapObserver(mapViewObserver)
    }

    override fun getView(): View {
        return binding.root
    }

    override fun dispose() {
        this.binding.navigationView.unregisterMapObserver(mapViewObserver)
        unregisterObservers()
    }

    /**
     * Notifies with attach and detach events on [MapView]
     */
    private val mapViewObserver = object : MapViewObserver() {
        override fun onAttached(mapView: MapView) {
            super.onAttached(mapView)
            this@EmbeddedNavigationMapView.mapView = mapView
            this@EmbeddedNavigationMapView.mapboxMap = mapView.getMapboxMap()
            enableApis(mapView)
        }

        override fun onDetached(mapView: MapView) {
            super.onDetached(mapView)
            this@EmbeddedNavigationMapView.mapView = null
            this@EmbeddedNavigationMapView.mapboxMap = null
            disableApis()
        }

        fun enableApis(mapView: MapView) {
            val attribution = AttributionApi(
                this@EmbeddedNavigationMapView.messenger,
                mapView,
                this@EmbeddedNavigationMapView.viewId,
                this@EmbeddedNavigationMapView.context
            )
            attribution.init()
            this@EmbeddedNavigationMapView.attribution = attribution

            val camera = CameraApi(
                this@EmbeddedNavigationMapView.messenger,
                mapView.getMapboxMap(),
                this@EmbeddedNavigationMapView.viewId,
                this@EmbeddedNavigationMapView.context
            )
            camera.init()
            this@EmbeddedNavigationMapView.camera = camera

            val gesture = GestureApi(
                this@EmbeddedNavigationMapView.messenger,
                mapView,
                this@EmbeddedNavigationMapView.viewId,
                this@EmbeddedNavigationMapView.context
            )
            gesture.init()
            this@EmbeddedNavigationMapView.gesture = gesture

            val map = MapApi(
                this@EmbeddedNavigationMapView.messenger,
                mapView.getMapboxMap(),
                this@EmbeddedNavigationMapView.viewId,
                this@EmbeddedNavigationMapView.context
            )
            map.init()
            this@EmbeddedNavigationMapView.map = map

            val style =  StyleApi(
                this@EmbeddedNavigationMapView.messenger,
                mapView.getMapboxMap(),
                this@EmbeddedNavigationMapView.viewId,
                this@EmbeddedNavigationMapView.context
            )
            style.init()
            this@EmbeddedNavigationMapView.style = style
        }

        fun disableApis() {
            this@EmbeddedNavigationMapView.gesture?.close()

            this@EmbeddedNavigationMapView.attribution = null
            this@EmbeddedNavigationMapView.camera = null
            this@EmbeddedNavigationMapView.gesture = null
            this@EmbeddedNavigationMapView.map = null
            this@EmbeddedNavigationMapView.style = null
        }
    }

}
