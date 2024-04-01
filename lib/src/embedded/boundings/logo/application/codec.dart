part of mapbox_navigation_flutter;

class LogoAPICodec extends StandardMessageCodec {
  const LogoAPICodec() : super();

  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is LogoSettings) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    if (type == 128) {
      return LogoSettings.decode(readValue(buffer)!);
    } else {
      return super.readValueOfType(type, buffer);
    }
  }
}
