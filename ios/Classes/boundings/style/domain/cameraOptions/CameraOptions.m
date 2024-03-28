#import "CameraOptions.h"

#if TARGET_OS_OSX
#import <FlutterMacOS/FlutterMacOS.h>
#else
#import <Flutter/Flutter.h>
#endif

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

@interface FLTCameraOptions ()
+ (FLTCameraOptions *)fromList:(NSArray *)list;
+ (nullable FLTCameraOptions *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@implementation FLTCameraOptions
+ (instancetype)makeWithCenter:(nullable NSDictionary<NSString *, id> *)center
    padding:(nullable FLTMbxEdgeInsets *)padding
    anchor:(nullable FLTScreenCoordinate *)anchor
    zoom:(nullable NSNumber *)zoom
    bearing:(nullable NSNumber *)bearing
    pitch:(nullable NSNumber *)pitch {
  FLTCameraOptions* pigeonResult = [[FLTCameraOptions alloc] init];
  pigeonResult.center = center;
  pigeonResult.padding = padding;
  pigeonResult.anchor = anchor;
  pigeonResult.zoom = zoom;
  pigeonResult.bearing = bearing;
  pigeonResult.pitch = pitch;
  return pigeonResult;
}
+ (FLTCameraOptions *)fromList:(NSArray *)list {
  FLTCameraOptions *pigeonResult = [[FLTCameraOptions alloc] init];
  pigeonResult.center = GetNullableObjectAtIndex(list, 0);
  pigeonResult.padding = [FLTMbxEdgeInsets nullableFromList:(GetNullableObjectAtIndex(list, 1))];
  pigeonResult.anchor = [FLTScreenCoordinate nullableFromList:(GetNullableObjectAtIndex(list, 2))];
  pigeonResult.zoom = GetNullableObjectAtIndex(list, 3);
  pigeonResult.bearing = GetNullableObjectAtIndex(list, 4);
  pigeonResult.pitch = GetNullableObjectAtIndex(list, 5);
  return pigeonResult;
}
+ (nullable FLTCameraOptions *)nullableFromList:(NSArray *)list {
  return (list) ? [FLTCameraOptions fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.center ?: [NSNull null]),
    (self.padding ? [self.padding toList] : [NSNull null]),
    (self.anchor ? [self.anchor toList] : [NSNull null]),
    (self.zoom ?: [NSNull null]),
    (self.bearing ?: [NSNull null]),
    (self.pitch ?: [NSNull null]),
  ];
}
@end