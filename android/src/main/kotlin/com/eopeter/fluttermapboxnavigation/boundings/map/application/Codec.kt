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
                    QueriedFeature.fromList(it)
                }
            }
            129.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    RenderedQueryGeometry.fromList(it)
                }
            }
            130.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    RenderedQueryOptions.fromList(it)
                }
            }
            131.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    ScreenCoordinate.fromList(it)
                }
            }
            else -> super.readValueOfType(type, buffer)
        }
    }
    override fun writeValue(stream: ByteArrayOutputStream, value: Any?) {
        when (value) {
            is QueriedFeature -> {
                stream.write(128)
                writeValue(stream, value.toList())
            }
            is RenderedQueryGeometry -> {
                stream.write(129)
                writeValue(stream, value.toList())
            }
            is RenderedQueryOptions -> {
                stream.write(130)
                writeValue(stream, value.toList())
            }
            is ScreenCoordinate -> {
                stream.write(131)
                writeValue(stream, value.toList())
            }
            else -> super.writeValue(stream, value)
        }
    }
}