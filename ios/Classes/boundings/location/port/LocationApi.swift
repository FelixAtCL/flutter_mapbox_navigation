import Flutter
import Foundation
import UIKit
import MapboxMaps
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation

public class LocationAPI: NSObject, LocationConsumer
{
    var _eventSink: FlutterEventSink? = nil
    private var mapView: MapView

    let messenger: FlutterBinaryMessenger
    let channel: FlutterMethodChannel

    init(messenger: FlutterBinaryMessenger, withMapView mapView: MapView, viewId: Int64) {
        self.mapView = mapView
        
        self.messenger = messenger
        self.channel = FlutterMethodChannel(name: "flutter_mapbox_navigation/location/\(viewId)", binaryMessenger: messenger, codec: FLT_SETTINGSLocationComponentSettingsInterfaceGetCodec())

        super.init()

        self.channel.setMethodCallHandler { [weak self](call, result) in

            guard let strongSelf = self else { return }

            let arguments = call.arguments as? NSDictionary

            if(call.method == "getSettings")
            {
                strongSelf.getSettings(arguments: arguments, result: result)
            } 
            else if (call.method == "updateSettings") 
            {
                strongSelf.updateSettings(arguments: arguments, result: result)
            }
            else
            {
                result("method is not implemented");
            }
        }
    }

    func getSettings(arguments: NSDictionary?, result: @escaping FlutterResult) {
        result(mapView.location.options.toFLT_SETTINGSLocationComponentSettings())
    }

    func updateSettings(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let settings = arguments?["settings"] as? FLT_SETTINGSLocationComponentSettings else {return}
        do {            
            mapView.location.options = mapView.location.options.fromFLT_SETTINGSLocationComponentSettings(settings: settings)
            result(nil)
        } catch {
            result(FlutterError(code: LocationAPI.errorCode, message: "\(error)", details: nil))
        }
    }

    // func listen() {
    //     mapView.location.addLocationConsumer(self)
    // }

    // func locationUpdate(location: Location) {
    //     self.channel.invokeMethod("onLocationUpdate", arguments: location.toDictionary())
    // }

    private static let errorCode = "location"
}

extension LocationOptions {
    func fromFLT_SETTINGSLocationComponentSettings(settings: FLT_SETTINGSLocationComponentSettings) -> LocationOptions {
        var options = LocationOptions()
        if let puckBearingEnabled = settings.puckBearingEnabled {
            options.puckBearingEnabled = puckBearingEnabled.boolValue
        }
        switch settings.puckBearingSource?.value {
        case .COURSE:
            options.puckBearingSource = .course
        default:
            options.puckBearingSource = .heading
        }
        if settings.enabled == false {
            options.puckType = nil
        } else {
            if let puck3D = settings.locationPuck?.locationPuck3D {
                var model = Model(uri: URL(string: puck3D.modelUri!))
                if let position = puck3D.position {
                    model.position = position.map({$0.doubleValue})
                }
                var configuration: Puck3DConfiguration = Puck3DConfiguration(
                    model: model
                )
                if let opacity = puck3D.modelOpacity {
                    configuration.modelOpacity = .constant(opacity.doubleValue)
                }
                if let scale = puck3D.modelScale {
                    configuration.modelScale = .constant(scale.map({$0.doubleValue}))
                }
                if let scaleExpressionData = puck3D.modelScaleExpression?.data(using: .utf8) {
                    let decodedExpression = try! JSONDecoder().decode(Expression.self, from: scaleExpressionData)
                    configuration.modelScale = .expression(decodedExpression)
                }
                if let rotation = puck3D.modelRotation {
                    configuration.modelRotation = .constant(rotation.map({$0.doubleValue}))
                }
                options.puckType = .puck3D(configuration)
            } else {
                var configuration: Puck2DConfiguration = { () -> Puck2DConfiguration in
                    if case .puck2D(let configuration) = self.puckType {
                        return configuration
                    } else {
                        return Puck2DConfiguration.makeDefault(showBearing: settings.puckBearingEnabled?.boolValue ?? false)
                    }
                }()
                if let bearingImage = settings.locationPuck?.locationPuck2D?.bearingImage {
                    configuration.bearingImage = UIImage(data: bearingImage.data, scale: UIScreen.main.scale)
                }
                if let shadowImage = settings.locationPuck?.locationPuck2D?.shadowImage {
                    configuration.shadowImage = UIImage(data: shadowImage.data, scale: UIScreen.main.scale)
                }
                if let topImage = settings.locationPuck?.locationPuck2D?.topImage {
                    configuration.topImage = UIImage(data: topImage.data, scale: UIScreen.main.scale)
                }
                if let scaleExpressionData = settings.locationPuck?.locationPuck2D?.scaleExpression?.data(using: .utf8) {
                    let decodedExpression = try! JSONDecoder().decode(Expression.self, from: scaleExpressionData)
                    configuration.scale = .expression(decodedExpression)
                }
                if let color = settings.accuracyRingColor {
                    configuration.accuracyRingColor = uiColorFromHex(rgbValue: color.intValue)
                }
                if let color = settings.accuracyRingBorderColor {
                    configuration.accuracyRingBorderColor = uiColorFromHex(rgbValue: color.intValue)
                }
                if let showAccuracyRing = settings.showAccuracyRing {
                    configuration.showsAccuracyRing = showAccuracyRing.boolValue
                }
                if settings.pulsingEnabled?.boolValue ?? false {
                    var pulsing = Puck2DConfiguration.Pulsing()

                    if let radius = settings.pulsingMaxRadius?.intValue {
                        // -1 indicates "accuracy" mode(from Android)
                        pulsing.radius = radius == -1 ? .accuracy : .constant(Double(radius))
                    }
                    if let color = settings.pulsingColor?.intValue {
                        pulsing.color = uiColorFromHex(rgbValue: color)
                    }
                    configuration.pulsing = pulsing
                }

                options.puckType = .puck2D(configuration)
            }
        }
        return options
    }

    func toFLT_SETTINGSLocationComponentSettings() -> FLT_SETTINGSLocationComponentSettings {
        var enabled: NSNumber?
        if self.puckType != nil {
            enabled = NSNumber(true)
        }
        let puckBearingEnabled = NSNumber(value: self.puckBearingEnabled)
        let puckBearingSource: FLT_SETTINGSPuckBearingSource = self.puckBearingSource == .heading ?
            .HEADING : .COURSE
        var accuracyRingColor: NSNumber?
        var accuracyRingBorderColor: NSNumber?
        var showAccuracyRing: NSNumber?
        var pulsingEnabled: NSNumber?
        var pulsingRadius: NSNumber?
        var pulsingColor: NSNumber?
        let locationPuck2D = FLT_SETTINGSLocationPuck2D.init()
        let locationPuck3D = FLT_SETTINGSLocationPuck3D.init()
        let locationPuck = FLT_SETTINGSLocationPuck.make(with: locationPuck2D, locationPuck3D: locationPuck3D)

        if case .puck2D(let oldConfiguration) = self.puckType {
            accuracyRingColor = NSNumber(value: oldConfiguration.accuracyRingColor.rgb())
            accuracyRingBorderColor = NSNumber(value: oldConfiguration.accuracyRingBorderColor.rgb())
            showAccuracyRing = NSNumber(value: oldConfiguration.showsAccuracyRing)
            if let topData = oldConfiguration.topImage?.pngData() {
                locationPuck2D.topImage = FlutterStandardTypedData(bytes: topData)
            }
            if let bearingData = oldConfiguration.bearingImage?.pngData() {
                locationPuck2D.bearingImage = FlutterStandardTypedData(bytes: bearingData)
            }
            if let shadowData = oldConfiguration.shadowImage?.pngData() {
                locationPuck2D.shadowImage = FlutterStandardTypedData(bytes: shadowData)
            }
            if case .expression(let scaleData) = oldConfiguration.scale {
                let encoded = try! JSONEncoder().encode(scaleData)
                locationPuck2D.scaleExpression = String(data: encoded, encoding: .utf8)
            }
            if let pulsing = oldConfiguration.pulsing {
                pulsingEnabled = NSNumber(value: true)
                switch pulsing.radius {
                case .accuracy:
                    pulsingRadius = NSNumber(value: -1)
                case .constant(let radius):
                    pulsingRadius = NSNumber(value: radius)
                }
                pulsingColor = NSNumber(value: pulsing.color.rgb())
            }
        }
        if case .puck3D(let oldConfiguration) = self.puckType {
            locationPuck3D.modelUri = oldConfiguration.model.uri?.absoluteString
            locationPuck3D.position = oldConfiguration.model.position?.map({NSNumber(value: $0)})
            if case .constant(let opacityData) = oldConfiguration.modelOpacity {
                locationPuck3D.modelOpacity = NSNumber(value: opacityData)
            }
            if case .constant(let scaleData) = oldConfiguration.modelScale {
                locationPuck3D.modelScale = scaleData.map({NSNumber(value: $0)})
            }
            if case .expression(let scaleExpression) = oldConfiguration.modelScale {
                let encoded = try! JSONEncoder().encode(scaleExpression)
                locationPuck3D.modelScaleExpression = String(data: encoded, encoding: .utf8)
            }
            if case .constant(let rotationData) = oldConfiguration.modelRotation {
                locationPuck3D.modelRotation = rotationData.map({NSNumber(value: $0)})
            }
        }

        return FLT_SETTINGSLocationComponentSettings.make(
            withEnabled: enabled,
            pulsingEnabled: pulsingEnabled,
            pulsingColor: pulsingColor,
            pulsingMaxRadius: pulsingRadius,
            showAccuracyRing: showAccuracyRing,
            accuracyRingColor: accuracyRingColor,
            accuracyRingBorderColor: accuracyRingBorderColor,
            layerAbove: nil,
            layerBelow: nil,
            puckBearingEnabled: puckBearingEnabled,
            puckBearingSource: .init(value: puckBearingSource),
            locationPuck: locationPuck
        )
    }
}
