package com.eopeter.fluttermapboxnavigation.boundings.style

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.provider.ContactsContract
import androidx.appcompat.view.menu.ListMenuItemView
import com.eopeter.fluttermapboxnavigation.boundings.style.domain.*
import com.mapbox.bindgen.DataRef
import com.mapbox.maps.Image
import com.mapbox.maps.MapboxMap
import com.eopeter.fluttermapboxnavigation.boundings.style.application.*
import com.mapbox.maps.StyleObjectInfo
import com.mapbox.maps.extension.localization.localizeLabels
import com.mapbox.maps.extension.style.projection.generated.getProjection
import com.mapbox.maps.extension.style.projection.generated.setProjection
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import kotlinx.serialization.decodeFromString
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.nio.ByteBuffer
import java.util.*

class StyleApi : MethodChannel.MethodCallHandler {
    private var methodChannel: MethodChannel? = null
    private val messenger: BinaryMessenger
    private val mapboxMap: MapboxMap
    private val context: Context
    private val viewId: Int

    constructor(messenger: BinaryMessenger, mapboxMap: MapboxMap, viewId: Int, context: Context) {
        this@StyleApi.messenger = messenger
        this@StyleApi.mapboxMap = mapboxMap
        this@StyleApi.viewId = viewId
        this@StyleApi.context = context
    }

    fun init() {
        this.methodChannel = MethodChannel(this.messenger, "flutter_mapbox_navigation/style/${this.viewId}", StandardMethodCodec(StyleApiCodec))
        this.methodChannel?.setMethodCallHandler(this)
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            "getStyleURI" -> {
                this.getStyleURI(methodCall, result)
            }
            "setStyleURI" -> {
                this.setStyleURI(methodCall, result)
            }
            "getStyleJSON" -> {
                this.getStyleJSON(methodCall, result)
            }
            "setStyleJSON" -> {
                this.setStyleJSON(methodCall, result)
            }
            "getStyleDefaultCamera" -> {
                this.getStyleDefaultCamera(methodCall, result)
            }
            "getStyleTransition" -> {
                this.getStyleTransition(methodCall, result)
            }
            "setStyleTransition" -> {
                this.setStyleTransition(methodCall, result)
            }
            "addStyleLayer" -> {
                this.addStyleLayer(methodCall, result)
            }
            "addPersistentStyleLayer" -> {
                this.addPersistentStyleLayer(methodCall, result)
            }
            "isStyleLayerPersistent" -> {
                this.isStyleLayerPersistent(methodCall, result)
            }
            "removeStyleLayer" -> {
                this.removeStyleLayer(methodCall, result)
            }
            "moveStyleLayer" -> {
                this.moveStyleLayer(methodCall, result)
            }
            "styleLayerExists" -> {
                this.styleLayerExists(methodCall, result)
            }
            "getStyleLayers" -> {
                this.getStyleLayers(methodCall, result)
            }
            "getStyleLayerProperty" -> {
                this.getStyleLayerProperty(methodCall, result)
            }
            "setStyleLayerProperty" -> {
                this.setStyleLayerProperty(methodCall, result)
            }
            "getStyleLayerProperties" -> {
                this.getStyleLayerProperties(methodCall, result)
            }
            "setStyleLayerProperties" -> {
                this.setStyleLayerProperties(methodCall, result)
            }
            "addStyleSource" -> {
                this.addStyleSource(methodCall, result)
            }
            "getStyleSourceProperty" -> {
                this.getStyleSourceProperty(methodCall, result)
            }
            "setStyleSourceProperty" -> {
                this.setStyleSourceProperty(methodCall, result)
            }
            "getStyleSourceProperties" -> {
                this.getStyleSourceProperties(methodCall, result)
            }
            "setStyleSourceProperties" -> {
                this.setStyleSourceProperties(methodCall, result)
            }
            "updateStyleImageSourceImage" -> {
                this.updateStyleImageSourceImage(methodCall, result)
            }
            "removeStyleSource" -> {
                this.removeStyleSource(methodCall, result)
            }
            "styleSourceExists" -> {
                this.styleSourceExists(methodCall, result)
            }
            "getStyleSources" -> {
                this.getStyleSources(methodCall, result)
            }
            "setStyleLight" -> {
                this.setStyleLight(methodCall, result)
            }
            "getStyleLightProperty" -> {
                this.getStyleLightProperty(methodCall, result)
            }
            "setStyleLightProperty" -> {
                this.setStyleLightProperty(methodCall, result)
            }
            "setStyleTerrain" -> {
                this.setStyleTerrain(methodCall, result)
            }
            "getStyleTerrainProperty" -> {
                this.getStyleTerrainProperty(methodCall, result)
            }
            "setStyleTerrainProperty" -> {
                this.setStyleTerrainProperty(methodCall, result)
            }
            "getStyleImage" -> {
                this.getStyleImage(methodCall, result)
            }
            "addStyleImage" -> {
                this.addStyleImage(methodCall, result)
            }
            "removeStyleImage" -> {
                this.removeStyleImage(methodCall, result)
            }
            "hasStyleImage" -> {
                this.hasStyleImage(methodCall, result)
            }
            "invalidateStyleCustomGeometrySourceTile" -> {
                this.invalidateStyleCustomGeometrySourceTile(methodCall, result)
            }
            "invalidateStyleCustomGeometrySourceRegion" -> {
                this.invalidateStyleCustomGeometrySourceRegion(methodCall, result)
            }
            "isStyleLoaded" -> {
                this.isStyleLoaded(methodCall, result)
            }
            "getProjection" -> {
                this.getProjection(methodCall, result)
            }
            "setProjection" -> {
                this.setProjection(methodCall, result)
            }
            "localizeLabels" -> {
                this.localizeLabels(methodCall, result)
            }
            else -> result.notImplemented()
        }
    }

    private fun getStyleURI(methodCall: MethodCall, result: MethodChannel.Result) {
        result.success(mapboxMap.getStyle()?.styleURI ?: "")
    }

    private fun setStyleURI(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val uri = arguments["uri"] as? String ?: return

        mapboxMap.loadStyleUri(uri) {
            result.success(null)
        }
    }

    private fun getStyleJSON(methodCall: MethodCall, result: MethodChannel.Result) {
        result.success(mapboxMap.getStyle()?.styleJSON ?: "")
    }

    private fun setStyleJSON(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val json = arguments["json"] as? String ?: return
        mapboxMap.loadStyleJson(json) {
            result.success(null)
        }
    }

    private fun getStyleDefaultCamera(methodCall: MethodCall, result: MethodChannel.Result) {
        val camera = mapboxMap.getStyle()?.styleDefaultCamera ?: return
        result.success(camera.toFLTCameraOptions(context))
    }

    private fun getStyleTransition(methodCall: MethodCall, result: MethodChannel.Result) {
        val transitionOptions = mapboxMap.getStyle()?.styleTransition ?: return
        TransitionOptions(
            duration = transitionOptions.duration,
            delay = transitionOptions.delay,
            enablePlacementTransitions = transitionOptions.enablePlacementTransitions
        )
        result.success(transitionOptions)
    }

    private fun setStyleTransition(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val transitionOptions = arguments["transition"] as? TransitionOptions ?: return
        mapboxMap.getStyle()?.styleTransition = com.mapbox.maps.TransitionOptions.Builder()
            .delay(transitionOptions.delay)
            .duration(transitionOptions.duration)
            .enablePlacementTransitions(transitionOptions.enablePlacementTransitions).build()
        result.success(Unit)
    }

    private fun addStyleLayer(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val properties = arguments["properties"] as? String ?: return
        val layerPosition = arguments["layerposition"] as? LayerPosition ?: return

        properties.toValue().let { parameters ->
            val expected = mapboxMap.getStyle()?.addStyleLayer(
                parameters,
                com.mapbox.maps.LayerPosition(
                    layerPosition.above,
                    layerPosition.below,
                    layerPosition.at?.toInt()
                )
            )
            if (expected == null || expected.isError) {
                result.failure(Throwable(expected?.error ?: "expected is null"))
            } else {
                result.success(Unit)
            }
            return Unit
        }
    }

    private fun addPersistentStyleLayer(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val properties = arguments["properties"] as? String ?: return
        val layerPosition = arguments["layerposition"] as? LayerPosition ?: return

        properties.toValue().let { parameters ->
            val expected = mapboxMap.getStyle()?.addPersistentStyleLayer(
                parameters,
                com.mapbox.maps.LayerPosition(
                    layerPosition.above,
                    layerPosition.below,
                    layerPosition.at?.toInt()
                )
            )
            if (expected == null || expected.isError) {
                result.failure(Throwable(expected?.error ?: "expected is null"))
            } else {
                result.success(Unit)
            }
            return Unit
        }
    }

    private fun isStyleLayerPersistent(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val layerId = arguments["id"] as? String ?: return
        val expected = mapboxMap.getStyle()?.isStyleLayerPersistent(layerId)
        if (expected == null || expected.isError) {
            result.failure(Throwable(expected?.error ?: "expected is null"))
        } else {
            result.success(expected.value!!)
        }
    }

    private fun removeStyleLayer(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val layerId = arguments["id"] as? String ?: return
        val expected = mapboxMap.getStyle()?.removeStyleLayer(layerId)
        if (expected == null || expected.isError) {
            result.failure(Throwable(expected?.error ?: "expected is null"))
        } else {
            result.success(Unit)
        }
    }

    private fun moveStyleLayer(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val layerId = arguments["id"] as? String ?: return
        var layerPosition = arguments["layerposition"] as? LayerPosition
        val expected = mapboxMap.getStyle()?.moveStyleLayer(
            layerId,
            if (layerPosition != null) com.mapbox.maps.LayerPosition(
                layerPosition.above,
                layerPosition.below,
                layerPosition.at?.toInt()
            ) else null
        )
        if (expected == null || expected.isError) {
            result.failure(Throwable(expected?.error ?: "expected is null"))
        } else {
            result.success(Unit)
        }
    }

    private fun styleLayerExists(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val layerId = arguments["id"] as? String ?: return
        val expected = mapboxMap.getStyle()?.styleLayerExists(layerId)
        result.success(expected)
    }

    private fun getStyleLayers(methodCall: MethodCall, result: MethodChannel.Result) {
        result.success(mapboxMap.getStyle()?.styleLayers?.map { it.toFLTStyleObjectInfo() }?.toMutableList())
    }

    private fun getStyleLayerProperty(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val layerId = arguments["id"] as? String ?: return
        val property = arguments["property"] as? String ?: return
        val styleLayerProperty = mapboxMap.getStyle()?.getStyleLayerProperty(layerId, property)
        if(styleLayerProperty == null) {
            result.failure(null)
            return
        }
        val stylePropertyValueKind =
            StylePropertyValueKind.values()[styleLayerProperty.kind.ordinal]
        val stylePropertyValue =
            StylePropertyValue(styleLayerProperty.value.toFLTValue(), stylePropertyValueKind)
        result.success(stylePropertyValue)
    }

    private fun setStyleLayerProperty(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val layerId = arguments["id"] as? String ?: return
        val property = arguments["property"] as? String ?: return
        val value = arguments["value"] as? Any ?: return
        val expected = mapboxMap.getStyle()?.setStyleLayerProperty(layerId, property, value.toValue())
        if (expected == null || expected.isError) {
            result.failure(Throwable(expected?.error ?: "expected is null"))
        } else {
            result.success(Unit)
        }
    }

    private fun getStyleLayerProperties(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val layerId = arguments["id"] as? String ?: return
        val expected = mapboxMap.getStyle()?.getStyleLayerProperties(layerId)
        if (expected == null || expected.isError) {
            result.failure(Throwable(expected?.error ?: "expected is null"))
        } else {
            result.success(expected.value!!.toJson())
        }
    }

    private fun setStyleLayerProperties(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val layerId = arguments["id"] as? String ?: return
        val properties = arguments["properties"] as? String ?: return
        val expected = mapboxMap.getStyle()?.setStyleLayerProperties(layerId, properties.toValue())
        if (expected == null || expected.isError) {
            result.failure(Throwable(expected?.error ?: "expected is null"))
        } else {
            result.success(Unit)
        }
    }

    private fun addStyleSource(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val sourceId = arguments["id"] as? String ?: return
        val properties = arguments["properties"] as? String ?: return
        val expected = mapboxMap.getStyle()?.addStyleSource(sourceId, properties.toValue())
        if (expected == null || expected.isError) {
            result.failure(Throwable(expected?.error ?: "expected is null"))
        } else {
            result.success(Unit)
        }
    }

    private fun getStyleSourceProperty(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val sourceId = arguments["id"] as? String ?: return
        val property = arguments["property"] as? String ?: return
        val styleLayerProperty = mapboxMap.getStyle()?.getStyleSourceProperty(sourceId, property)

        if(styleLayerProperty == null) {
            result.failure(null)
            return
        }

        val stylePropertyValueKind = StylePropertyValueKind.values()[styleLayerProperty.kind.ordinal]
        val value = styleLayerProperty.value.toFLTValue()
        val stylePropertyValue = StylePropertyValue(value, stylePropertyValueKind)
        result.success(stylePropertyValue)
    }

    private fun setStyleSourceProperty(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val sourceId = arguments["id"] as? String ?: return
        val property = arguments["property"] as? String ?: return
        val value = arguments["value"] ?: return
        val expected = mapboxMap.getStyle()?.setStyleSourceProperty(sourceId, property, value.toValue())
        if (expected == null || expected.isError) {
            result.failure(Throwable(expected?.error ?: "expected is null"))
        } else {
            result.success(Unit)
        }
    }

    private fun getStyleSourceProperties(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val sourceId = arguments["id"] as? String ?: return
        val expected = mapboxMap.getStyle()?.getStyleSourceProperties(sourceId)
        if (expected == null || expected.isError) {
            result.failure(Throwable(expected?.error ?: "expected is null"))
        } else {
            result.success(expected.value!!.toJson())
        }
    }

    private fun setStyleSourceProperties(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val sourceId = arguments["id"] as? String ?: return
        val properties = arguments["properties"] as? String ?: return
        val expected = mapboxMap.getStyle()?.setStyleSourceProperties(sourceId, properties.toValue())
        if (expected == null || expected.isError) {
            result.failure(Throwable(expected?.error ?: "expected is null"))
        } else {
            result.success(Unit)
        }
    }

    private fun updateStyleImageSourceImage(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val sourceId = arguments["id"] as? String ?: return
        val image = arguments["image"] as? MbxImage ?: return
        var bitmap = BitmapFactory.decodeByteArray(
            image.data,
            0,
            image.data.size
        )
        if (bitmap.config != Bitmap.Config.ARGB_8888) {
            bitmap = bitmap.copy(Bitmap.Config.ARGB_8888, false)
        }
        val byteBuffer = ByteBuffer.allocateDirect(bitmap.byteCount)
        bitmap.copyPixelsToBuffer(byteBuffer)

        val expected = mapboxMap.getStyle()?.updateStyleImageSourceImage(
            sourceId,
            Image(
                image.width.toInt(),
                image.height.toInt(),
                byteBuffer.array()
            )
        )
        if (expected == null || expected.isError) {
            result.failure(Throwable(expected?.error ?: "expected is null"))
        } else {
            result.success(Unit)
        }
    }

    private fun removeStyleSource(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val sourceId = arguments["id"] as? String ?: return
        val expected = mapboxMap.getStyle()?.removeStyleSource(sourceId)
        if (expected == null || expected.isError) {
            result.failure(Throwable(expected?.error ?: "expected is null"))
        } else {
            result.success(Unit)
        }
    }

    private fun styleSourceExists(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val sourceId = arguments["id"] as? String ?: return
        val expected = mapboxMap.getStyle()?.styleSourceExists(sourceId)
        result.success(expected ?: false)
    }

    private fun getStyleSources(methodCall: MethodCall, result: MethodChannel.Result) {
        result.success(
                mapboxMap.getStyle()?.styleSources?.map { it.toFLTStyleObjectInfo() }?.toMutableList() ?: emptyList()
            )
    }

    private fun setStyleLight(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val properties = arguments["properties"] as? String ?: return
        val parameters = Json.decodeFromString<ContactsContract.Data>(properties) ?: return
        mapboxMap.getStyle()?.setStyleLight(parameters)
        result.success(null)
    }

    private fun getStyleLightProperty(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val property = arguments["property"] as? String ?: return
        val styleLightProperty = mapboxMap.getStyle()?.getStyleLightProperty(property)

        if (styleLightProperty != null) {
            result.success(StylePropertyValue(styleLightProperty.value.toFLTValue(), StylePropertyValueKind.values()[styleLightProperty.kind.ordinal]))
        } else {
            result.failure(Throwable("No style available"))
        }
    }

    private fun setStyleLightProperty(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val property = arguments["property"] as? String ?: return
        val value = arguments["value"] ?: return
        val expected = mapboxMap.getStyle()?.setStyleLightProperty(property, value.toValue())
        if (expected?.isError == true) {
            result.failure(Throwable(expected.error))
        } else {
            result.success(null)
        }
    }

    private fun setStyleTerrain(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val properties = arguments["properties"] as? String ?: return
        val expected = mapboxMap.getStyle()?.setStyleTerrain(properties.toValue())
        if (expected == null || expected.isError) {
            result.failure(Throwable(expected?.error ?: "expected is null"))
        } else {
            result.success(null)
        }
    }

    private fun getStyleTerrainProperty(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val property = arguments["property"] as? String ?: return
        val styleProperty = mapboxMap.getStyle()?.getStyleTerrainProperty(property)

        if(styleProperty == null) {
            result.success(null)
            return
        }

        val stylePropertyValueKind =
            StylePropertyValueKind.values()[styleProperty.kind.ordinal]
        val stylePropertyValue =
            StylePropertyValue(styleProperty.value.toFLTValue(), stylePropertyValueKind)
        result.success(stylePropertyValue)
    }

    private fun setStyleTerrainProperty(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val property = arguments["property"] as? String ?: return
        val value = arguments["value"] ?: return
        val expected = mapboxMap.getStyle()?.setStyleTerrainProperty(property, value.toValue())
        if (expected == null || expected.isError) {
            result.failure(Throwable(expected?.error ?: "expected is null"))
        } else {
            result.success(null)
        }
    }

    private fun getStyleImage(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val imageId = arguments["id"] as? String ?: return
        val image = mapboxMap.getStyle()?.getStyleImage(imageId)

        if (image == null) {
            result.success(null)
            return
        }

        result.success(MbxImage(width = image.width.toLong(), height = image.height.toLong(), data = image.data))
    }

    private fun addStyleImage(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val imageId = arguments["id"] as? String ?: return
        val scale = arguments["scale"] as? Double ?: return
        val image = arguments["image"] as? MbxImage ?: return
        val sdf = arguments["sdf"] as? Boolean ?: return
        @Suppress("UNCHECKED_CAST")
        val stretchX = (arguments["stretchX"] as? List<ImageStretches?>) ?: return
        @Suppress("UNCHECKED_CAST")
        val stretchY = arguments["stretchY"] as? List<ImageStretches?> ?: return
        val content = arguments["content"] as? ImageContent

        var bitmap = BitmapFactory.decodeByteArray(
            image.data,
            0,
            image.data.size
        )
        if (bitmap.config != Bitmap.Config.ARGB_8888) {
            bitmap = bitmap.copy(Bitmap.Config.ARGB_8888, false)
        }
        val byteBuffer = ByteBuffer.allocateDirect(bitmap.byteCount)
        bitmap.copyPixelsToBuffer(byteBuffer)
        val expected = mapboxMap.getStyle()?.addStyleImage(
            imageId, scale.toFloat(),
            Image(
                image.width.toInt(),
                image.height.toInt(),
                byteBuffer.array()
            ),
            sdf,
            stretchX.map {
                com.mapbox.maps.ImageStretches(
                    it!!.first.toFloat(),
                    it!!.second.toFloat()
                )
            },
            stretchY.map { com.mapbox.maps.ImageStretches(it!!.first.toFloat(), it.second.toFloat()) }.toMutableList(),
            if (content != null) {
                com.mapbox.maps.ImageContent(
                    content.left.toFloat(),
                    content.top.toFloat(),
                    content.right.toFloat(),
                    content.bottom.toFloat()
                )
            } else null
        )
        if (expected == null || expected.isError) {
            result.failure(Throwable(expected?.error ?: "expected is null"))
        } else {
            result.success(null)
        }
    }

    private fun removeStyleImage(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val imageId = arguments["id"] as? String ?: return
        val expected = mapboxMap.getStyle()?.removeStyleImage(imageId)
        if (expected == null || expected.isError) {
            result.failure(Throwable(expected?.error ?: "expected is null"))
        } else {
            result.success(null)
        }
    }

    private fun hasStyleImage(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val imageId = arguments["id"] as? String ?: return
        result.success(mapboxMap.getStyle()?.hasStyleImage(imageId))
    }

    private fun invalidateStyleCustomGeometrySourceTile(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val sourceId = arguments["id"] as? String ?: return
        val tileId = arguments["tileId"] as? CanonicalTileID ?: return
        val expected = mapboxMap.getStyle()?.invalidateStyleCustomGeometrySourceTile(
            sourceId,
            com.mapbox.maps.CanonicalTileID(
                tileId.z.toByte(), tileId.x.toInt(), tileId.y.toInt()
            )
        )
        if (expected == null || expected.isError) {
            result.failure(Throwable(expected?.error ?: "expected is null"))
        } else {
            result.success(null)
        }
    }

    private fun invalidateStyleCustomGeometrySourceRegion(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val sourceId = arguments["id"] as? String ?: return
        val bounds = arguments["bounds"] as? CoordinateBounds ?: return
        mapboxMap.getStyle()?.invalidateStyleCustomGeometrySourceRegion(
            sourceId,
            bounds.toCoordinateBounds()
        )
        result.success(null)
    }

    private fun isStyleLoaded(methodCall: MethodCall, result: MethodChannel.Result) {
        result.success(mapboxMap.getStyle()?.isStyleLoaded)
    }

    private fun getProjection(methodCall: MethodCall, result: MethodChannel.Result) {
        val projection = mapboxMap.getStyle()?.getProjection()?.toFLTProjection()
        result.success(projection)
    }

    private fun setProjection(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val projection = arguments["projection"] as? StyleProjection ?: return
        mapboxMap.getStyle()?.setProjection(projection.toProjection())
    }

    private fun localizeLabels(methodCall: MethodCall, result: MethodChannel.Result) {
        val arguments = methodCall.arguments as? Map<*, *> ?: return
        val locale = arguments["locale"] as? String ?: return
        @Suppress("UNCHECKED_CAST")
        val layerIds = arguments["layerids"] as? List<String>
        mapboxMap.getStyle()?.localizeLabels(Locale(locale), layerIds)
        result.success(null)
    }
}
