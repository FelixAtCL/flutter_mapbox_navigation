import Flutter
import Foundation
import UIKit
import MapboxMaps
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation

public class CameraAPI: NSObject, FlutterStreamHandler 
{
    var _eventSink: FlutterEventSink? = nil
    private var mapboxMap: MapboxMap
    private var cancelable: Cancelable?

    let messenger: FlutterBinaryMessenger
    let channel: FlutterMethodChannel
    let eventChannel: FlutterEventChannel

    init(messenger: FlutterBinaryMessenger, withMapboxMap mapboxMap: MapboxMap, viewId: Int64) {
        self.mapboxMap = mapboxMap
        
        self.messenger = messenger
        self.channel = FlutterMethodChannel(name: "flutter_mapbox_navigation/camera/\(viewId)", binaryMessenger: messenger, codec: FLT_AnimationManagerGetCodec())
        self.eventChannel = FlutterEventChannel(name: "flutter_mapbox_navigation/camera/\(viewId)/events", binaryMessenger: messenger, codec: FLT_AnimationManagerGetCodec())

        super.init()

        self.eventChannel.setStreamHandler(self)

        self.channel.setMethodCallHandler { [weak self](call, result) in

            guard let strongSelf = self else { return }

            let arguments = call.arguments as? NSDictionary

            if(call.method == "easeTo") 
            {
                strongSelf.easeTo(arguments: arguments, result: result)
            } 
            else if (call.method == "flyTo") 
            {
                strongSelf.flyTo(arguments: arguments, result: result)
            }
            else if (call.method == "pitchBy") 
            {
                strongSelf.pitchBy(arguments: arguments, result: result)
            }
            else if (call.method == "scaleBy") 
            {
                strongSelf.scaleBy(arguments: arguments, result: result)
            }
            else if (call.method == "moveBy") 
            {
                strongSelf.moveBy(arguments: arguments, result: result)
            }
            else if (call.method == "rotateBy") 
            {
                strongSelf.rotateBy(arguments: arguments, result: result)
            }
            else if (call.method == "cancelCameraAnimation") 
            {
                strongSelf.cancelCameraAnimation(arguments: arguments, result: result)
            }
            else 
            {
                result("method is not implemented");
            }
        }
    }

    func easeTo(arguments: NSDictionary?, result: @escaping FlutterResult) {
        do {
            guard let cameraOptions = arguments?["cameraoptions"] as? FLTCameraOptions else {return}
            var mapAnimationOptions = arguments?["animationoptions"] as? FLTMapAnimationOptions ?? nil
            var cameraDuration = 1.0
            if mapAnimationOptions != nil && mapAnimationOptions!.duration != nil {
                cameraDuration = mapAnimationOptions!.duration!.doubleValue / 1000
            }
            cancelable = self.mapView.camera.ease(to: cameraOptions.toCameraOptions(), duration: cameraDuration)
            result(nil)
        } catch {
            result(FlutterError(code: "\(error)", message: nil, details: nil))
        }
    }

    func flyTo(arguments: NSDictionary?, result: @escaping FlutterResult) {
        do {
            guard let cameraOptions = arguments?["cameraoptions"] as? FLTCameraOptions else {return}
            var mapAnimationOptions = arguments?["animationoptions"] as? FLTMapAnimationOptions ?? nil
            var cameraDuration = 1.0
            if mapAnimationOptions != nil && mapAnimationOptions!.duration != nil {
                cameraDuration = mapAnimationOptions!.duration!.doubleValue / 1000
            }
            cancelable = self.mapView.camera.fly(to: cameraOptions.toCameraOptions(), duration: cameraDuration)
            result(nil) 
        } catch {
            result(FlutterError(code: CameraAPI.errorCode, message: nil, details: nil))
        }
    }

    func pitch(arguments: NSDictionary?, result: @escaping FlutterResult) {
        result(FlutterError(code: CameraAPI.errorCode, message: "Not available.", details: nil))
    }

    func scale(arguments: NSDictionary?, result: @escaping FlutterResult) {
        result(FlutterError(code: CameraAPI.errorCode, message: "Not available.", details: nil))
    }

    func move(arguments: NSDictionary?, result: @escaping FlutterResult) {
        result(FlutterError(code: CameraAPI.errorCode, message: "Not available.", details: nil))
    }

    func rotate(arguments: NSDictionary?, result: @escaping FlutterResult) {
        result(FlutterError(code: CameraAPI.errorCode, message: "Not available.", details: nil))
    }

    func cancelCameraAnimation(result: @escaping FlutterResult) {
        do {
            if cancelable != nil {
                cancelable?.cancel()
            }
        } catch {
            result(FlutterError(code: CameraAPI.errorCode, message: nil, details: nil))
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

    private static let errorCode = "camera"
}
