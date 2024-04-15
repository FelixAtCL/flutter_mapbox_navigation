package com.eopeter.fluttermapboxnavigation.boundings.navigation.port

import android.Manifest
import android.app.Activity
import android.app.Application
import android.content.Context
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.app.ActivityCompat
import androidx.transition.Fade
import androidx.transition.Scene
import androidx.transition.TransitionManager
import com.eopeter.fluttermapboxnavigation.R
import com.eopeter.fluttermapboxnavigation.activity.NavigationLauncher
import com.eopeter.fluttermapboxnavigation.core.*
import com.eopeter.fluttermapboxnavigation.databinding.EmptyTripProgressBinding
import com.eopeter.fluttermapboxnavigation.databinding.NavigationActivityBinding
import com.eopeter.fluttermapboxnavigation.models.MapBoxEvents
import com.eopeter.fluttermapboxnavigation.models.Waypoint
import com.eopeter.fluttermapboxnavigation.models.WaypointSet
import com.eopeter.fluttermapboxnavigation.utilities.CustomInfoPanelEndNavButtonBinder
import com.google.android.material.navigation.NavigationView
import com.google.gson.Gson
import com.mapbox.api.directions.v5.DirectionsCriteria
import com.mapbox.api.directions.v5.models.RouteOptions
import com.mapbox.geojson.Point
import com.mapbox.maps.Style
import com.mapbox.navigation.base.ExperimentalPreviewMapboxNavigationAPI
import com.mapbox.navigation.base.extensions.applyDefaultNavigationOptions
import com.mapbox.navigation.base.extensions.applyLanguageAndVoiceUnitOptions
import com.mapbox.navigation.base.route.NavigationRoute
import com.mapbox.navigation.base.route.NavigationRouterCallback
import com.mapbox.navigation.base.route.RouterFailure
import com.mapbox.navigation.base.route.RouterOrigin
import com.mapbox.navigation.core.lifecycle.MapboxNavigationApp
import com.mapbox.navigation.core.lifecycle.MapboxNavigationObserver
import com.mapbox.navigation.dropin.infopanel.InfoPanelBinder
import com.mapbox.navigation.ui.base.lifecycle.UIBinder
import com.mapbox.navigation.ui.base.lifecycle.UIComponent
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import java.util.HashMap

class NavigationApi:
    MethodChannel.MethodCallHandler,
    EventChannel.StreamHandler,
    Application.ActivityLifecycleCallbacks
{
    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null
    private val messenger: BinaryMessenger
    private val context: Context
    private val viewId: Int
    private val binding: NavigationActivityBinding
    private val activity: Activity

    private var currentRoutes: List<NavigationRoute>? = null
    /**
     * Helper class that keeps added waypoints and transforms them to the [RouteOptions] params.
     */
    private val addedWaypoints = WaypointSet()
    private var isNavigationCanceled = false
    private var simulateRoute = false
    private var navigationMode = DirectionsCriteria.PROFILE_DRIVING_TRAFFIC
    private var navigationLanguage = "en"
    private var navigationVoiceUnits = DirectionsCriteria.IMPERIAL
    private var voiceInstructionsEnabled = true
    private var bannerInstructionsEnabled = true
    private var alternatives = true
    private var animateBuildRoute = true
    private var isOptimized = false
    private var zoom = 15.0
    private var bearing = 0.0
    private var tilt = 0.0
    private var mapStyleUrlDay: String? = null
    private var mapStyleUrlNight: String? = null
    private var initialLatitude: Double? = null
    private var initialLongitude: Double? = null
    private var disableInfoPanel: Boolean = false
    private var disableTripProgress: Boolean = false

    constructor(
        messenger: BinaryMessenger,
        binding: NavigationActivityBinding,
        viewId: Int,
        context: Context,
        activity: Activity) {
        this@NavigationApi.messenger = messenger
        this@NavigationApi.viewId = viewId
        this@NavigationApi.context = context
        this@NavigationApi.binding = binding
        this@NavigationApi.activity = activity
    }

    fun init() {
        this.methodChannel =
            MethodChannel(
                this.messenger,
                "flutter_mapbox_navigation/navigation/${this.viewId}"
            )
        this.methodChannel?.setMethodCallHandler(this)

        eventChannel =
            EventChannel(
                this.messenger,
                "flutter_mapbox_navigation/navigation/${viewId}/events"
            )
        this.eventChannel?.setStreamHandler(this)
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            "setUp" -> {
                this.setUp(methodCall, result)
            }
            "build" -> {
                this.build(methodCall, result)
            }
            "start" -> {
                this.start(methodCall, result)
            }
            "finish" -> {
                this.finish(methodCall, result)
            }
            "clear" -> {
                this.clear(methodCall, result)
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

    private fun setUp(methodCall: MethodCall, result: MethodChannel.Result) {
        var arguments = methodCall.arguments as? Map<*,*> ?: return
        disableInfoPanel = arguments["disableInfoPanel"] as? Boolean ?: false
        disableTripProgress = arguments["disableTripProgress"] as? Boolean ?: false
        result.success(null)
    }

    private fun build(methodCall: MethodCall, result: MethodChannel.Result) {
        this.isNavigationCanceled = false

        val arguments = methodCall.arguments as? Map<*, *>
        if (arguments != null) this.setOptions(arguments)
        this.addedWaypoints.clear()
        val points = arguments?.get("wayPoints") as HashMap<*, *>
        for (item in points) {
            val point = item.value as HashMap<*, *>
            val latitude = point["Latitude"] as Double
            val longitude = point["Longitude"] as Double
            val isSilent = point["IsSilent"] as Boolean
            this.addedWaypoints.add(Waypoint(Point.fromLngLat(longitude, latitude),isSilent))
        }
        this.getRoute(this.context)
        result.success(null)
    }

    private fun start(methodCall: MethodCall, result: MethodChannel.Result) {
        if(this.currentRoutes == null) {
            sendEvent(MapBoxEvents.NAVIGATION_CANCELLED)
            result.success("No route initialized!")
            return
        }
        if (ActivityCompat.checkSelfPermission(
                this.context,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                this.context,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            result.success("No permissions for location!")
            return
        }
        MapboxNavigationApp.current()!!.startTripSession()
        this.isNavigationCanceled = false
        sendEvent(MapBoxEvents.NAVIGATION_RUNNING)
        result.success(null)
    }

    private fun finish(methodCall: MethodCall, result: MethodChannel.Result) {
        MapboxNavigationApp.current()!!.stopTripSession()
        sendEvent(MapBoxEvents.NAVIGATION_CANCELLED)
        this.isNavigationCanceled = true
        result.success(null)
    }

    private fun clear(methodCall: MethodCall, result: MethodChannel.Result) {
        this.currentRoutes = null
        MapboxNavigationApp.current()!!.stopTripSession()
        this.binding.navigationView.removeAllViews()
        sendEvent(MapBoxEvents.NAVIGATION_CANCELLED)
        this.isNavigationCanceled = true
        result.success(null)
    }

    @OptIn(ExperimentalPreviewMapboxNavigationAPI::class)
    private fun getRoute(context: Context) {
        MapboxNavigationApp.current()!!.requestRoutes(
            routeOptions = RouteOptions
                .builder()
                .applyDefaultNavigationOptions(navigationMode)
                .applyLanguageAndVoiceUnitOptions(context)
                .coordinatesList(this.addedWaypoints.coordinatesList())
                .waypointIndicesList(this.addedWaypoints.waypointsIndices())
                .waypointNamesList(this.addedWaypoints.waypointsNames())
                .language(navigationLanguage)
                .alternatives(alternatives)
                .steps(true)
                .voiceUnits(navigationVoiceUnits)
                .bannerInstructions(bannerInstructionsEnabled)
                .voiceInstructions(voiceInstructionsEnabled)
                .build(),
            callback = object : NavigationRouterCallback {
                override fun onRoutesReady(
                    routes: List<NavigationRoute>,
                    routerOrigin: RouterOrigin
                ) {
                    MapboxNavigationApp.current()!!.setRoutesPreview(routes)
                    this@NavigationApi.currentRoutes = routes
                    sendEvent(
                        MapBoxEvents.ROUTE_BUILT,
                        Gson().toJson(routes.map { it.directionsRoute.toJson() })
                    )
                    this@NavigationApi.binding.navigationView.api.routeReplayEnabled(
                        this@NavigationApi.simulateRoute
                    )

                    this@NavigationApi.binding.navigationView.customizeViewBinders {
                        if(disableInfoPanel) {
                            infoPanelBinder = EmptyInfoPanelBinder()
                        }
                        if(disableTripProgress) {
                            infoPanelTripProgressBinder = EmptyTripProgressBinder()
                        }
                        this.infoPanelEndNavigationButtonBinder =
                            CustomInfoPanelEndNavButtonBinder(activity)
                    }
                }

                override fun onFailure(
                    reasons: List<RouterFailure>,
                    routeOptions: RouteOptions
                ) {
                    sendEvent(MapBoxEvents.ROUTE_BUILD_FAILED)
                }

                override fun onCanceled(
                    routeOptions: RouteOptions,
                    routerOrigin: RouterOrigin
                ) {
                    sendEvent(MapBoxEvents.ROUTE_BUILD_CANCELLED)
                }
            }
        )
    }

    private fun setOptions(arguments: Map<*, *>) {
        val navMode = arguments["mode"] as? String
        if (navMode != null) {
            when (navMode) {
                "walking" -> this.navigationMode = DirectionsCriteria.PROFILE_WALKING
                "cycling" -> this.navigationMode = DirectionsCriteria.PROFILE_CYCLING
                "driving" -> this.navigationMode = DirectionsCriteria.PROFILE_DRIVING
            }
        }

        val simulated = arguments["simulateRoute"] as? Boolean
        if (simulated != null) {
            this.simulateRoute = simulated
        }

        val language = arguments["language"] as? String
        if (language != null) {
            this.navigationLanguage = language
        }

        val units = arguments["units"] as? String

        if (units != null) {
            if (units == "imperial") {
                this.navigationVoiceUnits = DirectionsCriteria.IMPERIAL
            } else if (units == "metric") {
                this.navigationVoiceUnits = DirectionsCriteria.METRIC
            }
        }

        this.mapStyleUrlDay = arguments["mapStyleUrlDay"] as? String
        this.mapStyleUrlNight = arguments["mapStyleUrlNight"] as? String

        //Set the style Uri
        if (this.mapStyleUrlDay == null) this.mapStyleUrlDay = Style.MAPBOX_STREETS
        if (this.mapStyleUrlNight == null) this.mapStyleUrlNight = Style.DARK

        this@NavigationApi.binding.navigationView.customizeViewOptions {
            mapStyleUriDay = this@NavigationApi.mapStyleUrlDay
            mapStyleUriNight = this@NavigationApi.mapStyleUrlNight
        }

        this.initialLatitude = arguments["initialLatitude"] as? Double
        this.initialLongitude = arguments["initialLongitude"] as? Double

        val zm = arguments["zoom"] as? Double
        if (zm != null) {
            this.zoom = zm
        }

        val br = arguments["bearing"] as? Double
        if (br != null) {
            this.bearing = br
        }

        val tt = arguments["tilt"] as? Double
        if (tt != null) {
            this.tilt = tt
        }

        val optim = arguments["isOptimized"] as? Boolean
        if (optim != null) {
            this.isOptimized = optim
        }

        val anim = arguments["animateBuildRoute"] as? Boolean
        if (anim != null) {
            this.animateBuildRoute = anim
        }

        val altRoute = arguments["alternatives"] as? Boolean
        if (altRoute != null) {
            this.alternatives = altRoute
        }

        val voiceEnabled = arguments["voiceInstructionsEnabled"] as? Boolean
        if (voiceEnabled != null) {
            this.voiceInstructionsEnabled = voiceEnabled
        }

        val bannerEnabled = arguments["bannerInstructionsEnabled"] as? Boolean
        if (bannerEnabled != null) {
            this.bannerInstructionsEnabled = bannerEnabled
        }
    }

    private fun sendEvent(event: MapBoxEvents, data: String = "") {
        val jsonString =
            if (MapBoxEvents.MILESTONE_EVENT == event || event == MapBoxEvents.USER_OFF_ROUTE || event == MapBoxEvents.ROUTE_BUILT || event == MapBoxEvents.ON_MAP_TAP) "{" +
                    "  \"eventType\": \"${event.value}\"," +
                    "  \"data\": $data" +
                    "}" else "{" +
                    "  \"eventType\": \"${event.value}\"," +
                    "  \"data\": \"$data\"" +
                    "}"
        eventSink?.success(jsonString)
    }

    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
        Log.d("Embedded", "onActivityCreated not implemented")
    }

    override fun onActivityStarted(activity: Activity) {
        Log.d("Embedded", "onActivityStarted not implemented")
    }

    override fun onActivityResumed(activity: Activity) {
        Log.d("Embedded", "onActivityResumed not implemented")
    }

    override fun onActivityPaused(activity: Activity) {
        Log.d("Embedded", "onActivityPaused not implemented")
    }

    override fun onActivityStopped(activity: Activity) {
        Log.d("Embedded", "onActivityStopped not implemented")
    }

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
        Log.d("Embedded", "onActivitySaveInstanceState not implemented")
    }

    override fun onActivityDestroyed(activity: Activity) {
        Log.d("Embedded", "onActivityDestroyed not implemented")
    }
}

private class EmptyInfoPanelBinder : InfoPanelBinder() {
    override fun getHeaderLayout(layout: ViewGroup): ViewGroup? =
        layout.findViewById(R.id.infoPanelHeader)

    override fun getContentLayout(layout: ViewGroup): ViewGroup? =
        layout.findViewById(R.id.infoPanelContent)


    override fun onCreateLayout(
        layoutInflater: LayoutInflater,
        root: ViewGroup
    ): ViewGroup {
        return layoutInflater.inflate(
            R.layout.empty_info_panel, root,
            false
        ) as ViewGroup
    }
}

private class EmptyTripProgressBinder : UIBinder {
    override fun bind(viewGroup: ViewGroup): MapboxNavigationObserver {
        val scene = Scene.getSceneForLayout(
            viewGroup,
            R.layout.empty_trip_progress,
            viewGroup.context,
        )
        TransitionManager.go(scene, Fade())

        EmptyTripProgressBinding.bind(viewGroup)
        return UIComponent()
    }
}