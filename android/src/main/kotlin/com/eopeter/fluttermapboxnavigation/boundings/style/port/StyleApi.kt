package com.eopeter.fluttermapboxnavigation.boundings.style

import android.content.Context
import com.eopeter.fluttermapboxnavigation.boundings.style.domain.*
import com.mapbox.bindgen.DataRef
import com.mapbox.maps.Image
import com.mapbox.maps.MapboxMap
import com.eopeter.fluttermapboxnavigation.boundings.style.application.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
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
        this.methodChannel = MethodChannel(this.messenger, "flutter_mapbox_navigation/style/${this.viewId}")
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

    override fun getStyleLayerProperties(layerId: String, callback: (Result<String>) -> Unit) {
        val expected = mapboxMap.getStyleLayerProperties(layerId)
        if (expected.isError) {
            callback(Result.failure(Throwable(expected.error)))
        } else {
            callback(Result.success(expected.value!!.toJson()))
        }
    }

    override fun setStyleLayerProperties(
        layerId: String,
        properties: String,
        callback: (Result<Unit>) -> Unit
    ) {
        val expected = mapboxMap.setStyleLayerProperties(layerId, properties.toValue())
        if (expected.isError) {
            callback(Result.failure(Throwable(expected.error)))
        } else {
            callback(Result.success(Unit))
        }
    }

    override fun addStyleSource(
        sourceId: String,
        properties: String,
        callback: (Result<Unit>) -> Unit
    ) {
        val expected = mapboxMap.addStyleSource(sourceId, properties.toValue())
        if (expected.isError) {
            callback(Result.failure(Throwable(expected.error)))
        } else {
            callback(Result.success(Unit))
        }
    }

    override fun getStyleSourceProperty(
        sourceId: String,
        property: String,
        callback: (Result<StylePropertyValue>) -> Unit
    ) {
        val styleLayerProperty = mapboxMap.getStyleSourceProperty(sourceId, property)
        val stylePropertyValueKind =
            StylePropertyValueKind.values()[styleLayerProperty.kind.ordinal]
        val value = styleLayerProperty.value.toFLTValue()
        val stylePropertyValue =
            StylePropertyValue(value, stylePropertyValueKind)
        callback(Result.success(stylePropertyValue))
    }

    override fun setStyleSourceProperty(
        sourceId: String,
        property: String,
        value: Any,
        callback: (Result<Unit>) -> Unit
    ) {
        val expected =
            mapboxMap.setStyleSourceProperty(sourceId, property, value.toValue())
        if (expected.isError) {
            callback(Result.failure(Throwable(expected.error)))
        } else {
            callback(Result.success(Unit))
        }
    }

    override fun getStyleSourceProperties(sourceId: String, callback: (Result<String>) -> Unit) {
        val expected = mapboxMap.getStyleSourceProperties(sourceId)
        if (expected.isError) {
            callback(Result.failure(Throwable(expected.error)))
        } else {
            callback(Result.success(expected.value!!.toJson()))
        }
    }

    override fun setStyleSourceProperties(
        sourceId: String,
        properties: String,
        callback: (Result<Unit>) -> Unit
    ) {
        val expected = mapboxMap.setStyleSourceProperties(sourceId, properties.toValue())
        if (expected.isError) {
            callback(Result.failure(Throwable(expected.error)))
        } else {
            callback(Result.success(Unit))
        }
    }

    override fun updateStyleImageSourceImage(
        sourceId: String,
        image: MbxImage,
        callback: (Result<Unit>) -> Unit
    ) {
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

        val expected = mapboxMap.updateStyleImageSourceImage(
            sourceId,
            Image(
                image.width.toInt(),
                image.height.toInt(),
                DataRef(byteBuffer)
            )
        )
        if (expected.isError) {
            callback(Result.failure(Throwable(expected.error)))
        } else {
            callback(Result.success(Unit))
        }
    }

    override fun removeStyleSource(sourceId: String, callback: (Result<Unit>) -> Unit) {
        val expected = mapboxMap.removeStyleSource(sourceId)
        if (expected.isError) {
            callback(Result.failure(Throwable(expected.error)))
        } else {
            callback(Result.success(Unit))
        }
    }

    override fun styleSourceExists(sourceId: String, callback: (Result<Boolean>) -> Unit) {
        val expected = mapboxMap.styleSourceExists(sourceId)
        callback(Result.success(expected))
    }

    override fun getStyleSources(callback: (Result<List<StyleObjectInfo?>>) -> Unit) {
        callback(
            Result.success(
                mapboxMap.styleSources.map { it.toFLTStyleObjectInfo() }.toMutableList()
            )
        )
    }

    override fun getStyleLights(): List<StyleObjectInfo> {
        return mapboxMap.style?.getStyleLights()?.map { it.toFLTStyleObjectInfo() }
            ?: listOf()
    }

    override fun setLight(flatLight: FlatLight) {
        mapboxMap.style?.setLight(flatLight.toFlatLight())
    }

    override fun setLights(
        ambientLight: AmbientLight,
        directionalLight: DirectionalLight
    ) {
        mapboxMap.style?.setLight(ambientLight.toAmbientLight(), directionalLight.toDirectionalLight())
    }

    override fun getStyleLightProperty(
        id: String,
        property: String,
        callback: (Result<StylePropertyValue>) -> Unit
    ) {
        val styleLightProperty = mapboxMap.style?.getStyleLightProperty(id, property)

        if (styleLightProperty != null) {
            callback(
                Result.success(
                    StylePropertyValue(styleLightProperty.value.toFLTValue(), StylePropertyValueKind.values()[styleLightProperty.kind.ordinal])
                )
            )
        } else {
            callback(Result.failure(Throwable("No style available")))
        }
    }

    override fun setStyleLightProperty(
        id: String,
        property: String,
        value: Any,
        callback: (Result<Unit>) -> Unit
    ) {
        val expected = mapboxMap.style?.setStyleLightProperty(id, property, value.toValue())
        if (expected?.isError == true) {
            callback(Result.failure(Throwable(expected.error)))
        } else {
            callback(Result.success(Unit))
        }
    }

    override fun setStyleTerrain(properties: String, callback: (Result<Unit>) -> Unit) {
        val expected = mapboxMap.setStyleTerrain(properties.toValue())
        if (expected.isError) {
            callback(Result.failure(Throwable(expected.error)))
        } else {
            callback(Result.success(Unit))
        }
    }

    override fun getStyleTerrainProperty(
        property: String,
        callback: (Result<StylePropertyValue>) -> Unit
    ) {
        val styleProperty = mapboxMap.getStyleTerrainProperty(property)
        val stylePropertyValueKind =
            StylePropertyValueKind.values()[styleProperty.kind.ordinal]
        val stylePropertyValue =
            StylePropertyValue(styleProperty.value.toFLTValue(), stylePropertyValueKind)
        callback(Result.success(stylePropertyValue))
    }

    override fun setStyleTerrainProperty(
        property: String,
        value: Any,
        callback: (Result<Unit>) -> Unit
    ) {
        val expected = mapboxMap.setStyleTerrainProperty(property, value.toValue())
        if (expected.isError) {
            callback(Result.failure(Throwable(expected.error)))
        } else {
            callback(Result.success(Unit))
        }
    }

    override fun getStyleImage(imageId: String, callback: (Result<MbxImage?>) -> Unit) {
        val image = mapboxMap.getStyleImage(imageId)

        if (image == null) {
            callback(Result.success(null))
            return
        }

        val byteArray = ByteArray(image.data.buffer.capacity())
        image.data.buffer.get(byteArray)
        callback(
            Result.success(
                MbxImage(width = image.width.toLong(), height = image.height.toLong(), data = byteArray)
            )
        )
    }

    override fun removeStyleImage(imageId: String, callback: (Result<Unit>) -> Unit) {
        val expected = mapboxMap.removeStyleImage(imageId)
        if (expected.isError) {
            callback(Result.failure(Throwable(expected.error)))
        } else {
            callback(Result.success(Unit))
        }
    }

    override fun hasStyleImage(imageId: String, callback: (Result<Boolean>) -> Unit) {
        callback(Result.success(mapboxMap.hasStyleImage(imageId)))
    }

    override fun invalidateStyleCustomGeometrySourceTile(
        sourceId: String,
        tileId: CanonicalTileID,
        callback: (Result<Unit>) -> Unit
    ) {
        val expected = mapboxMap.invalidateStyleCustomGeometrySourceTile(
            sourceId,
            com.mapbox.maps.CanonicalTileID(
                tileId.z.toByte(), tileId.x.toInt(), tileId.y.toInt()
            )
        )
        if (expected.isError) {
            callback(Result.failure(Throwable(expected.error)))
        } else {
            callback(Result.success(Unit))
        }
    }

    override fun invalidateStyleCustomGeometrySourceRegion(
        sourceId: String,
        bounds: CoordinateBounds,
        callback: (Result<Unit>) -> Unit
    ) {
        mapboxMap.invalidateStyleCustomGeometrySourceRegion(
            sourceId,
            bounds.toCoordinateBounds()
        )
        callback(Result.success(Unit))
    }

    override fun isStyleLoaded(callback: (Result<Boolean>) -> Unit) {
        callback(Result.success(mapboxMap.isStyleLoaded()))
    }

    override fun getProjection(): StyleProjection? {
        return mapboxMap.style?.getProjection()?.toFLTProjection()
    }

    override fun setProjection(projection: StyleProjection) {
        mapboxMap.style?.setProjection(projection.toProjection())
    }

    override fun localizeLabels(
        locale: String,
        layerIds: List<String>?,
        callback: (Result<Unit>) -> Unit
    ) {
        mapboxMap.style?.localizeLabels(Locale(locale), layerIds)
        callback(Result.success(Unit))
    }

    override fun addStyleImage(
        imageId: String,
        scale: Double,
        image: MbxImage,
        sdf: Boolean,
        stretchX: List<ImageStretches?>,
        stretchY: List<ImageStretches?>,
        content: ImageContent?,
        callback: (Result<Unit>) -> Unit
    ) {
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
        val expected = mapboxMap.addStyleImage(
            imageId, scale.toFloat(),
            Image(
                image.width.toInt(),
                image.height.toInt(),
                DataRef(byteBuffer)
            ),
            sdf,
            stretchX.map {
                com.mapbox.maps.ImageStretches(
                    it!!.first.toFloat(),
                    it!!.second.toFloat()
                )
            },
            stretchY.map { com.mapbox.maps.ImageStretches(it!!.first.toFloat(), it!!.second.toFloat()) }.toMutableList(),
            if (content != null) com.mapbox.maps.ImageContent(
                content.left.toFloat(),
                content.top.toFloat(), content.right.toFloat(), content.bottom.toFloat()
            ) else null
        )
        if (expected.isError) {
            callback(Result.failure(Throwable(expected.error)))
        } else {
            callback(Result.success(Unit))
        }
    }
}
