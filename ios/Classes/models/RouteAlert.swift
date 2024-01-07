import Foundation
import MapboxDirections
import MapboxNavigation
import MapboxCoreNavigation

public class MapBoxRouteAlert : Codable
{
    let roadObject: MapBoxRoadObject
    let distanceToStart: Double

    init(alert: RouteAlert) {
        roadObject = MapBoxRoadObject(road: alert.roadObject)
        distanceToStart = alert.distanceToStart
    }
}
