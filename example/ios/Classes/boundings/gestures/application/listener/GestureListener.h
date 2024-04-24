// Autogenerated from Pigeon (v11.0.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import <Foundation/Foundation.h>

@protocol FlutterBinaryMessenger;
@protocol FlutterMethodCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

@class FLT_GESTURESScreenCoordinate;

/// Describes the coordinate on the screen, measured from top to bottom and from left to right.
/// Note: the `map` uses screen coordinate units measured in `logical pixels`.
@interface FLT_GESTURESScreenCoordinate : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithX:(NSNumber *)x
                        y:(NSNumber *)y;
/// A value representing the x position of this coordinate.
@property(nonatomic, strong) NSNumber *x;
/// A value representing the y position of this coordinate.
@property(nonatomic, strong) NSNumber *y;
@end

/// The codec used by FLT_GESTURESGestureListener.
NSObject<FlutterMethodCodec> *FLT_GESTURESGestureListenerGetCodec(void);

NS_ASSUME_NONNULL_END
