part of mapbox_navigation_flutter;

class GestureAPICodec extends StandardMessageCodec {
  const GestureAPICodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is ScreenCoordinate) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return ScreenCoordinate.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}
