import Flutter
import Foundation
import UIKit
import MapboxMaps
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation

public class StyleController: NSObject, FlutterStreamHandler 
{
    var _eventSink: FlutterEventSink? = nil
    private var mapboxMap: MapboxMap

    let messenger: FlutterBinaryMessenger
    let channel: FlutterMethodChannel
    let eventChannel: FlutterEventChannel

    init(messenger: FlutterBinaryMessenger, withMapboxMap mapboxMap: MapboxMap, viewId: Int64) {
        self.mapboxMap = mapboxMap
        
        self.messenger = messenger
        self.channel = FlutterMethodChannel(name: "flutter_mapbox_navigation/style/\(viewId)", binaryMessenger: messenger)
        self.eventChannel = FlutterEventChannel(name: "flutter_mapbox_navigation/style/\(viewId)/events", binaryMessenger: messenger)

        super.init()

        self.eventChannel.setStreamHandler(self)

        self.channel.setMethodCallHandler { [weak self](call, result) in

            guard let strongSelf = self else { return }

            let arguments = call.arguments as? NSDictionary

            if(call.method == "getStyleURI")
            {
                strongSelf.getStyleURI(result: result)
            }
            else
            {
                result("method is not implemented");
            }
        }
    }

    func getStyleURI(result: @escaping FlutterResult) {
        result(mapboxMap.style.uri?.rawValue)
    }

    func setStyleURI(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let uri = arguments?["uri"] as? String else { return }
        mapboxMap.style.uri = StyleURI(rawValue: uri)
        result(nil)
    }

    func getStyleJSON(result: @escaping FlutterResult) {
        result(mapboxMap.style.JSON)
    }

    func setStyleJSON(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let json = arguments?["json"] as? String else { return }        
        mapboxMap.style.JSON = json
        result(nil)
    }

    func getStyleDefaultCamera(result: @escaping FlutterResult) {
        let camera = mapboxMap.style.defaultCamera
        result(camera.toFLTCameraOptions())
    }

    func getStyleTransition(result: @escaping FlutterResult) {
        let transition = mapboxMap.style.transition
        result(transition.toFLTTransitionOptions())
    }

    func setStyleTransition(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let transitionOptions = arguments?["transition"] as? FLTTransitionOptions else { return }
        mapboxMap.style.transition = transitionOptions.toTransitionOptions()
        result(nil)
    }

    func addStyleLayer(arguments: NSDictionary?, result: @escaping FlutterResult) {
        do {
            guard let properties = arguments?["properties"] as? String else { return }
            let layerProperties: [String: Any] = convertStringToDictionary(properties: properties)
            guard let layerPosition = arguments?["layerposition"] as? FLTLayerPosition else { return }
            try mapboxMap.style.addLayer(with: layerProperties, layerPosition: layerPosition?.toLayerPosition())
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func addPersistentStyleLayer(arguments: NSDictionary?, result: @escaping FlutterResult) {
        do {
            guard let properties = arguments?["properties"] as? String else { return }
            let layerProperties: [String: Any] = convertStringToDictionary(properties: properties)
            guard let layerPosition = arguments?["layerposition"] as? FLTLayerPosition else { return }
            try mapboxMap.style.addPersistentLayer(with: layerProperties, layerPosition: layerPosition?.toLayerPosition())
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func isStyleLayerPersistent(arguments: NSDictionary?, result: @escaping FlutterResult) {
        do {
            guard let layerId = arguments?["id"] as? String else { return }
            let isPersistent = try mapboxMap.style.isPersistentLayer(id: layerId)
            result(isPersistent)
        } catch {
            result(FlutterError(code: "\(error)", message: nil, details: nil))
        }
    }

    func removeStyleLayer(arguments: NSDictionary?, result: @escaping FlutterResult) {
        do {
            guard let layerId = arguments?["id"] as? String else { return }
            try mapboxMap.style.removeLayer(withId: layerId)
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func moveStyleLayerLayerId(arguments: NSDictionary?, result: @escaping FlutterResult) {
        do {
            guard let layerId = arguments?["id"] as? String else { return }
            guard let layerPosition = arguments?["layerposition"] as? FLTLayerPosition else { return }
            if layerPosition != nil {
                try mapboxMap.style.moveLayer(withId: layerId, to: layerPosition!.toLayerPosition())
            } else {
                try mapboxMap.style.moveLayer(withId: layerId, to: LayerPosition.default)
            }
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func styleLayerExists(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let layerId = arguments?["id"] as? String else { return }
        let exists = mapboxMap.style.layerExists(withId: layerId)
        result(exists)
    }

    func getStyleLayers(result: @escaping FlutterResult) {
        let layerInfos = mapboxMap.style.allLayerIdentifiers.map {
            FLTStyleObjectInfo.make(withId: $0.id as String, type: $0.type.rawValue)
        }
        result(layerInfos)
    }

    func getStyleLayerProperty(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let layerId = arguments?["id"] as? String else { return }
        guard let property = arguments?["property"] as? String else { return }
        let layerProperty = mapboxMap.style.layerProperty(for: layerId, property: property)
        result(layerProperty.toFLTStylePropertyValue(property: property))
    }

    func setStyleLayerProperty(arguments: NSDictionary?, result: @escaping FlutterResult) {
        do {
            guard let layerId = arguments?["id"] as? String else { return }
            guard let property = arguments?["property"] as? String else { return }
            guard let value = arguments?["value"] as? Any else { return }
            var mappedValue = value
            if let stringValue = value as? String {
                if stringValue.hasPrefix("[") || stringValue.hasPrefix("{") {
                    if let expressionData = stringValue.data(using: .utf8) {
                        let expJSONObject = try JSONSerialization.jsonObject(with: expressionData, options: [])
                        mappedValue = expJSONObject
                    }
                }
            }
            try mapboxMap.style.setLayerProperty(for: layerId, property: property, value: mappedValue)
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleLayerProperties(_ layerId: String,result: @escaping FlutterResult) {
        do {
            guard let layerId = arguments?["id"] as? String else { return }
            let properties = try mapboxMap.style.layerProperties(for: layerId)
            result(convertDictionaryToString(dict: properties))
        } catch {
            result(FlutterError(code: "\(error)", message: nil, details: nil))
        }
    }

    func setStyleLayerProperties(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let layerId = arguments?["id"] as? String else { return }
        guard let properties = arguments?["properties"] as? String else { return }
        let data = properties.data(using: String.Encoding.utf8)!
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
        do {
            try mapboxMap.style.setLayerProperties(for: layerId, properties: jsonObject as? [String: Any] ?? [:])
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func addStyleSource(arguments: NSDictionary?, result: @escaping FlutterResult) {
        do {
            guard let sourceId = arguments?["id"] as? String else { return }
            guard let properties = arguments?["properties"] as? String else { return }
            try mapboxMap.style.addSource(withId: sourceId,
                                          properties: convertStringToDictionary(properties: properties))
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleSourceProperty(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let sourceId = arguments?["id"] as? String else { return }
        guard let property = arguments?["property"] as? String else { return }
        let sourceProperty = mapboxMap.style.sourceProperty(for: sourceId, property: property)
        result(sourceProperty.toFLTStylePropertyValue(property: property))
    }

    func setStyleSourceProperty(arguments: NSDictionary?, result: @escaping FlutterResult) {
        do {
            guard let sourceId = arguments?["id"] as? String else { return }
            guard let property = arguments?["property"] as? String else { return }
            guard let value = arguments?["value"] as? Any else { return }
            try mapboxMap.style.setSourceProperty(for: sourceId, property: property, value: value)
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleSourceProperties(arguments: NSDictionary?, result: @escaping FlutterResult) {
        do {
            guard let sourceId = arguments?["id"] as? String else { return }
            let properties = try mapboxMap.style.sourceProperties(for: sourceId)
            result(convertDictionaryToString(dict: properties))
        } catch {
            result(FlutterError(code: "\(error)", message: nil, details: nil))
        }
    }

    func setStyleSourceProperties(arguments: NSDictionary?, result: @escaping FlutterResult) {
        do {
            guard let sourceId = arguments?["id"] as? String else { return }
            guard let properties = arguments?["properties"] as? String else { return }
            try mapboxMap.style.setSourceProperties(for: sourceId,
                                                       properties: convertStringToDictionary(properties: properties))
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func updateStyleImageSourceImage(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let sourceId = arguments?["id"] as? String else { return }
        guard let mbxImage = arguments?["image"] as? FLTMbxImage else { return }
        guard let image = UIImage(data: image.data.data, scale: UIScreen.main.scale) else { return }
        do {
            try mapboxMap.style.updateImageSource(withId: sourceId, image: image)
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func removeStyleSource(arguments: NSDictionary?, result: @escaping FlutterResult) {
        do {
            guard let sourceId = arguments?["id"] as? String else { return }
            try mapboxMap.style.removeSource(withId: sourceId)
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func styleSourceExists(_ sourceId: String, result: @escaping FlutterResult) {
        guard let sourceId = arguments?["id"] as? String else { return }
        let exists = mapboxMap.style.sourceExists(withId: sourceId)
        result(exists)
    }

    func getStyleSources(result: @escaping FlutterResult) {
        let sourcesInfos = mapboxMap.style.allSourceIdentifiers.map {
            FLTStyleObjectInfo.make(withId: $0.id as String, type: $0.type.rawValue)
        }
        result(sourcesInfos)
    }

    func setStyleLight(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let properties = arguments?["properties"] as? String else { return }
        let data = properties.data(using: String.Encoding.utf8)!
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
        do {
            try mapboxMap.style.setLight(properties: jsonObject as? [String: Any] ?? [:])
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleLightProperty(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let property = arguments?["property"] as? String else { return }
        let lightProperty: StylePropertyValue = mapboxMap.style.lightProperty(property)
        result(lightProperty.toFLTStylePropertyValue(property: property))
    }

    func setStyleLightProperty(arguments: NSDictionary?, result: @escaping FlutterResult) {
        do {
            guard let property = arguments?["property"] as? String else { return }
            guard let value = arguments?["value"] as? Any else { return }
            try mapboxMap.style.setLightProperty(property, value: value)
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func setStyleTerrain(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let properties = arguments?["properties"] as? String else { return }
        let data = properties.data(using: String.Encoding.utf8)!
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
        do {
            try mapboxMap.style.setTerrain(properties: jsonObject as? [String: Any] ?? [:])
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleTerrainProperty(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let property = arguments?["property"] as? String else { return }
        let terrainProperty: StylePropertyValue = mapboxMap.style.terrainProperty(property)
        result(terrainProperty.toFLTStylePropertyValue(property: property))
    }

    func setStyleTerrainProperty(_ property: String, value: Any,result: @escaping FlutterResult) {
        do {
            guard let property = arguments?["property"] as? String else { return }
            guard let value = arguments?["value"] as? Any else { return }
            try mapboxMap.style.setTerrainProperty(property, value: value)
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleImage(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let imageId = arguments?["id"] as? String else { return }
        guard let image = mapboxMap.style.image(withId: imageId) else {
            result(nil)
            return
        }

        let data = FlutterStandardTypedData(bytes: image.pngData()!)

        result(FLTMbxImage.make(withWidth: NSNumber(value: Int(image.size.width * image.scale)),
                                    height: NSNumber(value: Int(image.size.height * image.scale)),
                                    data: data))
    }

    func addStyleImage(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let imageId = arguments?["id"] as? String else { return }
        guard let scale = arguments?["scale"] as? NSNumber else { return }
        guard let mbImage = arguments?["image"] as? FLTMbxImage else { return }
        guard let sdf = arguments?["sdf"] as? NSNumber else { return }
        guard let stretchX = arguments?["stretchX"] as? [FLTImageStretches] else { return }
        guard let stretchY = arguments?["stretchY"] as? [FLTImageStretches] else { return }
        guard let content = arguments?["content"] as? FLTImageContent else { return }

        guard let image = UIImage(data: mbImage.data.data, scale: CGFloat(truncating: scale)) else { return }
        var imageContent: ImageContent?
        if content != nil {
            imageContent = ImageContent(left: Float(truncating: content!.left),
                                        top: Float(truncating: content!.top),
                                        right: Float(truncating: content!.right),
                                        bottom: Float(truncating: content!.bottom))
        }
        do {
            try mapboxMap.style.addImage(image,
                                         id: imageId,
                                         sdf: sdf as? Bool ?? false,
                                         stretchX: stretchX.map {
                ImageStretches(first: Float(truncating: $0.first), second: Float(truncating: $0.second))

            }, stretchY: stretchY.map {
                ImageStretches(first: Float(truncating: $0.first), second: Float(truncating: $0.second))},
                                         content: imageContent)
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func removeStyleImage(arguments: NSDictionary?, result: @escaping FlutterResult) {
        do {
            guard let imageId = arguments?["id"] as? String else { return }
            try mapboxMap.style.removeImage(withId: imageId)
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func hasStyleImage(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let imageId = arguments?["id"] as? String else { return }
        let image = mapboxMap.style.image(withId: imageId)
        result(NSNumber(value: image != nil))
    }
//
//    func setStyleCustomGeometrySourceTileDataSourceId(_ sourceId: String,
//                                                      tileId: FLTCanonicalTileID,
//                                                      featureCollection: String,
//                                                      completion: @escaping (FlutterError?) -> Void) {
//        do {
//            let features = try JSONDecoder().decode(FeatureCollection.self,
//                                                    from: featureCollection.data(using: String.Encoding.utf8)!)
//
//            let tileID = CanonicalTileID(z: UInt8(truncating: tileId.z),
//                                         x: UInt32(truncating: tileId.x),
//                                         y: UInt32(truncating: tileId.y)
//                                         try mapboxMap.style.setCustomGeometrySourceTileData(forSourceId: sourceId,
//                                                                                             tileId: tileID),
//                                         features: features.features)
//            completion(nil)
//        } catch {
//            completion(FlutterError(code: StyleController.errorCode , message: "\(error)", details: nil))
//        }
//    }

    func invalidateStyleCustomGeometrySourceTile(arguments: NSDictionary?, result: @escaping FlutterResult) {
        do {
            guard let sourceId = arguments?["id"] as? String else { return }
            guard let tileId = arguments?["tileId"] as? FLTCanonicalTileID else { return }
            try mapboxMap.style.invalidateCustomGeometrySourceTile(forSourceId: sourceId,
                                                                   tileId: tileId.toCanonicalTileID())
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func invalidateStyleCustomGeometrySourceRegion(arguments: NSDictionary?, result: @escaping FlutterResult) {
        do {
            guard let sourceId = arguments?["id"] as? String else { return }
            guard let bounds = arguments?["bounds"] as? FLTCoordinateBounds else { return }
            try mapboxMap.style.invalidateCustomGeometrySourceRegion(forSourceId: sourceId,
                                                                     bounds: bounds.toCoordinateBounds())
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func isStyleLoaded(result: @escaping FlutterResult) {
        result(mapboxMap.style.isLoaded)
    }

    func getProjection(_ result: @escaping FlutterResult) {
        result(mapboxMap.style.projection.name.rawValue)
    }

    func setProjection(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let projection = arguments?["projection"] as? String else { return }
        try! mapboxMap.style.setProjection(projection == "globe" ? StyleProjection(name: StyleProjectionName.globe) : StyleProjection(name: StyleProjectionName.mercator))
        result(nil)
    }

    func localizeLabels(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let locale = arguments?["locale"] as? String else { return }
        guard let layerIds = arguments?["layerids"] as? [String] else { return }
        try! mapboxMap.style.localizeLabels(into: Locale(identifier: locale), forLayerIds: layerIds)
        result(nil)
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

    private static let errorCode = "0"
}
