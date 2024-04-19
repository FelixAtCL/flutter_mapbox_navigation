package com.eopeter.fluttermapboxnavigation.boundings.navigation.port

import android.app.Activity
import android.app.Application
import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.transition.Fade
import androidx.transition.Scene
import androidx.transition.TransitionManager
import com.eopeter.fluttermapboxnavigation.R
import com.eopeter.fluttermapboxnavigation.core.*
import com.eopeter.fluttermapboxnavigation.databinding.EmptyTripProgressBinding
import com.eopeter.fluttermapboxnavigation.databinding.NavigationActivityBinding
import com.eopeter.fluttermapboxnavigation.models.MapBoxEvents
import com.eopeter.fluttermapboxnavigation.models.MapBoxRouteProgress
import com.eopeter.fluttermapboxnavigation.models.Waypoint
import com.eopeter.fluttermapboxnavigation.models.WaypointSet
import com.eopeter.fluttermapboxnavigation.utilities.CustomInfoPanelEndNavButtonBinder
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
import com.mapbox.navigation.ui.voice.api.MapboxAudioGuidance
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import java.util.HashMap

class NavigationCoreApi:
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
    private var withSteps: Boolean = true
    private var enableRefresh: Boolean = true
    private var waypointsPerRouteEnabled: Boolean = true
    private var withMetadata: Boolean = true
    private var computeTollCost: Boolean = true
    private var roundaboutExitsSeparated: Boolean = true
    private var maxHeight: Double? = null
    private var maxWidth: Double? = null
    private var maxWeight: Double? = null

    constructor(
        messenger: BinaryMessenger,
        binding: NavigationActivityBinding,
        viewId: Int,
        context: Context,
        activity: Activity) {
        this@NavigationCoreApi.messenger = messenger
        this@NavigationCoreApi.viewId = viewId
        this@NavigationCoreApi.context = context
        this@NavigationCoreApi.binding = binding
        this@NavigationCoreApi.activity = activity
    }

    fun init() {
        this.methodChannel =
            MethodChannel(
                this.messenger,
                "flutter_mapbox_navigation/navigation/core/${this.viewId}"
            )
        this.methodChannel?.setMethodCallHandler(this)

        eventChannel =
            EventChannel(
                this.messenger,
                "flutter_mapbox_navigation/navigation/core/${viewId}/events"
            )
        this.eventChannel?.setStreamHandler(this)
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            "setup" -> {
                this.setup(methodCall, result)
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
            "mute" -> {
                this.mute(methodCall, result)
            }
            "unmute" -> {
                this.unmute(methodCall, result)
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

    private fun setup(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        this.setOptions(arguments)
        result.success(null)
    }

    private fun build(methodCall: MethodCall, result: MethodChannel.Result) {
        this.isNavigationCanceled = false

        val arguments = methodCall.arguments as? Map<*, *>
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

    @OptIn(ExperimentalPreviewMapboxNavigationAPI::class)
    private fun start(methodCall: MethodCall, result: MethodChannel.Result) {
        if(this.currentRoutes == null) {
            sendEvent(MapBoxEvents.NAVIGATION_CANCELLED)
            result.success("No route initialized!")
            return
        }
        MapboxNavigationApp.current()!!.setNavigationRoutes(this.currentRoutes!!)
        MapboxNavigationApp.current()!!.setRoutesPreview(emptyList())
        this.isNavigationCanceled = false
        sendEvent(MapBoxEvents.NAVIGATION_RUNNING)
        MapboxNavigationApp.current()!!.registerRouteProgressObserver(routeProgressObserver =  {
            val json = Gson().toJson(MapBoxRouteProgress(it).toJsonObject())
            sendEvent(MapBoxEvents.PROGRESS_CHANGE, json)
        })
        result.success(null)
    }

    private fun finish(methodCall: MethodCall, result: MethodChannel.Result) {
        MapboxNavigationApp.current()!!.setNavigationRoutes(emptyList())
        sendEvent(MapBoxEvents.NAVIGATION_CANCELLED)
        this.isNavigationCanceled = true
        result.success(null)
    }

    private fun clear(methodCall: MethodCall, result: MethodChannel.Result) {
        this.currentRoutes = null
        MapboxNavigationApp.current()!!.setNavigationRoutes(emptyList())
        sendEvent(MapBoxEvents.NAVIGATION_CANCELLED)
        this.isNavigationCanceled = true
        result.success(null)
    }

    private fun mute(methodCall: MethodCall, result: MethodChannel.Result) {
        MapboxAudioGuidance.getRegisteredInstance().mute()
        result.success(null)
    }

    private fun unmute(methodCall: MethodCall, result: MethodChannel.Result) {
        MapboxAudioGuidance.getRegisteredInstance().unmute()
        result.success(null)
    }

    @OptIn(ExperimentalPreviewMapboxNavigationAPI::class)
    private fun getRoute(context: Context) {
        MapboxNavigationApp.current()!!.requestRoutes(
            routeOptions =
            RouteOptions.builder()
                .applyDefaultNavigationOptions(navigationMode)
                .applyLanguageAndVoiceUnitOptions(context)
                .coordinatesList(this.addedWaypoints.coordinatesList())
                .waypointIndicesList(this.addedWaypoints.waypointsIndices())
                .waypointNamesList(this.addedWaypoints.waypointsNames())
                .language(navigationLanguage)
                .alternatives(alternatives)
                .voiceUnits(navigationVoiceUnits)
                .bannerInstructions(bannerInstructionsEnabled)
                .voiceInstructions(voiceInstructionsEnabled)
                .steps(withSteps)
                .enableRefresh(enableRefresh)
                .waypointsPerRoute(waypointsPerRouteEnabled)
                .metadata(withMetadata)
                .computeTollCost(computeTollCost)
                .roundaboutExits(roundaboutExitsSeparated)
                .maxHeight(maxHeight)
                .maxWidth(maxWidth)
                .maxWeight(maxWeight)
                .build(),
            callback = object : NavigationRouterCallback {
                override fun onRoutesReady(
                    routes: List<NavigationRoute>,
                    routerOrigin: RouterOrigin
                ) {
                    this@NavigationCoreApi.currentRoutes = routes
                    sendEvent(
                        MapBoxEvents.ROUTE_BUILT,
                        Gson().toJson(routes.map { it.directionsRoute.toJson() })
                    )
                    this@NavigationCoreApi.binding.navigationView.api.routeReplayEnabled(
                        this@NavigationCoreApi.simulateRoute
                    )
                    MapboxNavigationApp.current()!!.setRoutesPreview(routes)

                    this@NavigationCoreApi.binding.navigationView.customizeViewBinders {
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

        this@NavigationCoreApi.binding.navigationView.customizeViewOptions {
            mapStyleUriDay = this@NavigationCoreApi.mapStyleUrlDay
            mapStyleUriNight = this@NavigationCoreApi.mapStyleUrlNight
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

        val withSteps = arguments["withSteps"] as? Boolean
        if (withSteps != null) {
            this.withSteps = withSteps
        }

        val enableRefresh = arguments["enableRefresh"] as? Boolean
        if (enableRefresh != null) {
            this.enableRefresh = enableRefresh
        }

        val waypointsPerRouteEnabled = arguments["waypointsPerRouteEnabled"] as? Boolean
        if (waypointsPerRouteEnabled != null) {
            this.waypointsPerRouteEnabled = waypointsPerRouteEnabled
        }

        val withMetadata = arguments["withMetadata"] as? Boolean
        if (withMetadata != null) {
            this.withMetadata = withMetadata
        }

        val computeTollCost = arguments["computeTollCost"] as? Boolean
        if (computeTollCost != null) {
            this.computeTollCost = computeTollCost
        }

        val roundaboutExitsSeparated = arguments["roundaboutExitsSeparated"] as? Boolean
        if (roundaboutExitsSeparated != null) {
            this.roundaboutExitsSeparated = roundaboutExitsSeparated
        }

        val maxHeight = arguments["maxHeight"] as? Double
        if (maxHeight != null) {
            this.maxHeight = maxHeight
        }

        val maxWidth = arguments["maxWidth"] as? Double
        if (maxWidth != null) {
            this.maxWidth = maxWidth
        }

        val maxWeight = arguments["maxWeight"] as? Double
        if (maxWeight != null) {
            this.maxWeight = maxWeight
        }
    }

    private fun sendEvent(event: MapBoxEvents, data: String = "") {
        val jsonString =
            if (event == MapBoxEvents.PROGRESS_CHANGE ||
                event == MapBoxEvents.MILESTONE_EVENT ||
                event == MapBoxEvents.USER_OFF_ROUTE ||
                event == MapBoxEvents.ROUTE_BUILT ||
                event == MapBoxEvents.ON_MAP_TAP) "{" +
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