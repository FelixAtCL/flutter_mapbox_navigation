#import "StyleCodec.h"

#if TARGET_OS_OSX
#import <FlutterMacOS/FlutterMacOS.h>
#else
#import <Flutter/Flutter.h>
#endif

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

@interface FLT_StyleCodecReader : FlutterStandardReader
@end
@implementation FLT_StyleCodecReader
- (nullable id)readValueOfType:(UInt8)type {
  switch (type) {
    case 128: 
      return [FLTCameraBounds fromList:[self readValue]];
    case 129: 
      return [FLTCameraBoundsOptions fromList:[self readValue]];
    case 130: 
      return [FLTCameraOptions fromList:[self readValue]];
    case 131: 
      return [FLTCameraState fromList:[self readValue]];
    case 132: 
      return [FLTCanonicalTileID fromList:[self readValue]];
    case 133: 
      return [FLTCoordinateBounds fromList:[self readValue]];
    case 134: 
      return [FLTCoordinateBoundsZoom fromList:[self readValue]];
    case 135: 
      return [FLTFeatureExtensionValue fromList:[self readValue]];
    case 136: 
      return [FLTGlyphsRasterizationOptions fromList:[self readValue]];
    case 137: 
      return [FLTImageContent fromList:[self readValue]];
    case 138: 
      return [FLTImageStretches fromList:[self readValue]];
    case 139: 
      return [FLTLayerPosition fromList:[self readValue]];
    case 140: 
      return [FLTMapAnimationOptions fromList:[self readValue]];
    case 141: 
      return [FLTMapDebugOptions fromList:[self readValue]];
    case 142: 
      return [FLTMapMemoryBudgetInMegabytes fromList:[self readValue]];
    case 143: 
      return [FLTMapMemoryBudgetInTiles fromList:[self readValue]];
    case 144: 
      return [FLTMapOptions fromList:[self readValue]];
    case 145: 
      return [FLTMbxEdgeInsets fromList:[self readValue]];
    case 146: 
      return [FLTMbxImage fromList:[self readValue]];
    case 147: 
      return [FLTMercatorCoordinate fromList:[self readValue]];
    case 148: 
      return [FLTOfflineRegionGeometryDefinition fromList:[self readValue]];
    case 149: 
      return [FLTOfflineRegionTilePyramidDefinition fromList:[self readValue]];
    case 150: 
      return [FLTProjectedMeters fromList:[self readValue]];
    case 151: 
      return [FLTQueriedFeature fromList:[self readValue]];
    case 152: 
      return [FLTRenderedQueryGeometry fromList:[self readValue]];
    case 153: 
      return [FLTRenderedQueryOptions fromList:[self readValue]];
    case 154: 
      return [FLTResourceOptions fromList:[self readValue]];
    case 155: 
      return [FLTScreenBox fromList:[self readValue]];
    case 156: 
      return [FLTScreenCoordinate fromList:[self readValue]];
    case 157: 
      return [FLTSize fromList:[self readValue]];
    case 158: 
      return [FLTSourceQueryOptions fromList:[self readValue]];
    case 159: 
      return [FLTStyleObjectInfo fromList:[self readValue]];
    case 160: 
      return [FLTStylePropertyValue fromList:[self readValue]];
    case 161: 
      return [FLTTransitionOptions fromList:[self readValue]];
    default:
      return [super readValueOfType:type];
  }
}
@end

@interface FLT_StyleCodecWriter : FlutterStandardWriter
@end
@implementation FLT_StyleCodecWriter
- (void)writeValue:(id)value {
  if ([value isKindOfClass:[FLTCameraBounds class]]) {
    [self writeByte:128];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTCameraBoundsOptions class]]) {
    [self writeByte:129];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTCameraOptions class]]) {
    [self writeByte:130];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTCameraState class]]) {
    [self writeByte:131];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTCanonicalTileID class]]) {
    [self writeByte:132];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTCoordinateBounds class]]) {
    [self writeByte:133];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTCoordinateBoundsZoom class]]) {
    [self writeByte:134];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTFeatureExtensionValue class]]) {
    [self writeByte:135];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTGlyphsRasterizationOptions class]]) {
    [self writeByte:136];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTImageContent class]]) {
    [self writeByte:137];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTImageStretches class]]) {
    [self writeByte:138];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTLayerPosition class]]) {
    [self writeByte:139];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTMapAnimationOptions class]]) {
    [self writeByte:140];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTMapDebugOptions class]]) {
    [self writeByte:141];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTMapMemoryBudgetInMegabytes class]]) {
    [self writeByte:142];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTMapMemoryBudgetInTiles class]]) {
    [self writeByte:143];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTMapOptions class]]) {
    [self writeByte:144];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTMbxEdgeInsets class]]) {
    [self writeByte:145];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTMbxImage class]]) {
    [self writeByte:146];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTMercatorCoordinate class]]) {
    [self writeByte:147];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTOfflineRegionGeometryDefinition class]]) {
    [self writeByte:148];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTOfflineRegionTilePyramidDefinition class]]) {
    [self writeByte:149];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTProjectedMeters class]]) {
    [self writeByte:150];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTQueriedFeature class]]) {
    [self writeByte:151];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTRenderedQueryGeometry class]]) {
    [self writeByte:152];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTRenderedQueryOptions class]]) {
    [self writeByte:153];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTResourceOptions class]]) {
    [self writeByte:154];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTScreenBox class]]) {
    [self writeByte:155];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTScreenCoordinate class]]) {
    [self writeByte:156];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTSize class]]) {
    [self writeByte:157];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTSourceQueryOptions class]]) {
    [self writeByte:158];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTStyleObjectInfo class]]) {
    [self writeByte:159];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTStylePropertyValue class]]) {
    [self writeByte:160];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[FLTTransitionOptions class]]) {
    [self writeByte:161];
    [self writeValue:[value toList]];
  } else {
    [super writeValue:value];
  }
}
@end

@interface FLT_StyleCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation FLT_StyleCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[FLT_StyleCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[FLT_StyleCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMethodCodec> *FLT_StyleGetCodec(void) {
  static FlutterStandardMethodCodec *sSharedObject = nil;
  static dispatch_once_t sPred = 0;
  dispatch_once(&sPred, ^{
    FLT_StyleCodecReaderWriter *readerWriter = [[FLT_StyleCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMethodCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}
