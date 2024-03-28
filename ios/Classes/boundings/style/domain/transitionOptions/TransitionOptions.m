#import "TransitionOptions.h"

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

@interface FLTTransitionOptions ()
+ (FLTTransitionOptions *)fromList:(NSArray *)list;
+ (nullable FLTTransitionOptions *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end


@implementation FLTTransitionOptions
+ (instancetype)makeWithDuration:(nullable NSNumber *)duration
    delay:(nullable NSNumber *)delay
    enablePlacementTransitions:(nullable NSNumber *)enablePlacementTransitions {
  FLTTransitionOptions* pigeonResult = [[FLTTransitionOptions alloc] init];
  pigeonResult.duration = duration;
  pigeonResult.delay = delay;
  pigeonResult.enablePlacementTransitions = enablePlacementTransitions;
  return pigeonResult;
}
+ (FLTTransitionOptions *)fromList:(NSArray *)list {
  FLTTransitionOptions *pigeonResult = [[FLTTransitionOptions alloc] init];
  pigeonResult.duration = GetNullableObjectAtIndex(list, 0);
  pigeonResult.delay = GetNullableObjectAtIndex(list, 1);
  pigeonResult.enablePlacementTransitions = GetNullableObjectAtIndex(list, 2);
  return pigeonResult;
}
+ (nullable FLTTransitionOptions *)nullableFromList:(NSArray *)list {
  return (list) ? [FLTTransitionOptions fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.duration ?: [NSNull null]),
    (self.delay ?: [NSNull null]),
    (self.enablePlacementTransitions ?: [NSNull null]),
  ];
}
@end