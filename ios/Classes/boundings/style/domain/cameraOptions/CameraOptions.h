// Autogenerated from Pigeon (v11.0.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import <Foundation/Foundation.h>
#import <flutter_mapbox_navigation/ScreenCoordinate.h>
#import <flutter_mapbox_navigation/MbxEdgeInsets.h>

@protocol FlutterBinaryMessenger;
@protocol FlutterMethodCodec;
@class FLTScreenCoordinate;
@class FLTMbxEdgeInsets;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

@class FLTCameraOptions;

/// Various options for describing the viewpoint of a camera. All fields are
/// optional.
///
/// Anchor and center points are mutually exclusive, with preference for the
/// center point when both are set.
@interface FLTCameraOptions : NSObject
+ (instancetype)makeWithCenter:(nullable NSDictionary<NSString *, id> *)center
                       padding:(nullable FLTMbxEdgeInsets *)padding
                        anchor:(nullable FLTScreenCoordinate *)anchor
                          zoom:(nullable NSNumber *)zoom
                       bearing:(nullable NSNumber *)bearing
                         pitch:(nullable NSNumber *)pitch;
/// Coordinate at the center of the camera.
@property(nonatomic, strong, nullable) NSDictionary<NSString *, id> *center;
/// Padding around the interior of the view that affects the frame of
/// reference for `center`.
@property(nonatomic, strong, nullable) FLTMbxEdgeInsets *padding;
/// Point of reference for `zoom` and `angle`, assuming an origin at the
/// top-left corner of the view.
@property(nonatomic, strong, nullable) FLTScreenCoordinate *anchor;
/// Zero-based zoom level. Constrained to the minimum and maximum zoom
/// levels.
@property(nonatomic, strong, nullable) NSNumber *zoom;
/// Bearing, measured in degrees from true north. Wrapped to [0, 360).
@property(nonatomic, strong, nullable) NSNumber *bearing;
/// Pitch toward the horizon measured in degrees.
@property(nonatomic, strong, nullable) NSNumber *pitch;
@end

NS_ASSUME_NONNULL_END