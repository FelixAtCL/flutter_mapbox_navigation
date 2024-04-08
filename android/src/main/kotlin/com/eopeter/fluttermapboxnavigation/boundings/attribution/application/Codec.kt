package com.eopeter.fluttermapboxnavigation.boundings.attribution.application

import com.eopeter.fluttermapboxnavigation.core.*
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

@Suppress("UNCHECKED_CAST")
object ApplicationApiCodec : StandardMessageCodec() {
    override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
        return when (type) {
            128.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    AttributionSettings.fromList(it)
                }
            }
            else -> super.readValueOfType(type, buffer)
        }
    }
    override fun writeValue(stream: ByteArrayOutputStream, value: Any?) {
        when (value) {
            is AttributionSettings -> {
                stream.write(128)
                writeValue(stream, value.toList())
            }
            else -> super.writeValue(stream, value)
        }
    }
}