part of mapbox_navigation_flutter;

class ScaleBarAPICodec extends StandardMessageCodec {
  const ScaleBarAPICodec() : super();

  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is ScaleBarSettings) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    if (type == 128) {
      return ScaleBarSettings.decode(readValue(buffer)!);
    } else {
      return super.readValueOfType(type, buffer);
    }
  }
}
