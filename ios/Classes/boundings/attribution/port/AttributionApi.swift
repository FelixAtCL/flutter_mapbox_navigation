import Flutter
import Foundation
import UIKit
import MapboxMaps
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation

public class AttributionAPI: NSObject, FlutterStreamHandler 
{
    var _eventSink: FlutterEventSink? = nil
    private var mapView: MapView

    let messenger: FlutterBinaryMessenger
    let channel: FlutterMethodChannel
    let eventChannel: FlutterEventChannel

    init(messenger: FlutterBinaryMessenger, withMapView mapView: MapView, viewId: Int64) {
        self.mapView = mapView
        
        self.messenger = messenger
        self.channel = FlutterMethodChannel(name: "flutter_mapbox_navigation/attribution/\(viewId)", binaryMessenger: messenger, codec: FLT_SETTINGSAttributionSettingsInterfaceGetCodec())
        self.eventChannel = FlutterEventChannel(name: "flutter_mapbox_navigation/attribution/\(viewId)/events", binaryMessenger: messenger, codec: FLT_SETTINGSAttributionSettingsInterfaceGetCodec())

        super.init()

        self.eventChannel.setStreamHandler(self)

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
        let options = self.mapView.ornaments.options.attributionButton
        let position = self.getFLT_SETTINGSOrnamentPosition(position: options.position)
        let iconColor = self.mapView.ornaments.attributionButton.tintColor.rgb()

        let settings = FLT_SETTINGSAttributionSettings.make(
            withIconColor: NSNumber(value: iconColor),
            position: .init(value: position),
            marginLeft: NSNumber(value: options.margins.x),
            marginTop: NSNumber(value: options.margins.y),
            marginRight: NSNumber(value: options.margins.x),
            marginBottom: NSNumber(value: options.margins.y),
            clickable: nil)

        result(settings)
    }

    func updateSettings(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let settings = arguments?["settings"] as? FLT_SETTINGSAttributionSettings else {return}
        do {
            var attributionButton = self.mapView.ornaments.options.attributionButton
            switch settings.position?.value {
                case .BOTTOM_LEFT:
                    attributionButton.position = .bottomLeading
                    attributionButton.margins = CGPoint(x: settings.marginLeft?.CGFloat ?? 0.0, y: settings.marginBottom?.CGFloat ?? 0.0)
                case .BOTTOM_RIGHT, .none:
                    attributionButton.position = .bottomTrailing
                    attributionButton.margins = CGPoint(x: settings.marginRight?.CGFloat ?? 0.0, y: settings.marginBottom?.CGFloat ?? 0.0)
                case .TOP_LEFT:
                    attributionButton.position = .topLeading
                    attributionButton.margins = CGPoint(x: settings.marginLeft?.CGFloat ?? 0.0, y: settings.marginTop?.CGFloat ?? 0.0)
                case .TOP_RIGHT:
                    attributionButton.position = .topTrailing
                    attributionButton.margins = CGPoint(x: settings.marginRight?.CGFloat ?? 0.0, y: settings.marginTop?.CGFloat ?? 0.0)
            }

            self.mapView.ornaments.options.attributionButton = attributionButton

            if let iconColor = settings.iconColor?.intValue {
                self.mapView.ornaments.attributionButton.tintColor = uiColorFromHex(rgbValue: iconColor)
            }
            result(nil)
        } catch {
            result(FlutterError(code: AttributionAPI.errorCode, message: "\(error)", details: nil))
        }
    }

    private func getFLT_SETTINGSOrnamentPosition(position: OrnamentPosition) -> FLT_SETTINGSOrnamentPosition {
        switch position {
        case .bottomLeading:
            return .BOTTOM_LEFT
        case  .bottomTrailing:
            return .BOTTOM_RIGHT
        case .topLeading:
            return .TOP_LEFT
        default:
            return.TOP_RIGHT
        }
    }
    
    //MARK: EventListener Delegates
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        _eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _eventSink = nil
        return nil
    }

    private static let errorCode = "attribution"
}
