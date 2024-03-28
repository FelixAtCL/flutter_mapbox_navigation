#import "ScreenCoordinate.h"

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

@implementation FLTScreenCoordinate
+ (instancetype)makeWithX:(NSNumber *)x
    y:(NSNumber *)y {
  FLTScreenCoordinate* pigeonResult = [[FLTScreenCoordinate alloc] init];
  pigeonResult.x = x;
  pigeonResult.y = y;
  return pigeonResult;
}
+ (FLTScreenCoordinate *)fromList:(NSArray *)list {
  FLTScreenCoordinate *pigeonResult = [[FLTScreenCoordinate alloc] init];
  pigeonResult.x = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.x != nil, @"");
  pigeonResult.y = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.y != nil, @"");
  return pigeonResult;
}
+ (nullable FLTScreenCoordinate *)nullableFromList:(NSArray *)list {
  return (list) ? [FLTScreenCoordinate fromList:list] : nil;
}
+ (NSArray *)toList {
  return @[
    (self.x ?: [NSNull null]),
    (self.y ?: [NSNull null]),
  ];
}
@end