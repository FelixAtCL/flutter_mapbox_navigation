import Foundation
import MapboxDirections
import MapboxNavigation
import MapboxCoreNavigation

// public typealias TimedCongestionLevel = (CongestionLevel, TimeInterval)

public class MapBoxRouteProgress : Codable
{
    let distance: Double    // => DistanceRemaining
    let duration: Double    // => DurationRemaining
    let fractionTraveled: Double
    let distanceTraveled: Double
    var remainingWaypoints: [MapBoxWaypoint] = []
    var upcomingRouteAlerts: [MapBoxRouteAlert] = []
    // var nearbyShape: [CLLocationCoordinate2D] = []

    let legIndex: Int
    let currentLeg: MapBoxRouteLeg
    var remainingLegs: [MapBoxRouteLeg] = []
    let isFinalLeg: Bool
    var currentLegProgress: MapBoxRouteLegProgress? = nil
    var priorLeg: MapBoxRouteLeg? = nil
    var upcomingLeg: MapBoxRouteLeg? = nil

    var remainingSteps: [MapBoxRouteStep] = []
    var priorStep: MapBoxRouteStep? = nil
    var upcomingStep: MapBoxRouteStep? = nil

    // var congestionTravelTimesSegmentsByStep: [[[TimedCongestionLevel]]] = []
    // var congestionTimesPerStep: [[[CongestionLevel: TimeInterval]]] = []
    // var averageCongestionLevelRemainingOnLeg: CongestionLevel? = nil
    
    init(progress: RouteProgress) {
        distance = progress.distanceRemaining
        duration = progress.durationRemaining
        fractionTraveled = progress.fractionTraveled
        distanceTraveled = progress.distanceTraveled
        remainingWaypoints = progress.remainingWaypoints.map { MapBoxWaypoint(point: $0) }
        upcomingRouteAlerts = progress.upcomingRouteAlerts.map { MapBoxRouteAlert(alert: $0) }
        // nearbyShape = progress.nearbyShape

        legIndex = progress.legIndex
        currentLeg = MapBoxRouteLeg(leg: progress.currentLeg)
        remainingLegs = progress.remainingLegs.map { MapBoxRouteLeg(leg: $0) }
        isFinalLeg = progress.isFinalLeg
        if(progress.currentLegProgress != nil) {
            currentLegProgress = MapBoxRouteLegProgress(progress: progress.currentLegProgress)
        }
        if(progress.priorLeg != nil) {
            priorLeg = MapBoxRouteLeg(leg: progress.priorLeg!) 
        }
        if(progress.upcomingLeg != nil) {
            upcomingLeg = MapBoxRouteLeg(leg: progress.upcomingLeg!) 
        }

        remainingSteps = progress.remainingSteps.map { MapBoxRouteStep(step: $0) }
        if(progress.priorStep != nil) {
            priorStep = MapBoxRouteStep(step: progress.priorStep!) 
        }
        if(progress.upcomingStep != nil) {
            upcomingStep = MapBoxRouteStep(step: progress.upcomingStep!) 
        }

        // congestionTravelTimesSegmentsByStep = progress.congestionTravelTimesSegmentsByStep
        // congestionTimesPerStep = progress.congestionTimesPerStep
        // averageCongestionLevelRemainingOnLeg = progress.averageCongestionLevelRemainingOnLeg
    }
}
