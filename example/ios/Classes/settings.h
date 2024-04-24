// Autogenerated from Pigeon (v11.0.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import <Foundation/Foundation.h>

@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@protocol FlutterMethodCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FLT_SETTINGSOrnamentPosition) {
  FLT_SETTINGSOrnamentPositionTOP_LEFT = 0,
  FLT_SETTINGSOrnamentPositionTOP_RIGHT = 1,
  FLT_SETTINGSOrnamentPositionBOTTOM_RIGHT = 2,
  FLT_SETTINGSOrnamentPositionBOTTOM_LEFT = 3,
};

/// Wrapper for FLT_SETTINGSOrnamentPosition to allow for nullability.
@interface FLT_SETTINGSOrnamentPositionBox : NSObject
@property(nonatomic, assign) FLT_SETTINGSOrnamentPosition value;
- (instancetype)initWithValue:(FLT_SETTINGSOrnamentPosition)value;
@end

/// Configures the directions in which the map is allowed to move during a scroll gesture.
typedef NS_ENUM(NSUInteger, FLT_SETTINGSScrollMode) {
  /// The map may only move horizontally.
  FLT_SETTINGSScrollModeHORIZONTAL = 0,
  /// The map may only move vertically.
  FLT_SETTINGSScrollModeVERTICAL = 1,
  /// The map may move both horizontally and vertically.
  FLT_SETTINGSScrollModeHORIZONTAL_AND_VERTICAL = 2,
};

/// Wrapper for FLT_SETTINGSScrollMode to allow for nullability.
@interface FLT_SETTINGSScrollModeBox : NSObject
@property(nonatomic, assign) FLT_SETTINGSScrollMode value;
- (instancetype)initWithValue:(FLT_SETTINGSScrollMode)value;
@end

/// The enum controls how the puck is oriented
typedef NS_ENUM(NSUInteger, FLT_SETTINGSPuckBearingSource) {
  /// Orients the puck to match the direction in which the device is facing.
  FLT_SETTINGSPuckBearingSourceHEADING = 0,
  /// Orients the puck to match the direction in which the device is moving.
  FLT_SETTINGSPuckBearingSourceCOURSE = 1,
};

/// Wrapper for FLT_SETTINGSPuckBearingSource to allow for nullability.
@interface FLT_SETTINGSPuckBearingSourceBox : NSObject
@property(nonatomic, assign) FLT_SETTINGSPuckBearingSource value;
- (instancetype)initWithValue:(FLT_SETTINGSPuckBearingSource)value;
@end

@class FLT_SETTINGSScreenCoordinate;
@class FLT_SETTINGSGesturesSettings;
@class FLT_SETTINGSLocationPuck2D;
@class FLT_SETTINGSLocationPuck3D;
@class FLT_SETTINGSLocationPuck;
@class FLT_SETTINGSLocationComponentSettings;
@class FLT_SETTINGSScaleBarSettings;
@class FLT_SETTINGSCompassSettings;
@class FLT_SETTINGSAttributionSettings;
@class FLT_SETTINGSLogoSettings;

/// Describes the coordinate on the screen, measured from top to bottom and from left to right.
/// Note: the `map` uses screen coordinate units measured in `platform pixels`.
@interface FLT_SETTINGSScreenCoordinate : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithX:(NSNumber *)x
                        y:(NSNumber *)y;
/// A value representing the x position of this coordinate.
@property(nonatomic, strong) NSNumber *x;
/// A value representing the y position of this coordinate.
@property(nonatomic, strong) NSNumber *y;
@end

/// Gesture configuration allows to control the user touch interaction.
@interface FLT_SETTINGSGesturesSettings : NSObject
+ (instancetype)makeWithRotateEnabled:(nullable NSNumber *)rotateEnabled
                           pinchToZoomEnabled:(nullable NSNumber *)pinchToZoomEnabled
                                scrollEnabled:(nullable NSNumber *)scrollEnabled
      simultaneousRotateAndPinchToZoomEnabled:(nullable NSNumber *)simultaneousRotateAndPinchToZoomEnabled
                                 pitchEnabled:(nullable NSNumber *)pitchEnabled
                                   scrollMode:(nullable FLT_SETTINGSScrollModeBox *)scrollMode
                     doubleTapToZoomInEnabled:(nullable NSNumber *)doubleTapToZoomInEnabled
                  doubleTouchToZoomOutEnabled:(nullable NSNumber *)doubleTouchToZoomOutEnabled
                             quickZoomEnabled:(nullable NSNumber *)quickZoomEnabled
                                   focalPoint:(nullable FLT_SETTINGSScreenCoordinate *)focalPoint
               pinchToZoomDecelerationEnabled:(nullable NSNumber *)pinchToZoomDecelerationEnabled
                    rotateDecelerationEnabled:(nullable NSNumber *)rotateDecelerationEnabled
                    scrollDecelerationEnabled:(nullable NSNumber *)scrollDecelerationEnabled
    increaseRotateThresholdWhenPinchingToZoom:(nullable NSNumber *)increaseRotateThresholdWhenPinchingToZoom
     increasePinchToZoomThresholdWhenRotating:(nullable NSNumber *)increasePinchToZoomThresholdWhenRotating
                          zoomAnimationAmount:(nullable NSNumber *)zoomAnimationAmount
                              pinchPanEnabled:(nullable NSNumber *)pinchPanEnabled;
/// Whether the rotate gesture is enabled.
@property(nonatomic, strong, nullable) NSNumber *rotateEnabled;
/// Whether the pinch to zoom gesture is enabled.
@property(nonatomic, strong, nullable) NSNumber *pinchToZoomEnabled;
/// Whether the single-touch scroll gesture is enabled.
@property(nonatomic, strong, nullable) NSNumber *scrollEnabled;
/// Whether rotation is enabled for the pinch to zoom gesture.
@property(nonatomic, strong, nullable) NSNumber *simultaneousRotateAndPinchToZoomEnabled;
/// Whether the pitch gesture is enabled.
@property(nonatomic, strong, nullable) NSNumber *pitchEnabled;
/// Configures the directions in which the map is allowed to move during a scroll gesture.
@property(nonatomic, strong, nullable) FLT_SETTINGSScrollModeBox *scrollMode;
/// Whether double tapping the map with one touch results in a zoom-in animation.
@property(nonatomic, strong, nullable) NSNumber *doubleTapToZoomInEnabled;
/// Whether single tapping the map with two touches results in a zoom-out animation.
@property(nonatomic, strong, nullable) NSNumber *doubleTouchToZoomOutEnabled;
/// Whether the quick zoom gesture is enabled.
@property(nonatomic, strong, nullable) NSNumber *quickZoomEnabled;
/// By default, gestures rotate and zoom around the center of the gesture. Set this property to rotate and zoom around a fixed point instead.
@property(nonatomic, strong, nullable) FLT_SETTINGSScreenCoordinate *focalPoint;
/// Whether a deceleration animation following a pinch-to-zoom gesture is enabled. True by default.
@property(nonatomic, strong, nullable) NSNumber *pinchToZoomDecelerationEnabled;
/// Whether a deceleration animation following a rotate gesture is enabled. True by default.
@property(nonatomic, strong, nullable) NSNumber *rotateDecelerationEnabled;
/// Whether a deceleration animation following a scroll gesture is enabled. True by default.
@property(nonatomic, strong, nullable) NSNumber *scrollDecelerationEnabled;
/// Whether rotate threshold increases when pinching to zoom. true by default.
@property(nonatomic, strong, nullable) NSNumber *increaseRotateThresholdWhenPinchingToZoom;
/// Whether pinch to zoom threshold increases when rotating. true by default.
@property(nonatomic, strong, nullable) NSNumber *increasePinchToZoomThresholdWhenRotating;
/// The amount by which the zoom level increases or decreases during a double-tap-to-zoom-in or double-touch-to-zoom-out gesture. 1.0 by default. Must be positive.
@property(nonatomic, strong, nullable) NSNumber *zoomAnimationAmount;
/// Whether pan is enabled for the pinch gesture.
@property(nonatomic, strong, nullable) NSNumber *pinchPanEnabled;
@end

@interface FLT_SETTINGSLocationPuck2D : NSObject
+ (instancetype)makeWithTopImage:(nullable FlutterStandardTypedData *)topImage
                    bearingImage:(nullable FlutterStandardTypedData *)bearingImage
                     shadowImage:(nullable FlutterStandardTypedData *)shadowImage
                 scaleExpression:(nullable NSString *)scaleExpression;
/// Name of image in sprite to use as the top of the location indicator.
@property(nonatomic, strong, nullable) FlutterStandardTypedData *topImage;
/// Name of image in sprite to use as the middle of the location indicator.
@property(nonatomic, strong, nullable) FlutterStandardTypedData *bearingImage;
/// Name of image in sprite to use as the background of the location indicator.
@property(nonatomic, strong, nullable) FlutterStandardTypedData *shadowImage;
/// The scale expression of the images. If defined, it will be applied to all the three images.
@property(nonatomic, copy, nullable) NSString *scaleExpression;
@end

@interface FLT_SETTINGSLocationPuck3D : NSObject
+ (instancetype)makeWithModelUri:(nullable NSString *)modelUri
                        position:(nullable NSArray<NSNumber *> *)position
                    modelOpacity:(nullable NSNumber *)modelOpacity
                      modelScale:(nullable NSArray<NSNumber *> *)modelScale
            modelScaleExpression:(nullable NSString *)modelScaleExpression
                modelTranslation:(nullable NSArray<NSNumber *> *)modelTranslation
                   modelRotation:(nullable NSArray<NSNumber *> *)modelRotation;
/// An URL for the model file in gltf format.
@property(nonatomic, copy, nullable) NSString *modelUri;
/// The position of the model.
@property(nonatomic, strong, nullable) NSArray<NSNumber *> *position;
/// The opacity of the model.
@property(nonatomic, strong, nullable) NSNumber *modelOpacity;
/// The scale of the model.
@property(nonatomic, strong, nullable) NSArray<NSNumber *> *modelScale;
/// The scale expression of the model, which will overwrite the default scale expression that keeps the model size constant during zoom.
@property(nonatomic, copy, nullable) NSString *modelScaleExpression;
/// The translation of the model [lon, lat, z]
@property(nonatomic, strong, nullable) NSArray<NSNumber *> *modelTranslation;
/// The rotation of the model.
@property(nonatomic, strong, nullable) NSArray<NSNumber *> *modelRotation;
@end

/// Defines what the customised look of the location puck.
@interface FLT_SETTINGSLocationPuck : NSObject
+ (instancetype)makeWithLocationPuck2D:(nullable FLT_SETTINGSLocationPuck2D *)locationPuck2D
                        locationPuck3D:(nullable FLT_SETTINGSLocationPuck3D *)locationPuck3D;
@property(nonatomic, strong, nullable) FLT_SETTINGSLocationPuck2D *locationPuck2D;
@property(nonatomic, strong, nullable) FLT_SETTINGSLocationPuck3D *locationPuck3D;
@end

/// Shows a location puck on the map.
@interface FLT_SETTINGSLocationComponentSettings : NSObject
+ (instancetype)makeWithEnabled:(nullable NSNumber *)enabled
                 pulsingEnabled:(nullable NSNumber *)pulsingEnabled
                   pulsingColor:(nullable NSNumber *)pulsingColor
               pulsingMaxRadius:(nullable NSNumber *)pulsingMaxRadius
               showAccuracyRing:(nullable NSNumber *)showAccuracyRing
              accuracyRingColor:(nullable NSNumber *)accuracyRingColor
        accuracyRingBorderColor:(nullable NSNumber *)accuracyRingBorderColor
                     layerAbove:(nullable NSString *)layerAbove
                     layerBelow:(nullable NSString *)layerBelow
             puckBearingEnabled:(nullable NSNumber *)puckBearingEnabled
              puckBearingSource:(nullable FLT_SETTINGSPuckBearingSourceBox *)puckBearingSource
                   locationPuck:(nullable FLT_SETTINGSLocationPuck *)locationPuck;
/// Whether the user location is visible on the map.
@property(nonatomic, strong, nullable) NSNumber *enabled;
/// Whether the location puck is pulsing on the map. Works for 2D location puck only.
@property(nonatomic, strong, nullable) NSNumber *pulsingEnabled;
/// The color of the pulsing circle. Works for 2D location puck only.
@property(nonatomic, strong, nullable) NSNumber *pulsingColor;
/// The maximum radius of the pulsing circle. Works for 2D location puck only. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *pulsingMaxRadius;
/// Whether show accuracy ring with location puck. Works for 2D location puck only.
@property(nonatomic, strong, nullable) NSNumber *showAccuracyRing;
/// The color of the accuracy ring. Works for 2D location puck only.
@property(nonatomic, strong, nullable) NSNumber *accuracyRingColor;
/// The color of the accuracy ring border. Works for 2D location puck only.
@property(nonatomic, strong, nullable) NSNumber *accuracyRingBorderColor;
/// Sets the id of the layer that's added above to when placing the component on the map.
@property(nonatomic, copy, nullable) NSString *layerAbove;
/// Sets the id of the layer that's added below to when placing the component on the map.
@property(nonatomic, copy, nullable) NSString *layerBelow;
/// Whether the puck rotates to track the bearing source.
@property(nonatomic, strong, nullable) NSNumber *puckBearingEnabled;
/// The enum controls how the puck is oriented
@property(nonatomic, strong, nullable) FLT_SETTINGSPuckBearingSourceBox *puckBearingSource;
/// Defines what the customised look of the location puck.
@property(nonatomic, strong, nullable) FLT_SETTINGSLocationPuck *locationPuck;
@end

/// Shows the scale bar on the map.
@interface FLT_SETTINGSScaleBarSettings : NSObject
+ (instancetype)makeWithEnabled:(nullable NSNumber *)enabled
                       position:(nullable FLT_SETTINGSOrnamentPositionBox *)position
                     marginLeft:(nullable NSNumber *)marginLeft
                      marginTop:(nullable NSNumber *)marginTop
                    marginRight:(nullable NSNumber *)marginRight
                   marginBottom:(nullable NSNumber *)marginBottom
                      textColor:(nullable NSNumber *)textColor
                   primaryColor:(nullable NSNumber *)primaryColor
                 secondaryColor:(nullable NSNumber *)secondaryColor
                    borderWidth:(nullable NSNumber *)borderWidth
                         height:(nullable NSNumber *)height
                  textBarMargin:(nullable NSNumber *)textBarMargin
                textBorderWidth:(nullable NSNumber *)textBorderWidth
                       textSize:(nullable NSNumber *)textSize
                  isMetricUnits:(nullable NSNumber *)isMetricUnits
                refreshInterval:(nullable NSNumber *)refreshInterval
                 showTextBorder:(nullable NSNumber *)showTextBorder
                          ratio:(nullable NSNumber *)ratio
         useContinuousRendering:(nullable NSNumber *)useContinuousRendering;
/// Whether the scale is visible on the map.
@property(nonatomic, strong, nullable) NSNumber *enabled;
/// Defines where the scale bar is positioned on the map
@property(nonatomic, strong, nullable) FLT_SETTINGSOrnamentPositionBox *position;
/// Defines the margin to the left that the scale bar honors. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *marginLeft;
/// Defines the margin to the top that the scale bar honors. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *marginTop;
/// Defines the margin to the right that the scale bar honors. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *marginRight;
/// Defines the margin to the bottom that the scale bar honors. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *marginBottom;
/// Defines text color of the scale bar.
@property(nonatomic, strong, nullable) NSNumber *textColor;
/// Defines primary color of the scale bar.
@property(nonatomic, strong, nullable) NSNumber *primaryColor;
/// Defines secondary color of the scale bar.
@property(nonatomic, strong, nullable) NSNumber *secondaryColor;
/// Defines width of the border for the scale bar. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *borderWidth;
/// Defines height of the scale bar. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *height;
/// Defines margin of the text bar of the scale bar. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *textBarMargin;
/// Defines text border width of the scale bar. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *textBorderWidth;
/// Defines text size of the scale bar. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *textSize;
/// Whether the scale bar is using metric unit. True if the scale bar is using metric system, false if the scale bar is using imperial units.
@property(nonatomic, strong, nullable) NSNumber *isMetricUnits;
/// Configures minimum refresh interval, in millisecond, default is 15.
@property(nonatomic, strong, nullable) NSNumber *refreshInterval;
/// Configures whether to show the text border or not, default is true.
@property(nonatomic, strong, nullable) NSNumber *showTextBorder;
/// configures ratio of scale bar max width compared with MapView width, default is 0.5.
@property(nonatomic, strong, nullable) NSNumber *ratio;
/// If set to True scale bar will be triggering onDraw depending on [ScaleBarSettings.refreshInterval] even if actual data did not change. If set to False scale bar will redraw only on demand. Defaults to False and should not be changed explicitly in most cases. Could be set to True to produce correct GPU frame metrics when running gfxinfo command.
@property(nonatomic, strong, nullable) NSNumber *useContinuousRendering;
@end

/// Shows the compass on the map.
@interface FLT_SETTINGSCompassSettings : NSObject
+ (instancetype)makeWithEnabled:(nullable NSNumber *)enabled
                       position:(nullable FLT_SETTINGSOrnamentPositionBox *)position
                     marginLeft:(nullable NSNumber *)marginLeft
                      marginTop:(nullable NSNumber *)marginTop
                    marginRight:(nullable NSNumber *)marginRight
                   marginBottom:(nullable NSNumber *)marginBottom
                        opacity:(nullable NSNumber *)opacity
                       rotation:(nullable NSNumber *)rotation
                     visibility:(nullable NSNumber *)visibility
            fadeWhenFacingNorth:(nullable NSNumber *)fadeWhenFacingNorth
                      clickable:(nullable NSNumber *)clickable
                          image:(nullable FlutterStandardTypedData *)image;
/// Whether the compass is visible on the map.
@property(nonatomic, strong, nullable) NSNumber *enabled;
/// Defines where the compass is positioned on the map
@property(nonatomic, strong, nullable) FLT_SETTINGSOrnamentPositionBox *position;
/// Defines the margin to the left that the compass icon honors. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *marginLeft;
/// Defines the margin to the top that the compass icon honors. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *marginTop;
/// Defines the margin to the right that the compass icon honors. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *marginRight;
/// Defines the margin to the bottom that the compass icon honors. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *marginBottom;
/// The alpha channel value of the compass image
@property(nonatomic, strong, nullable) NSNumber *opacity;
/// The clockwise rotation value in degrees of the compass.
@property(nonatomic, strong, nullable) NSNumber *rotation;
/// Whether the compass is displayed.
@property(nonatomic, strong, nullable) NSNumber *visibility;
/// Whether the compass fades out to invisible when facing north direction.
@property(nonatomic, strong, nullable) NSNumber *fadeWhenFacingNorth;
/// Whether the compass can be clicked and click events can be registered.
@property(nonatomic, strong, nullable) NSNumber *clickable;
/// The compass image, the visual representation of the compass.
@property(nonatomic, strong, nullable) FlutterStandardTypedData *image;
@end

/// Shows the attribution icon on the map.
@interface FLT_SETTINGSAttributionSettings : NSObject
+ (instancetype)makeWithIconColor:(nullable NSNumber *)iconColor
                         position:(nullable FLT_SETTINGSOrnamentPositionBox *)position
                       marginLeft:(nullable NSNumber *)marginLeft
                        marginTop:(nullable NSNumber *)marginTop
                      marginRight:(nullable NSNumber *)marginRight
                     marginBottom:(nullable NSNumber *)marginBottom
                        clickable:(nullable NSNumber *)clickable;
/// Defines text color of the attribution icon.
@property(nonatomic, strong, nullable) NSNumber *iconColor;
/// Defines where the attribution icon is positioned on the map
@property(nonatomic, strong, nullable) FLT_SETTINGSOrnamentPositionBox *position;
/// Defines the margin to the left that the attribution icon honors. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *marginLeft;
/// Defines the margin to the top that the attribution icon honors. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *marginTop;
/// Defines the margin to the right that the attribution icon honors. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *marginRight;
/// Defines the margin to the bottom that the attribution icon honors. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *marginBottom;
/// Whether the attribution can be clicked and click events can be registered.
@property(nonatomic, strong, nullable) NSNumber *clickable;
@end

/// Shows the Mapbox logo on the map.
@interface FLT_SETTINGSLogoSettings : NSObject
+ (instancetype)makeWithPosition:(nullable FLT_SETTINGSOrnamentPositionBox *)position
                      marginLeft:(nullable NSNumber *)marginLeft
                       marginTop:(nullable NSNumber *)marginTop
                     marginRight:(nullable NSNumber *)marginRight
                    marginBottom:(nullable NSNumber *)marginBottom;
/// Defines where the logo is positioned on the map
@property(nonatomic, strong, nullable) FLT_SETTINGSOrnamentPositionBox *position;
/// Defines the margin to the left that the attribution icon honors. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *marginLeft;
/// Defines the margin to the top that the attribution icon honors. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *marginTop;
/// Defines the margin to the right that the attribution icon honors. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *marginRight;
/// Defines the margin to the bottom that the attribution icon honors. This property is specified in pixels.
@property(nonatomic, strong, nullable) NSNumber *marginBottom;
@end

/// The codec used by FLT_SETTINGSGesturesSettingsInterface.
NSObject<FlutterMessageCodec> *FLT_SETTINGSGesturesSettingsInterfaceGetCodec(void);

/// Gesture configuration allows to control the user touch interaction.
@protocol FLT_SETTINGSGesturesSettingsInterface
/// @return `nil` only when `error != nil`.
- (nullable FLT_SETTINGSGesturesSettings *)getSettingsWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)updateSettingsSettings:(FLT_SETTINGSGesturesSettings *)settings error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void FLT_SETTINGSGesturesSettingsInterfaceSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FLT_SETTINGSGesturesSettingsInterface> *_Nullable api);

/// The codec used by FLT_SETTINGSLocationComponentSettingsInterface.
NSObject<FlutterMethodCodec> *FLT_SETTINGSLocationComponentSettingsInterfaceGetCodec(void);

/// Shows a location puck on the map.
@protocol FLT_SETTINGSLocationComponentSettingsInterface
/// @return `nil` only when `error != nil`.
- (nullable FLT_SETTINGSLocationComponentSettings *)getSettingsWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)updateSettingsSettings:(FLT_SETTINGSLocationComponentSettings *)settings error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void FLT_SETTINGSLocationComponentSettingsInterfaceSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FLT_SETTINGSLocationComponentSettingsInterface> *_Nullable api);

/// The codec used by FLT_SETTINGSScaleBarSettingsInterface.
NSObject<FlutterMethodCodec> *FLT_SETTINGSScaleBarSettingsInterfaceGetCodec(void);

/// Shows the scale bar on the map.
@protocol FLT_SETTINGSScaleBarSettingsInterface
/// @return `nil` only when `error != nil`.
- (nullable FLT_SETTINGSScaleBarSettings *)getSettingsWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)updateSettingsSettings:(FLT_SETTINGSScaleBarSettings *)settings error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void FLT_SETTINGSScaleBarSettingsInterfaceSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FLT_SETTINGSScaleBarSettingsInterface> *_Nullable api);

/// The codec used by FLT_SETTINGSCompassSettingsInterface.
NSObject<FlutterMethodCodec> *FLT_SETTINGSCompassSettingsInterfaceGetCodec(void);

/// Shows the compass on the map.
@protocol FLT_SETTINGSCompassSettingsInterface
/// @return `nil` only when `error != nil`.
- (nullable FLT_SETTINGSCompassSettings *)getSettingsWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)updateSettingsSettings:(FLT_SETTINGSCompassSettings *)settings error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void FLT_SETTINGSCompassSettingsInterfaceSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FLT_SETTINGSCompassSettingsInterface> *_Nullable api);

/// The codec used by FLT_SETTINGSAttributionSettingsInterface.
NSObject<FlutterMethodCodec> *FLT_SETTINGSAttributionSettingsInterfaceGetCodec(void);

/// Shows the attribution icon on the map.
@protocol FLT_SETTINGSAttributionSettingsInterface
/// @return `nil` only when `error != nil`.
- (nullable FLT_SETTINGSAttributionSettings *)getSettingsWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)updateSettingsSettings:(FLT_SETTINGSAttributionSettings *)settings error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void FLT_SETTINGSAttributionSettingsInterfaceSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FLT_SETTINGSAttributionSettingsInterface> *_Nullable api);

/// The codec used by FLT_SETTINGSLogoSettingsInterface.
NSObject<FlutterMethodCodec> *FLT_SETTINGSLogoSettingsInterfaceGetCodec(void);

/// Shows the Mapbox logo on the map.
@protocol FLT_SETTINGSLogoSettingsInterface
/// @return `nil` only when `error != nil`.
- (nullable FLT_SETTINGSLogoSettings *)getSettingsWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)updateSettingsSettings:(FLT_SETTINGSLogoSettings *)settings error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void FLT_SETTINGSLogoSettingsInterfaceSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FLT_SETTINGSLogoSettingsInterface> *_Nullable api);

NS_ASSUME_NONNULL_END
