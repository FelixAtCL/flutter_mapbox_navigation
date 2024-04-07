package com.eopeter.fluttermapboxnavigation.boundings.map.application

import com.eopeter.fluttermapboxnavigation.core.*
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

@Suppress("UNCHECKED_CAST")
object MapApiCodec : StandardMessageCodec() {
    override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
        return when (type) {
            128.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    CameraBounds.fromList(it)
                }
            }
            129.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    CameraBoundsOptions.fromList(it)
                }
            }
            130.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    CameraOptions.fromList(it)
                }
            }
            131.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    CameraState.fromList(it)
                }
            }
            132.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    CanonicalTileID.fromList(it)
                }
            }
            133.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    CoordinateBounds.fromList(it)
                }
            }
            134.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    CoordinateBoundsZoom.fromList(it)
                }
            }
            135.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    FeatureExtensionValue.fromList(it)
                }
            }
            136.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    GlyphsRasterizationOptions.fromList(it)
                }
            }
            137.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    ImageContent.fromList(it)
                }
            }
            138.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    ImageStretches.fromList(it)
                }
            }
            139.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    LayerPosition.fromList(it)
                }
            }
            140.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    MapAnimationOptions.fromList(it)
                }
            }
            141.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    MapDebugOptions.fromList(it)
                }
            }
            144.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    MapOptions.fromList(it)
                }
            }
            145.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    MbxEdgeInsets.fromList(it)
                }
            }
            146.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    MbxImage.fromList(it)
                }
            }
            147.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    MercatorCoordinate.fromList(it)
                }
            }
            148.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    OfflineRegionGeometryDefinition.fromList(it)
                }
            }
            149.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    OfflineRegionTilePyramidDefinition.fromList(it)
                }
            }
            150.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    ProjectedMeters.fromList(it)
                }
            }
            151.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    QueriedFeature.fromList(it)
                }
            }
            152.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    RenderedQueryGeometry.fromList(it)
                }
            }
            153.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    RenderedQueryOptions.fromList(it)
                }
            }
            154.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    ResourceOptions.fromList(it)
                }
            }
            155.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    ScreenBox.fromList(it)
                }
            }
            156.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    ScreenCoordinate.fromList(it)
                }
            }
            157.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    Size.fromList(it)
                }
            }
            158.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    SourceQueryOptions.fromList(it)
                }
            }
            159.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    StyleObjectInfo.fromList(it)
                }
            }
            160.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    StylePropertyValue.fromList(it)
                }
            }
            161.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    TransitionOptions.fromList(it)
                }
            }
            else -> super.readValueOfType(type, buffer)
        }
    }
    override fun writeValue(stream: ByteArrayOutputStream, value: Any?) {
        when (value) {
            is CameraBounds -> {
                stream.write(128)
                writeValue(stream, value.toList())
            }
            is CameraBoundsOptions -> {
                stream.write(129)
                writeValue(stream, value.toList())
            }
            is CameraOptions -> {
                stream.write(130)
                writeValue(stream, value.toList())
            }
            is CameraState -> {
                stream.write(131)
                writeValue(stream, value.toList())
            }
            is CanonicalTileID -> {
                stream.write(132)
                writeValue(stream, value.toList())
            }
            is CoordinateBounds -> {
                stream.write(133)
                writeValue(stream, value.toList())
            }
            is CoordinateBoundsZoom -> {
                stream.write(134)
                writeValue(stream, value.toList())
            }
            is FeatureExtensionValue -> {
                stream.write(135)
                writeValue(stream, value.toList())
            }
            is GlyphsRasterizationOptions -> {
                stream.write(136)
                writeValue(stream, value.toList())
            }
            is ImageContent -> {
                stream.write(137)
                writeValue(stream, value.toList())
            }
            is ImageStretches -> {
                stream.write(138)
                writeValue(stream, value.toList())
            }
            is LayerPosition -> {
                stream.write(139)
                writeValue(stream, value.toList())
            }
            is MapAnimationOptions -> {
                stream.write(140)
                writeValue(stream, value.toList())
            }
            is MapDebugOptions -> {
                stream.write(141)
                writeValue(stream, value.toList())
            }
            is MapOptions -> {
                stream.write(144)
                writeValue(stream, value.toList())
            }
            is MbxEdgeInsets -> {
                stream.write(145)
                writeValue(stream, value.toList())
            }
            is MbxImage -> {
                stream.write(146)
                writeValue(stream, value.toList())
            }
            is MercatorCoordinate -> {
                stream.write(147)
                writeValue(stream, value.toList())
            }
            is OfflineRegionGeometryDefinition -> {
                stream.write(148)
                writeValue(stream, value.toList())
            }
            is OfflineRegionTilePyramidDefinition -> {
                stream.write(149)
                writeValue(stream, value.toList())
            }
            is ProjectedMeters -> {
                stream.write(150)
                writeValue(stream, value.toList())
            }
            is QueriedFeature -> {
                stream.write(151)
                writeValue(stream, value.toList())
            }
            is RenderedQueryGeometry -> {
                stream.write(152)
                writeValue(stream, value.toList())
            }
            is RenderedQueryOptions -> {
                stream.write(153)
                writeValue(stream, value.toList())
            }
            is ResourceOptions -> {
                stream.write(154)
                writeValue(stream, value.toList())
            }
            is ScreenBox -> {
                stream.write(155)
                writeValue(stream, value.toList())
            }
            is ScreenCoordinate -> {
                stream.write(156)
                writeValue(stream, value.toList())
            }
            is Size -> {
                stream.write(157)
                writeValue(stream, value.toList())
            }
            is SourceQueryOptions -> {
                stream.write(158)
                writeValue(stream, value.toList())
            }
            is StyleObjectInfo -> {
                stream.write(159)
                writeValue(stream, value.toList())
            }
            is StylePropertyValue -> {
                stream.write(160)
                writeValue(stream, value.toList())
            }
            is TransitionOptions -> {
                stream.write(161)
                writeValue(stream, value.toList())
            }
            else -> super.writeValue(stream, value)
        }
    }
}