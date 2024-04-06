package com.eopeter.fluttermapboxnavigation.boundings.camera.application

import com.eopeter.fluttermapboxnavigation.boundings.camera.domain.*
import com.eopeter.fluttermapboxnavigation.core.*
import com.mapbox.geojson.Point
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

@Suppress("UNCHECKED_CAST")
object CameraApiCodec : StandardMessageCodec() {
    override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
        return when (type) {
            132.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    CameraState.fromList(it)
                }
            }
            151.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    PointDecoder.fromList(it)
                }
            }
            else -> super.readValueOfType(type, buffer)
        }
    }
    override fun writeValue(stream: ByteArrayOutputStream, value: Any?) {
        when (value) {
            is CameraState -> {
                stream.write(132)
                writeValue(stream, value.toList())
            }
            is Point -> {
                stream.write(151)
                writeValue(stream, value.toList())
            }
            else -> super.writeValue(stream, value)
        }
    }
}