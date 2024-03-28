import Foundation
import MapboxMaps

extension FLTCameraOptions {
    func toCameraOptions() -> CameraOptions {
        return CameraOptions(center: convertDictionaryToCLLocationCoordinate2D(dict: self.center), padding: self.padding?.toUIEdgeInsets(), anchor: self.anchor?.toCGPoint(), zoom: self.zoom?.CGFloat, bearing: self.bearing?.CLLocationDirection, pitch: self.pitch?.CGFloat)
    }
}

extension CameraOptions {
    func toFLTCameraOptions() -> FLTCameraOptions {
        let center = self.center != nil ? self.center?.toDict(): nil
        let padding = self.padding != nil ? FLTMbxEdgeInsets.make(
            withTop: NSNumber(value: self.padding!.top),
            left: NSNumber(value: self.padding!.left),
            bottom: NSNumber(value: self.padding!.bottom),
            right: NSNumber(value: self.padding!.right)) : nil

        let anchor = self.anchor != nil ? FLTScreenCoordinate.makeWith(x: self.anchor!.x as NSNumber, y: self.anchor!.y as NSNumber) : nil
        let zoom = self.zoom != nil ? NSNumber(value: self.zoom!) : nil
        let bearing = self.bearing != nil ? NSNumber(value: self.bearing!) : nil
        let pitch = self.pitch != nil ? NSNumber(value: self.pitch!) : nil

        return FLTCameraOptions.make(withCenter: center, padding: padding, anchor: anchor, zoom: zoom, bearing: bearing, pitch: pitch)
    }
}