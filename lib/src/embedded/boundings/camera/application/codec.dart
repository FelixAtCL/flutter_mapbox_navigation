part of mapbox_navigation_flutter;

class CameraAPICodec extends StandardMessageCodec {
  const CameraAPICodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CameraOptions) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is MapAnimationOptions) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is MbxEdgeInsets) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is ScreenCoordinate) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else if (value is ScreenCoordinate) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else if (value is CameraState) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return CameraOptions.decode(readValue(buffer)!);
      case 129:
        return MapAnimationOptions.decode(readValue(buffer)!);
      case 130:
        return MbxEdgeInsets.decode(readValue(buffer)!);
      case 131:
        return ScreenCoordinate.decode(readValue(buffer)!);
      case 132:
        return ScreenCoordinate.decode(readValue(buffer)!);
      case 133:
        return CameraState.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}
