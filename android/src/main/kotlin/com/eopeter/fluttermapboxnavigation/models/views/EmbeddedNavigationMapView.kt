package com.eopeter.fluttermapboxnavigation.models.views

import android.app.Activity
import android.content.Context
import android.view.View
import com.eopeter.fluttermapboxnavigation.TurnByTurn
import com.eopeter.fluttermapboxnavigation.databinding.NavigationActivityBinding
import com.eopeter.fluttermapboxnavigation.models.MapBoxEvents
import com.eopeter.fluttermapboxnavigation.utilities.PluginUtilities
import com.eopeter.fluttermapboxnavigation.boundings.style.StyleApi
import com.mapbox.geojson.Point
import com.mapbox.maps.MapView
import com.mapbox.maps.plugin.gestures.OnMapClickListener
import com.mapbox.maps.plugin.gestures.gestures
import com.mapbox.navigation.dropin.map.MapViewObserver
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import org.json.JSONObject

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
    private var style: StyleApi? = null

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

        if((this.arguments?.get("enableOnMapTapCallback") as Boolean)) {
            this.binding.navigationView.registerMapObserver(mapViewObserver)
        }
    }

    override fun getView(): View {
        return binding.root
    }

    override fun dispose() {
        if((this.arguments?.get("enableOnMapTapCallback") as Boolean)) {
            this.binding.navigationView.unregisterMapObserver(mapViewObserver)
        }
        unregisterObservers()
    }

    /**
     * Notifies with attach and detach events on [MapView]
     */
    private val mapViewObserver = object : MapViewObserver(), OnMapClickListener {

        override fun onAttached(mapView: MapView) {
            super.onAttached(mapView)
            mapView.gestures.addOnMapClickListener(this)
            this@EmbeddedNavigationMapView.style = StyleApi(this@EmbeddedNavigationMapView.messenger, mapView.mapboxMap, this@EmbeddedNavigationMapView.viewId)
            this@EmbeddedNavigationMapView.mapView = mapView
        }

        override fun onDetached(mapView: MapView) {
            super.onDetached(mapView)
            mapView.gestures.removeOnMapClickListener(this)
            this@EmbeddedNavigationMapView.style = null
            this@EmbeddedNavigationMapView.mapView = null
        }

        override fun onMapClick(point: Point): Boolean {
            var waypoint = mapOf<String, String>(
                Pair("latitude", point.latitude().toString()),
                Pair("longitude", point.longitude().toString())
            )
            PluginUtilities.sendEvent(MapBoxEvents.ON_MAP_TAP, JSONObject(waypoint).toString())
            return false
        }
    }

}
