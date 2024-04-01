import Flutter
import Foundation
import UIKit
import MapboxMaps
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation

public class ScaleBarAPI : NSObject, FlutterStreamHandler 
{
    var _eventSink: FlutterEventSink? = nil
    private var mapView: MapView

    let messenger: FlutterBinaryMessenger
    let channel: FlutterMethodChannel
    let eventChannel: FlutterEventChannel

    init(messenger: FlutterBinaryMessenger, withMapView mapView: MapView, viewId: Int64) {
        self.mapView = mapView
        
        self.messenger = messenger
        self.channel = FlutterMethodChannel(name: "flutter_mapbox_navigation/scalebar/\(viewId)", binaryMessenger: messenger, codec: FLT_SETTINGSScaleBarSettingsInterfaceGetCodec())
        self.eventChannel = FlutterEventChannel(name: "flutter_mapbox_navigation/scalebar/\(viewId)/events", binaryMessenger: messenger, codec: FLT_SETTINGSScaleBarSettingsInterfaceGetCodec())

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
        let options = self.mapView.ornaments.options.scaleBar
        let position = self.getFLT_SETTINGSOrnamentPosition(position: options.position)

        let settings = FLT_SETTINGSScaleBarSettings.make(
            withEnabled: NSNumber(value: self.mapView.ornaments.options.scaleBar.visibility != OrnamentVisibility.hidden),
            position: .init(value: position),
            marginLeft: NSNumber(value: options.margins.x),
            marginTop: NSNumber(value: options.margins.y),
            marginRight: NSNumber(value: options.margins.x),
            marginBottom: NSNumber(value: options.margins.y),
            textColor: nil,
            primaryColor: nil,
            secondaryColor: nil,
            borderWidth: nil,
            height: nil,
            textBarMargin: nil,
            textBorderWidth: nil,
            textSize: nil,
            isMetricUnits: NSNumber(value: self.mapView.ornaments.options.scaleBar.useMetricUnits),
            refreshInterval: nil,
            showTextBorder: nil,
            ratio: nil,
            useContinuousRendering: nil)
            
        result(settings)
    }

    func updateSettings(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let settings = arguments?["settings"] as? FLT_SETTINGSScaleBarSettings else {return}
        do {
            var scaleBar = self.mapView.ornaments.options.scaleBar
            switch settings.position?.value {
            case .BOTTOM_LEFT:
                scaleBar.position = .bottomLeading
                scaleBar.margins = CGPoint(x: settings.marginLeft?.CGFloat ?? 0.0, y: settings.marginBottom?.CGFloat ?? 0.0)
            case .BOTTOM_RIGHT:
                scaleBar.position = .bottomTrailing
                scaleBar.margins = CGPoint(x: settings.marginRight?.CGFloat ?? 0.0, y: settings.marginBottom?.CGFloat ?? 0.0)
            case .TOP_LEFT, .none:
                scaleBar.position = .topLeading
                scaleBar.margins = CGPoint(x: settings.marginLeft?.CGFloat ?? 0.0, y: settings.marginTop?.CGFloat ?? 0.0)
            case .TOP_RIGHT:
                scaleBar.position = .topTrailing
                scaleBar.margins = CGPoint(x: settings.marginRight?.CGFloat ?? 0.0, y: settings.marginTop?.CGFloat ?? 0.0)
            }
            if let isMetric = settings.isMetricUnits?.boolValue {
                scaleBar.useMetricUnits = isMetric
            }
            if let visible = settings.enabled {
                scaleBar.visibility = visible.boolValue ? .adaptive : .hidden
            }

            self.mapView.ornaments.options.scaleBar = scaleBar
        } catch {
            result(FlutterError(code: ScaleBarAPI.errorCode, message: "\(error)", details: nil))
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

    private static let errorCode = "scalebar"
}
