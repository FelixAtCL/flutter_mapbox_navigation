import Foundation
import MapboxDirections

public class MapBoxWaypoint : Codable
{
    let coordinate: MapBoxLatLng

    let allowsArrivingOnOppositeSide: Bool
    let allowsSnappingToClosedRoad: Bool
    let allowsSnappingToStaticallyClosedRoad: Bool
    var coordinateAccuracy: Double? = nil
    var targetCoordinate: MapBoxLatLng? = nil
    var snappedDistance: Double? = nil
    let layer: Int

    var heading: Double? = nil
    var headingAccuracy: Double? = nil

    let name: String
    
    init(point: Waypoint) {
        coordinate = MapBoxLatLng(point: point.coordinate)
        allowsSnappingToClosedRoad = point.allowsSnappingToClosedRoad
        allowsSnappingToStaticallyClosedRoad = point.allowsSnappingToStaticallyClosedRoad
        allowsArrivingOnOppositeSide = point.allowsArrivingOnOppositeSide

        coordinateAccuracy = point.coordinateAccuracy
        if(point.targetCoordinate != nil) {
            targetCoordinate = MapBoxLatLng(point: point.targetCoordinate!)
        }
        snappedDistance = point.snappedDistance
        layer = point.layer != nil ? point.layer! : 0
        heading = point.heading
        headingAccuracy = point.headingAccuracy
        name = point.name != nil ? point.name! : ""
    }
}
