import Flutter
import Foundation
import UIKit
import MapboxMaps
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation

public class CompassAPI: NSObject, FlutterStreamHandler 
{
    var _eventSink: FlutterEventSink? = nil
    private var mapView: MapView

    let messenger: FlutterBinaryMessenger
    let channel: FlutterMethodChannel
    let eventChannel: FlutterEventChannel

    init(messenger: FlutterBinaryMessenger, withMapView mapView: MapView, viewId: Int64) {
        self.mapView = mapView
        
        self.messenger = messenger
        self.channel = FlutterMethodChannel(name: "flutter_mapbox_navigation/compass/\(viewId)", binaryMessenger: messenger, codec: FLT_SETTINGSCompassSettingsInterfaceGetCodec())
        self.eventChannel = FlutterEventChannel(name: "flutter_mapbox_navigation/compass/\(viewId)/events", binaryMessenger: messenger, codec: FLT_SETTINGSCompassSettingsInterfaceGetCodec())

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
        let options = self.mapView.ornaments.options.compass
        let position = self.getFLT_SETTINGSOrnamentPosition(position: options.position)
        var topImage: FlutterStandardTypedData?
        if let topData = options.image?.pngData() {
            topImage = FlutterStandardTypedData(bytes: topData)
        }

        var visibility: NSNumber
        var fadeNorth: NSNumber
        switch options.visibility {
        case .adaptive:
            fadeNorth = true
            visibility = true
        case .hidden:
            fadeNorth = false
            visibility = false
        case .visible:
            fadeNorth = false
            visibility = true
        }

        let settings = FLT_SETTINGSCompassSettings.make(
            withEnabled: true,
            position: .init(value: position),
            marginLeft: NSNumber(value: options.margins.x),
            marginTop: NSNumber(value: options.margins.y),
            marginRight: NSNumber(value: options.margins.x),
            marginBottom: NSNumber(value: options.margins.y),
            opacity: NSNumber(value: 0.0),
            rotation: NSNumber(value: 0.0),
            visibility: visibility,
            fadeWhenFacingNorth: fadeNorth,
            clickable: true,
            image: topImage
        )
        result(settings)
    }

    func updateSettings(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let settings = arguments?["settings"] as? FLT_SETTINGSCompassSettings else {return}
        do {
            var compass = self.mapView.ornaments.options.compass
            switch settings.position?.value {
            case .BOTTOM_LEFT:
                compass.position = .bottomLeading
                compass.margins = CGPoint(x: settings.marginLeft?.CGFloat ?? 0.0, y: settings.marginBottom?.CGFloat ?? 0.0)
            case .BOTTOM_RIGHT:
                compass.position = .bottomTrailing
                compass.margins = CGPoint(x: settings.marginRight?.CGFloat ?? 0.0, y: settings.marginBottom?.CGFloat ?? 0.0)
            case .TOP_LEFT:
                compass.position = .topLeading
                compass.margins = CGPoint(x: settings.marginLeft?.CGFloat ?? 0.0, y: settings.marginTop?.CGFloat ?? 0.0)
            case .TOP_RIGHT, .none:
                compass.position = .topTrailing
                compass.margins = CGPoint(x: settings.marginRight?.CGFloat ?? 0.0, y: settings.marginTop?.CGFloat ?? 0.0)
            }

            if let data = settings.image?.data {
                compass.image = UIImage(data: data, scale: UIScreen.main.scale)
            }

            if let visible = settings.enabled?.boolValue {
                let fadeWhenFacingNorth = settings.fadeWhenFacingNorth?.boolValue ?? true

                let visibility: OrnamentVisibility
                switch (visible, fadeWhenFacingNorth) {
                case (true, true): visibility = .adaptive
                case (true, false): visibility = .visible
                case (false, _): visibility = .hidden
                }

                compass.visibility = visibility
            }

            self.mapView.ornaments.options.compass = compass
            result(nil)
        } catch {
            result(FlutterError(code: CompassAPI.errorCode, message: "\(error)", details: nil))
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

    private static let errorCode = "compass"
}
