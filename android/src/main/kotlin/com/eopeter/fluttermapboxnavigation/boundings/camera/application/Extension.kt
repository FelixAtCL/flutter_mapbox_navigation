package com.eopeter.fluttermapboxnavigation.boundings.camera.application

import android.content.Context
import com.eopeter.fluttermapboxnavigation.boundings.camera.domain.CameraState
import com.eopeter.fluttermapboxnavigation.boundings.style.application.toFLTEdgeInsets

fun com.mapbox.maps.CameraState.toCameraState(context: Context): CameraState = CameraState(
    bearing = bearing,
    padding = padding.toFLTEdgeInsets(context),
    pitch = pitch,
    zoom = zoom,
    center = center
)
