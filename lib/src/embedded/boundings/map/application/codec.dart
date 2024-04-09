part of mapbox_navigation_flutter;

class MapAPICodec extends StandardMessageCodec {
  const MapAPICodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is QueriedFeature) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is RenderedQueryGeometry) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is RenderedQueryOptions) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is ScreenCoordinate) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return QueriedFeature.decode(readValue(buffer)!);
      case 129:
        return RenderedQueryGeometry.decode(readValue(buffer)!);
      case 130:
        return RenderedQueryOptions.decode(readValue(buffer)!);
      case 131:
        return ScreenCoordinate.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}
