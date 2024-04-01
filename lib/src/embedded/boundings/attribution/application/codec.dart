part of mapbox_navigation_flutter;

class AttributionAPICodec extends StandardMessageCodec {
  const AttributionAPICodec() : super();

  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is AttributionSettings) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    if (type == 128) {
      return AttributionSettings.decode(readValue(buffer)!);
    } else {
      return super.readValueOfType(type, buffer);
    }
  }
}
