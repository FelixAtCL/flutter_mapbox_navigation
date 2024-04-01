part of mapbox_navigation_flutter;

class CompassAPICodec extends StandardMessageCodec {
  const CompassAPICodec() : super();

  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CompassSettings) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    if (type == 128) {
      return CompassSettings.decode(readValue(buffer)!);
    } else {
      return super.readValueOfType(type, buffer);
    }
  }
}
