package com.eopeter.fluttermapboxnavigation.boundings.location.application

import com.eopeter.fluttermapboxnavigation.core.*
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

@Suppress("UNCHECKED_CAST")
object LocationApiCodec: StandardMessageCodec() {
    override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
        return when (type) {
            128.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    LocationComponentSettings.fromList(it)
                }
            }
            else -> super.readValueOfType(type, buffer)
        }
    }
    override fun writeValue(stream: ByteArrayOutputStream, value: Any?) {
        when (value) {
            is LocationComponentSettings -> {
                stream.write(128)
                writeValue(stream, value.toList())
            }
            else -> super.writeValue(stream, value)
        }
    }
}