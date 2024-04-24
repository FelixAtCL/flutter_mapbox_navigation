import Foundation
import MapboxDirections

public class MapBoxWaypoint : Codable
{
    let coordinate: MapBoxLatLng
    var coordinateAccuracy: Double = 0.0
    var targetCoordinate: MapBoxLatLng? = nil
    let allowsSnappingToClosedRoad: Bool
    let allowsSnappingToStaticallyClosedRoad: Bool
    var snappedDistance: Double = 0.0
    let layer: Int = 0
    
    var heading: Double = 0.0
    var headingAccuracy: Double = 0.0
    let allowsArrivingOnOppositeSide: Bool

    let name: String
    
    init(point: Waypoint) {
        coordinate = MapBoxLatLng(point: point.coordinate)
        if(point.coordinateAccuracy != nil) {
            coordinateAccuracy = point.coordinateAccuracy
        }
        if(point.targetCoordinate != nil) {
            targetCoordinate = MapBoxLatLng(point: point.targetCoordinate!)
        }
        allowsSnappingToClosedRoad = point.allowsSnappingToClosedRoad
        allowsSnappingToStaticallyClosedRoad = point.allowsSnappingToStaticallyClosedRoad
        if(point.snappedDistance != nil) {
            snappedDistance = point.snappedDistance
        }
        if(point.layer != nil) {
            layer = point.layer
        }
        if(point.heading != nil) {
            heading = point.heading
        }
        if(point.headingAccuracy != nil) {
            headingAccuracy = point.headingAccuracy
        }
        allowsArrivingOnOppositeSide = point.allowsArrivingOnOppositeSide

        name = point.name != nil ? point.name! : ""
    }
}
