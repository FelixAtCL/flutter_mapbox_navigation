import Flutter
import Foundation
import UIKit
import MapboxMaps
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation

public class MapAPI: NSObject, FlutterStreamHandler 
{
    var _eventSink: FlutterEventSink? = nil
    private var mapboxMap: MapboxMap

    let messenger: FlutterBinaryMessenger
    let channel: FlutterMethodChannel
    let eventChannel: FlutterEventChannel

    init(messenger: FlutterBinaryMessenger, withMapboxMap mapboxMap: MapboxMap, viewId: Int64) {
        self.mapboxMap = mapboxMap
        
        self.messenger = messenger
        self.channel = FlutterMethodChannel(name: "flutter_mapbox_navigation/map/\(viewId)", binaryMessenger: messenger, codec: FLT_MapInterfaceGetCodec())
        self.eventChannel = FlutterEventChannel(name: "flutter_mapbox_navigation/map/\(viewId)/events", binaryMessenger: messenger, codec: FLT_MapInterfaceGetCodec())

        super.init()

        self.eventChannel.setStreamHandler(self)

        self.channel.setMethodCallHandler { [weak self](call, result) in

            guard let strongSelf = self else { return }

            let arguments = call.arguments as? NSDictionary

            if(call.method == "pixelForCoordinate")
            {
                strongSelf.pixelForCoordinate(arguments: arguments, result: result)
            } 
            else if (call.method == "queryRenderedFeatures") 
            {
                strongSelf.queryRenderedFeatures(arguments: arguments, result: result)
            }
            else
            {
                result("method is not implemented");
            }
        }

        subscribeEvents()
    }

    func pixelForCoordinate(arguments: NSDictionary?, result: @escaping FlutterResult) {
        do {
            guard let lat = arguments?["latitude"] as? Double else {return}
            guard let lon = arguments?["longitude"] as? Double else {return}
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let point = self.mapboxMap.point(for: coordinate)
            result(point.toFLTScreenCoordinate())
        } catch {
            result(FlutterError(code: MapAPI.errorCode, message: "\(error)", details: nil))
        }
    }

    func queryRenderedFeatures(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let geometry = arguments?["geometry"] as? FLTRenderedQueryGeometry else {return}
        guard let options = arguments?["options"] as? FLTRenderedQueryOptions else {return}
        do {
            if geometry.type == FLTType.SCREEN_BOX {
                let screenBoxArray = convertStringToArray(properties: geometry.value)
                guard let minCoord = screenBoxArray[0] as? [Double] else {return}
                guard let maxCoord = screenBoxArray[1] as? [Double] else {return}

                let screenBox = ScreenBox(min: ScreenCoordinate(x: minCoord[0], y: minCoord[1]),
                                          max: ScreenCoordinate(x: maxCoord[0], y: maxCoord[1]))
                let cgRect = screenBox.toCGRect()
                let queryOptions = try options.toRenderedQueryOptions()
                self.mapboxMap.queryRenderedFeatures(in: cgRect, options: queryOptions) { res in
                    switch res {
                    case .success(let features):
                        result(features.map({$0.toFLTQueriedFeature()}))
                    case .failure(let error):
                        result(FlutterError(code: MapAPI.errorCode, message: "\(error)", details: nil))
                    }
                }
            } else if geometry.type == FLTType.SCREEN_COORDINATE {
                guard let pointArray = convertStringToArray(properties: geometry.value) as? [Double] else {return}
                let cgPoint = CGPoint(x: pointArray[0], y: pointArray[1])

                try self.mapboxMap.queryRenderedFeatures(at: cgPoint, options: options.toRenderedQueryOptions()) { res in
                    switch res {
                    case .success(let features):
                        result(features.map({$0.toFLTQueriedFeature()}))
                    case .failure(let error):
                        result(FlutterError(code: MapAPI.errorCode, message: "\(error)", details: nil))
                    }
                }
            } else {
                let cgPoints = try JSONDecoder().decode([[Double]].self, from: geometry.value.data(using: String.Encoding.utf8)!)

                try self.mapboxMap.queryRenderedFeatures(for: cgPoints.map({CGPoint(x: $0[0], y: $0[1])}), options: options.toRenderedQueryOptions()) { res in
                    switch res {
                    case .success(let features):
                        result(features.map({$0.toFLTQueriedFeature()}))
                    case .failure(let error):
                        result(FlutterError(code: MapAPI.errorCode, message: "\(error)", details: nil))
                    }
                }
            }
        } catch {
            result(FlutterError(code: MapAPI.errorCode, message: "\(error)", details: nil))
        }
    }

    private func subscribeEvents() {
        self.mapboxMap.onEvery(event: MapEvents.Event.cameraChanged!) { (event) in
            guard let data = event.payload as? [String: Any] else {return}
            self.channel.invokeMethod(self.getEventMethodName(eventType: event.name),
                                        arguments: self.convertDictionaryToString(dict: data))
        }

        self.mapboxMap.onEvery(event: MapEvents.Event.mapIdle!) { (event) in
            guard let data = event.payload as? [String: Any] else {return}
            self.channel.invokeMethod(self.getEventMethodName(eventType: event.name),
                                        arguments: self.convertDictionaryToString(dict: data))
        }

        self.mapboxMap.onEvery(event: MapEvents.Event.mapLoaded!) { (event) in
            guard let data = event.payload as? [String: Any] else {return}
            self.channel.invokeMethod(self.getEventMethodName(eventType: event.name),
                                        arguments: self.convertDictionaryToString(dict: data))
        }

        self.mapboxMap.onEvery(event: MapEvents.Event.renderFrameFinished!) { (event) in
            guard let data = event.payload as? [String: Any] else {return}
            self.channel.invokeMethod(self.getEventMethodName(eventType: event.name),
                                        arguments: self.convertDictionaryToString(dict: data))
        }

        self.mapboxMap.onEvery(event: MapEvents.Event.renderFrameStarted!) { (event) in
            guard let data = event.payload as? [String: Any] else {return}
            self.channel.invokeMethod(self.getEventMethodName(eventType: event.name),
                                        arguments: self.convertDictionaryToString(dict: data))
        }

        self.mapboxMap.onEvery(event: MapEvents.Event.sourceAdded!) { (event) in
            guard let data = event.payload as? [String: Any] else {return}
            self.channel.invokeMethod(self.getEventMethodName(eventType: event.name),
                                        arguments: self.convertDictionaryToString(dict: data))
        }

        self.mapboxMap.onEvery(event: MapEvents.Event.sourceDataLoaded!) { (event) in
            guard let data = event.payload as? [String: Any] else {return}
            self.channel.invokeMethod(self.getEventMethodName(eventType: event.name),
                                        arguments: self.convertDictionaryToString(dict: data))
        }

        self.mapboxMap.onEvery(event: MapEvents.Event.sourceRemoved!) { (event) in
            guard let data = event.payload as? [String: Any] else {return}
            self.channel.invokeMethod(self.getEventMethodName(eventType: event.name),
                                        arguments: self.convertDictionaryToString(dict: data))
        }

        self.mapboxMap.onEvery(event: MapEvents.Event.styleDataLoaded!) { (event) in
            guard let data = event.payload as? [String: Any] else {return}
            self.channel.invokeMethod(self.getEventMethodName(eventType: event.name),
                                        arguments: self.convertDictionaryToString(dict: data))
        }

        self.mapboxMap.onEvery(event: MapEvents.Event.styleImageMissing!) { (event) in
            guard let data = event.payload as? [String: Any] else {return}
            self.channel.invokeMethod(self.getEventMethodName(eventType: event.name),
                                        arguments: self.convertDictionaryToString(dict: data))
        }

        self.mapboxMap.onEvery(event: MapEvents.Event.styleImageRemoveUnused!) { (event) in
            guard let data = event.payload as? [String: Any] else {return}
            self.channel.invokeMethod(self.getEventMethodName(eventType: event.name),
                                        arguments: self.convertDictionaryToString(dict: data))
        }

        self.mapboxMap.onEvery(event: MapEvents.Event.styleLoaded!) { (event) in
            guard let data = event.payload as? [String: Any] else {return}
            self.channel.invokeMethod(self.getEventMethodName(eventType: event.name),
                                        arguments: self.convertDictionaryToString(dict: data))
        }
    }

    private func getEventMethodName(eventType: String) -> String {
        return "event#\(eventType)"
    }

    private func convertDictionaryToString(dict: [String: Any]) -> String {
        var result: String = ""
        do {
            let jsonData =
            try JSONSerialization.data(
                withJSONObject: dict,
                options: JSONSerialization.WritingOptions.init(rawValue: 0)
            )

            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                result = JSONString
            }
        } catch {
            result = ""
        }
        return result
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

    private static let errorCode = "map"
}
