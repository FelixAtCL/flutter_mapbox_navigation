import Flutter
import Foundation
import UIKit
import MapboxMaps
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation

public class StyleController: NSObject, FlutterStreamHandler {

    let messenger: FlutterBinaryMessenger
    let channel: FlutterMethodChannel
    let eventChannel: FlutterEventChannel
    private var mapboxMap: MapboxMap

    init(messenger: FlutterBinaryMessenger, withMapboxMap mapboxMap: MapboxMap, viewId: Int64) {
        self.mapboxMap = mapboxMap
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

    func setStyleURIUri(_ uri: String, result: @escaping FlutterResult) {
        mapboxMap.style.uri = StyleURI(rawValue: uri)
        result("Set Style URI finished")
    }

    func getStyleJSON(result: @escaping FlutterResult) {
        result(mapboxMap.style.JSON)
    }

    func setStyleJSONJson(_ json: String, result: @escaping FlutterResult) {
        mapboxMap.style.JSON = json
        result("Set Style Json finished")
    }

    func getStyleDefaultCamera(result: @escaping FlutterResult) {
        let camera = mapboxMap.style.defaultCamera
        result(camera.toFLTCameraOptions())
    }

    func getStyleTransition(result: @escaping FlutterResult) {
        let transition = mapboxMap.style.transition
        result(transition.toFLTTransitionOptions())
    }

    func setStyleTransitionTransitionOptions(_ transitionOptions: FLTTransitionOptions,
                                             result: @escaping FlutterResult) {
        mapboxMap.style.transition = transitionOptions.toTransitionOptions()
        result("Set Style Transition Options finished")
    }

    func addStyleLayerProperties(_ properties: String, layerPosition: FLTLayerPosition?,
                                 result: @escaping FlutterResult) {
        do {
            let layerProperties: [String: Any] = convertStringToDictionary(properties: properties)
            try mapboxMap.style.addLayer(with: layerProperties, layerPosition: layerPosition?.toLayerPosition())
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func addPersistentStyleLayerProperties(_ properties: String, layerPosition: FLTLayerPosition?,
                                           result: @escaping FlutterResult) {
        do {
            try mapboxMap.style
                .addPersistentLayer(
                    with: convertStringToDictionary(properties: properties),
                    layerPosition: layerPosition?.toLayerPosition()
                )
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func isStyleLayerPersistentLayerId(_ layerId: String,                                       result: @escaping FlutterResult) {
        do {
            let isPersistent = try mapboxMap.style.isPersistentLayer(id: layerId)
            result(NSNumber(value: isPersistent))
        } catch {
            result(FlutterError(code: "\(error)", message: nil, details: nil))
        }
    }

    func removeStyleLayerLayerId(_ layerId: String, result: @escaping FlutterResult) {
        do {
            try mapboxMap.style.removeLayer(withId: layerId)
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func moveStyleLayerLayerId(_ layerId: String, layerPosition: FLTLayerPosition?,result: @escaping FlutterResult) {
        do {
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

    func styleLayerExistsLayerId(_ layerId: String,result: @escaping FlutterResult) {
        let existes = mapboxMap.style.layerExists(withId: layerId)
        result(NSNumber(value: existes))
    }

    func getStyleLayers(result: @escaping FlutterResult) {
        let layerInfos = mapboxMap.style.allLayerIdentifiers.map {
            FLTStyleObjectInfo.make(withId: $0.id as String, type: $0.type.rawValue)
        }
        result(layerInfos)
    }

    func getStyleLayerPropertyLayerId(_ layerId: String,                                      property: String,result: @escaping FlutterResult) {
        let layerProperty = mapboxMap.style.layerProperty(for: layerId, property: property)
        result(layerProperty.toFLTStylePropertyValue(property: property))
    }

    func setStyleLayerPropertyLayerId(_ layerId: String,
                                      property: String,
                                      value: Any,result: @escaping FlutterResult) {
        do {
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

    func getStyleLayerPropertiesLayerId(_ layerId: String,result: @escaping FlutterResult) {
        do {
            let properties = try mapboxMap.style.layerProperties(for: layerId)
            result(convertDictionaryToString(dict: properties))
        } catch {
            result(FlutterError(code: "\(error)", message: nil, details: nil))
        }
    }

    func setStyleLayerPropertiesLayerId(_ layerId: String, properties: String,result: @escaping FlutterResult) {
        let data = properties.data(using: String.Encoding.utf8)!
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
        do {
            try mapboxMap.style.setLayerProperties(for: layerId, properties: jsonObject as? [String: Any] ?? [:])
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func addStyleSourceSourceId(_ sourceId: String, properties: String, result: @escaping FlutterResult) {
        do {
            try mapboxMap.style.addSource(withId: sourceId,
                                          properties: convertStringToDictionary(properties: properties))
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleSourcePropertySourceId(_ sourceId: String, property: String,result: @escaping FlutterResult) {
        let sourceProperty = mapboxMap.style.sourceProperty(for: sourceId, property: property)
        result(sourceProperty.toFLTStylePropertyValue(property: property))
    }

    func setStyleSourcePropertySourceId(_ sourceId: String, property: String,
                                        value: Any, result: @escaping FlutterResult) {
        do {
            try mapboxMap.style.setSourceProperty(for: sourceId, property: property, value: value)
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleSourcePropertiesSourceId(_ sourceId: String,result: @escaping FlutterResult) {
        do {
            let properties = try mapboxMap.style.sourceProperties(for: sourceId)
            result(convertDictionaryToString(dict: properties))
        } catch {
            result(FlutterError(code: "\(error)", message: nil, details: nil))
        }
    }

    func setStyleSourcePropertiesSourceId(_ sourceId: String, properties: String,result: @escaping FlutterResult) {
        do {
            try mapboxMap.style.setSourceProperties(for: sourceId,
                                                       properties: convertStringToDictionary(properties: properties))
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func updateStyleImageSourceImageSourceId(_ sourceId: String, image: FLTMbxImage, result: @escaping FlutterResult) {
        guard let image = UIImage(data: image.data.data, scale: UIScreen.main.scale) else { return }
        do {
            try mapboxMap.style.updateImageSource(withId: sourceId, image: image)
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func removeStyleSourceSourceId(_ sourceId: String, result: @escaping FlutterResult) {
        do {
            try mapboxMap.style.removeSource(withId: sourceId)
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func styleSourceExistsSourceId(_ sourceId: String, result: @escaping FlutterResult) {
        let existes = mapboxMap.style.sourceExists(withId: sourceId)
        result(NSNumber(value: existes))
    }

    func getStyleSources(result: @escaping FlutterResult) {
        let sourcesInfos = mapboxMap.style.allSourceIdentifiers.map {
            FLTStyleObjectInfo.make(withId: $0.id as String, type: $0.type.rawValue)
        }
        result(sourcesInfos)
    }

    func setStyleLightProperties(_ properties: String, result: @escaping FlutterResult) {
        let data = properties.data(using: String.Encoding.utf8)!
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
        do {
            try mapboxMap.style.setLight(properties: jsonObject as? [String: Any] ?? [:])
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleLightPropertyProperty(_ property: String,result: @escaping FlutterResult) {
        let lightProperty: StylePropertyValue = mapboxMap.style.lightProperty(property)
        result(lightProperty.toFLTStylePropertyValue(property: property))
    }

    func setStyleLightPropertyProperty(_ property: String, value: Any,result: @escaping FlutterResult) {
        do {
            try mapboxMap.style.setLightProperty(property, value: value)
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func setStyleTerrainProperties(_ properties: String, result: @escaping FlutterResult) {
        let data = properties.data(using: String.Encoding.utf8)!
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
        do {
            try mapboxMap.style.setTerrain(properties: jsonObject as? [String: Any] ?? [:])
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleTerrainPropertyProperty(_ property: String,result: @escaping FlutterResult) {
        let terrainProperty: StylePropertyValue = mapboxMap.style.terrainProperty(property)
        result(terrainProperty.toFLTStylePropertyValue(property: property))
    }

    func setStyleTerrainPropertyProperty(_ property: String, value: Any,result: @escaping FlutterResult) {
        do {
            try mapboxMap.style.setTerrainProperty(property, value: value)
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleImageImageId(_ imageId: String, result: @escaping FlutterResult) {
        guard let image = mapboxMap.style.image(withId: imageId) else {
            result(nil)
            return
        }

        let data = FlutterStandardTypedData(bytes: image.pngData()!)

        result(FLTMbxImage.make(withWidth: NSNumber(value: Int(image.size.width * image.scale)),
                                    height: NSNumber(value: Int(image.size.height * image.scale)),
                                    data: data))
    }

    func addStyleImageImageId(_ imageId: String, scale: NSNumber,
                              image: FLTMbxImage, sdf: NSNumber,
                              stretchX: [FLTImageStretches],
                              stretchY: [FLTImageStretches],
                              content: FLTImageContent?,
                              result: @escaping FlutterResult) {

        guard let image = UIImage(data: image.data.data, scale: CGFloat(truncating: scale)) else { return }
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

    func removeStyleImageImageId(_ imageId: String, result: @escaping FlutterResult) {
        do {
            try mapboxMap.style.removeImage(withId: imageId)
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func hasStyleImageImageId(_ imageId: String, result: @escaping FlutterResult) {
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

    func invalidateStyleCustomGeometrySourceTileSourceId(_ sourceId: String,
                                                         tileId: FLTCanonicalTileID,result: @escaping FlutterResult) {
        do {
            try mapboxMap.style.invalidateCustomGeometrySourceTile(forSourceId: sourceId,
                                                                   tileId: tileId.toCanonicalTileID())
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func invalidateStyleCustomGeometrySourceRegionSourceId(_ sourceId: String,
                                                           bounds: FLTCoordinateBounds,
                                                           result: @escaping FlutterResult) {
        do {
            try mapboxMap.style.invalidateCustomGeometrySourceRegion(forSourceId: sourceId,
                                                                     bounds: bounds.toCoordinateBounds())
            result(nil)
        } catch {
            result(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func isStyleLoaded(result: @escaping FlutterResult) {
        result(NSNumber(value: (mapboxMap.style.isLoaded)), nil)
    }

    func getProjectionWithCompletion(_ result: @escaping FlutterResult) {
        result(mapboxMap.style.projection.name.rawValue)
    }

    func setProjectionProjection(_ projection: String, result: @escaping FlutterResult) {
        try! mapboxMap.style.setProjection(projection == "globe" ? StyleProjection(name: StyleProjectionName.globe) : StyleProjection(name: StyleProjectionName.mercator))
        result(nil)
    }

    func localizeLabelsLocale(_ locale: String, layerIds: [String]?, result: @escaping FlutterResult) {
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
