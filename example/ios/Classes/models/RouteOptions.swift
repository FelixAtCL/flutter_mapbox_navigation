import Foundation
import MapboxDirections
import MapboxNavigation
import MapboxCoreNavigation

public class MapBoxRouteOptions : Codable
{
    let allowsUTurnAtWaypoint: Bool
    let roadClassesToAvoid: String
    let roadClassesToAllow: String
    var alleyPriority: Double = 0.0
    var walkwayPriority: Double = 0.0
    var speed: Double = 0.0
    var arriveBy: String = ""
    var departAt: String = ""
    var includesAlternativeRoutes: Bool = false
    var includesExitRoundaboutManeuver: Bool = false
    var refreshingEnabled: Bool = false
    var maximumHeight: Double = 1.5
    var maximumWidth: Double = 1.5
    var maximumWeight: Double = 1.5
    var initialManeuverAvoidanceRadius: Double = 0.0
        
    init(options: RouteOptions) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DDTHH:mm:ss.sss"
        
        allowsUTurnAtWaypoint = options.allowsUTurnAtWaypoint
        roadClassesToAllow = options.roadClassesToAllow.description
        roadClassesToAvoid = options.roadClassesToAvoid.description
        if(options.alleyPriority?.rawValue != nil) {
            alleyPriority = options.alleyPriority?.rawValue
        }
        if(options.walkwayPriority?.rawValue != nil) {
            walkwayPriority = options.walkwayPriority?.rawValue
        }
        if(options.speed != nil) {
            speed = options.speed
        }
        if(options.arriveBy != nil) {
            arriveBy = formatter.string(options.arriveBy)
        }
        if(options.departAt != nil) {
            departAt = formatter.string(options.departAt)
        }
        if(options.includesAlternativeRoutes != nil) {
            includesAlternativeRoutes = options.includesAlternativeRoutes
        }
        if(options.includesExitRoundaboutManeuver != nil) {
            includesExitRoundaboutManeuver = options.includesExitRoundaboutManeuver
        }
        if(options.refreshingEnabled != nil) {
            refreshingEnabled = options.refreshingEnabled
        }
        if(options.maximumWidth != nil) {
            maximumWidth = options.maximumWidth?.value
        }
        if(options.maximumHeight != nil) {
            maximumHeight = options.maximumHeight?.value
        }
        if(options.maximumWeight != nil) {
            maximumWeight = options.maximumWeight?.value
        }
        if(options.initialManeuverAvoidanceRadius != nil) {
            initialManeuverAvoidanceRadius = options.initialManeuverAvoidanceRadius
        }
    }
}
