part of mapbox_navigation_flutter;

/// A custom codec for encoding and decoding messages related to the StyleManager class.
///
/// This codec extends the StandardMessageCodec class and provides the necessary
/// functionality to encode and decode messages specific to the StyleManager class.
class StyleAPICodec extends StandardMessageCodec {
  /// A codec for managing styles.
  ///
  /// This codec is responsible for managing the styles used in the application.
  /// It provides methods for encoding and decoding style data.
  const StyleAPICodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    try {
      if (value is CameraBounds) {
        buffer.putUint8(128);
        writeValue(buffer, value.encode());
      } else if (value is CameraBoundsOptions) {
        buffer.putUint8(129);
        writeValue(buffer, value.encode());
      } else if (value is CameraOptions) {
        buffer.putUint8(130);
        writeValue(buffer, value.encode());
      } else if (value is CameraState) {
        buffer.putUint8(131);
        writeValue(buffer, value.encode());
      } else if (value is CanonicalTileID) {
        buffer.putUint8(132);
        writeValue(buffer, value.encode());
      } else if (value is CoordinateBounds) {
        buffer.putUint8(133);
        writeValue(buffer, value.encode());
      } else if (value is CoordinateBoundsZoom) {
        buffer.putUint8(134);
        writeValue(buffer, value.encode());
      } else if (value is FeatureExtensionValue) {
        buffer.putUint8(135);
        writeValue(buffer, value.encode());
      } else if (value is GlyphsRasterizationOptions) {
        buffer.putUint8(136);
        writeValue(buffer, value.encode());
      } else if (value is ImageContent) {
        buffer.putUint8(137);
        writeValue(buffer, value.encode());
      } else if (value is ImageStretches) {
        buffer.putUint8(138);
        writeValue(buffer, value.encode());
      } else if (value is LayerPosition) {
        buffer.putUint8(139);
        writeValue(buffer, value.encode());
      } else if (value is MapAnimationOptions) {
        buffer.putUint8(140);
        writeValue(buffer, value.encode());
      } else if (value is MapDebugOptions) {
        buffer.putUint8(141);
        writeValue(buffer, value.encode());
      } else if (value is MapMemoryBudgetInMegabytes) {
        buffer.putUint8(142);
        writeValue(buffer, value.encode());
      } else if (value is MapMemoryBudgetInTiles) {
        buffer.putUint8(143);
        writeValue(buffer, value.encode());
      } else if (value is MapOptions) {
        buffer.putUint8(144);
        writeValue(buffer, value.encode());
      } else if (value is MbxEdgeInsets) {
        buffer.putUint8(145);
        writeValue(buffer, value.encode());
      } else if (value is MbxImage) {
        buffer.putUint8(146);
        writeValue(buffer, value.encode());
      } else if (value is MercatorCoordinate) {
        buffer.putUint8(147);
        writeValue(buffer, value.encode());
      } else if (value is OfflineRegionGeometryDefinition) {
        buffer.putUint8(148);
        writeValue(buffer, value.encode());
      } else if (value is OfflineRegionTilePyramidDefinition) {
        buffer.putUint8(149);
        writeValue(buffer, value.encode());
      } else if (value is ProjectedMeters) {
        buffer.putUint8(150);
        writeValue(buffer, value.encode());
      } else if (value is QueriedFeature) {
        buffer.putUint8(151);
        writeValue(buffer, value.encode());
      } else if (value is RenderedQueryGeometry) {
        buffer.putUint8(152);
        writeValue(buffer, value.encode());
      } else if (value is RenderedQueryOptions) {
        buffer.putUint8(153);
        writeValue(buffer, value.encode());
      } else if (value is ResourceOptions) {
        buffer.putUint8(154);
        writeValue(buffer, value.encode());
      } else if (value is ScreenBox) {
        buffer.putUint8(155);
        writeValue(buffer, value.encode());
      } else if (value is ScreenCoordinate) {
        buffer.putUint8(156);
        writeValue(buffer, value.encode());
      } else if (value is Size) {
        buffer.putUint8(157);
        writeValue(buffer, value.encode());
      } else if (value is SourceQueryOptions) {
        buffer.putUint8(158);
        writeValue(buffer, value.encode());
      } else if (value is StyleObjectInfo) {
        buffer.putUint8(159);
        writeValue(buffer, value.encode());
      } else if (value is StylePropertyValue) {
        buffer.putUint8(160);
        writeValue(buffer, value.encode());
      } else if (value is TransitionOptions) {
        buffer.putUint8(161);
        writeValue(buffer, value.encode());
      } else {
        super.writeValue(buffer, value);
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return CameraBounds.decode(readValue(buffer)!);
      case 129:
        return CameraBoundsOptions.decode(readValue(buffer)!);
      case 130:
        return CameraOptions.decode(readValue(buffer)!);
      case 131:
        return CameraState.decode(readValue(buffer)!);
      case 132:
        return CanonicalTileID.decode(readValue(buffer)!);
      case 133:
        return CoordinateBounds.decode(readValue(buffer)!);
      case 134:
        return CoordinateBoundsZoom.decode(readValue(buffer)!);
      case 135:
        return FeatureExtensionValue.decode(readValue(buffer)!);
      case 136:
        return GlyphsRasterizationOptions.decode(readValue(buffer)!);
      case 137:
        return ImageContent.decode(readValue(buffer)!);
      case 138:
        return ImageStretches.decode(readValue(buffer)!);
      case 139:
        return LayerPosition.decode(readValue(buffer)!);
      case 140:
        return MapAnimationOptions.decode(readValue(buffer)!);
      case 141:
        return MapDebugOptions.decode(readValue(buffer)!);
      case 142:
        return MapMemoryBudgetInMegabytes.decode(readValue(buffer)!);
      case 143:
        return MapMemoryBudgetInTiles.decode(readValue(buffer)!);
      case 144:
        return MapOptions.decode(readValue(buffer)!);
      case 145:
        return MbxEdgeInsets.decode(readValue(buffer)!);
      case 146:
        return MbxImage.decode(readValue(buffer)!);
      case 147:
        return MercatorCoordinate.decode(readValue(buffer)!);
      case 148:
        return OfflineRegionGeometryDefinition.decode(readValue(buffer)!);
      case 149:
        return OfflineRegionTilePyramidDefinition.decode(readValue(buffer)!);
      case 150:
        return ProjectedMeters.decode(readValue(buffer)!);
      case 151:
        return QueriedFeature.decode(readValue(buffer)!);
      case 152:
        return RenderedQueryGeometry.decode(readValue(buffer)!);
      case 153:
        return RenderedQueryOptions.decode(readValue(buffer)!);
      case 154:
        return ResourceOptions.decode(readValue(buffer)!);
      case 155:
        return ScreenBox.decode(readValue(buffer)!);
      case 156:
        return ScreenCoordinate.decode(readValue(buffer)!);
      case 157:
        return Size.decode(readValue(buffer)!);
      case 158:
        return SourceQueryOptions.decode(readValue(buffer)!);
      case 159:
        return StyleObjectInfo.decode(readValue(buffer)!);
      case 160:
        return StylePropertyValue.decode(readValue(buffer)!);
      case 161:
        return TransitionOptions.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}
