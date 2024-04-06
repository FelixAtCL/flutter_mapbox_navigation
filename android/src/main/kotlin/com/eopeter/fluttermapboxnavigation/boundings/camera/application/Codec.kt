package com.eopeter.fluttermapboxnavigation.boundings.camera.application

import com.eopeter.fluttermapboxnavigation.core.*
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

@Suppress("UNCHECKED_CAST")
object CameraApiCodec : StandardMessageCodec() {
    override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
        return when (type) {
            128.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    CameraOptions.fromList(it)
                }
            }
            129.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    MapAnimationOptions.fromList(it)
                }
            }
            130.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    MbxEdgeInsets.fromList(it)
                }
            }
            131.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    ScreenCoordinate.fromList(it)
                }
            }
            132.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    CameraState.fromList(it)
                }
            }
            133.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    CoordinateBounds.fromList(it)
                }
            }
            else -> super.readValueOfType(type, buffer)
        }
    }
    override fun writeValue(stream: ByteArrayOutputStream, value: Any?) {
        when (value) {
            is CameraOptions -> {
                stream.write(128)
                writeValue(stream, value.toList())
            }
            is MapAnimationOptions -> {
                stream.write(129)
                writeValue(stream, value.toList())
            }
            is MbxEdgeInsets -> {
                stream.write(130)
                writeValue(stream, value.toList())
            }
            is ScreenCoordinate -> {
                stream.write(131)
                writeValue(stream, value.toList())
            }
            is CameraState -> {
                stream.write(132)
                writeValue(stream, value.toList())
            }
            is CoordinateBounds -> {
                stream.write(133)
                writeValue(stream, value.toList())
            }
            else -> super.writeValue(stream, value)
        }
    }
}