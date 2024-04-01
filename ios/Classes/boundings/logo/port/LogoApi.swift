import Flutter
import Foundation
import UIKit
import MapboxMaps
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation

public class LogoAPI: NSObject, FlutterStreamHandler 
{
    var _eventSink: FlutterEventSink? = nil
    private var mapView: MapView

    let messenger: FlutterBinaryMessenger
    let channel: FlutterMethodChannel
    let eventChannel: FlutterEventChannel

    init(messenger: FlutterBinaryMessenger, withMapView mapView: MapView, viewId: Int64) {
        self.mapView = mapView
        
        self.messenger = messenger
        self.channel = FlutterMethodChannel(name: "flutter_mapbox_navigation/logo/\(viewId)", binaryMessenger: messenger, codec: FLT_SETTINGSLogoSettingsInterfaceGetCodec())
        self.eventChannel = FlutterEventChannel(name: "flutter_mapbox_navigation/logo/\(viewId)/events", binaryMessenger: messenger, codec: FLT_SETTINGSLogoSettingsInterfaceGetCodec())

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
        let options = self.mapView.ornaments.options.logo
        let position = self.getFLT_SETTINGSOrnamentPosition(position: options.position)
        let settings = FLT_SETTINGSLogoSettings.make(
            withPosition: .init(value: position),
            marginLeft: NSNumber(value: options.margins.x),
            marginTop: NSNumber(value: options.margins.y),
            marginRight: NSNumber(value: options.margins.x),
            marginBottom: NSNumber(value: options.margins.y)
        )
        result(settings)
    }

    func updateSettings(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let settings = arguments?["settings"] as? FLT_SETTINGSLogoSettings else {return}
        do {
            var logo = self.mapView.ornaments.options.logo
            switch settings.position?.value {
                case .BOTTOM_LEFT, .none:
                    logo.position = .bottomLeading
                    logo.margins = CGPoint(x: settings.marginLeft?.CGFloat ?? 0.0, y: settings.marginBottom?.CGFloat ?? 0.0)
                case .BOTTOM_RIGHT:
                    logo.position = .bottomTrailing
                    logo.margins = CGPoint(x: settings.marginRight?.CGFloat ?? 0.0, y: settings.marginBottom?.CGFloat ?? 0.0)
                case .TOP_LEFT:
                    logo.position = .topLeading
                    logo.margins = CGPoint(x: settings.marginLeft?.CGFloat ?? 0.0, y: settings.marginTop?.CGFloat ?? 0.0)
                case .TOP_RIGHT:
                    logo.position = .topTrailing
                    logo.margins = CGPoint(x: settings.marginRight?.CGFloat ?? 0.0, y: settings.marginTop?.CGFloat ?? 0.0)
            }
            self.mapView.ornaments.options.logo = logo
        } catch {
            result(FlutterError(code: LogoAPI.errorCode, message: "\(error)", details: nil))
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

    private static let errorCode = "logo"
}
