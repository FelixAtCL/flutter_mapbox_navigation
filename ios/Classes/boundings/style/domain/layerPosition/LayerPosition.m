#import "LayerPosition.h"

#if TARGET_OS_OSX
#import <FlutterMacOS/FlutterMacOS.h>
#else
#import <Flutter/Flutter.h>
#endif

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static id GetNullableObjectAtIndex(NSArray *array, NSInteger key) {
  id result = array[key];
  return (result == [NSNull null]) ? nil : result;
}

@interface FLTLayerPosition ()
+ (FLTLayerPosition *)fromList:(NSArray *)list;
+ (nullable FLTLayerPosition *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@implementation FLTLayerPosition
+ (instancetype)makeWithAbove:(nullable NSString *)above
    below:(nullable NSString *)below
    at:(nullable NSNumber *)at {
  FLTLayerPosition* pigeonResult = [[FLTLayerPosition alloc] init];
  pigeonResult.above = above;
  pigeonResult.below = below;
  pigeonResult.at = at;
  return pigeonResult;
}
+ (FLTLayerPosition *)fromList:(NSArray *)list {
  FLTLayerPosition *pigeonResult = [[FLTLayerPosition alloc] init];
  pigeonResult.above = GetNullableObjectAtIndex(list, 0);
  pigeonResult.below = GetNullableObjectAtIndex(list, 1);
  pigeonResult.at = GetNullableObjectAtIndex(list, 2);
  return pigeonResult;
}
+ (nullable FLTLayerPosition *)nullableFromList:(NSArray *)list {
  return (list) ? [FLTLayerPosition fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.above ?: [NSNull null]),
    (self.below ?: [NSNull null]),
    (self.at ?: [NSNull null]),
  ];
}
@end