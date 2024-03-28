#import "MbxEdgeInsets.h"

#if TARGET_OS_OSX
#import <FlutterMacOS/FlutterMacOS.h>
#else
#import <Flutter/Flutter.h>
#endif

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

@interface FLTMbxEdgeInsets ()
+ (FLTMbxEdgeInsets *)fromList:(NSArray *)list;
+ (nullable FLTMbxEdgeInsets *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@implementation FLTMbxEdgeInsets
+ (instancetype)makeWithTop:(NSNumber *)top
    left:(NSNumber *)left
    bottom:(NSNumber *)bottom
    right:(NSNumber *)right {
  FLTMbxEdgeInsets* pigeonResult = [[FLTMbxEdgeInsets alloc] init];
  pigeonResult.top = top;
  pigeonResult.left = left;
  pigeonResult.bottom = bottom;
  pigeonResult.right = right;
  return pigeonResult;
}
+ (FLTMbxEdgeInsets *)fromList:(NSArray *)list {
  FLTMbxEdgeInsets *pigeonResult = [[FLTMbxEdgeInsets alloc] init];
  pigeonResult.top = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.top != nil, @"");
  pigeonResult.left = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.left != nil, @"");
  pigeonResult.bottom = GetNullableObjectAtIndex(list, 2);
  NSAssert(pigeonResult.bottom != nil, @"");
  pigeonResult.right = GetNullableObjectAtIndex(list, 3);
  NSAssert(pigeonResult.right != nil, @"");
  return pigeonResult;
}
+ (nullable FLTMbxEdgeInsets *)nullableFromList:(NSArray *)list {
  return (list) ? [FLTMbxEdgeInsets fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.top ?: [NSNull null]),
    (self.left ?: [NSNull null]),
    (self.bottom ?: [NSNull null]),
    (self.right ?: [NSNull null]),
  ];
}
@end