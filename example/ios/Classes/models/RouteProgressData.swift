import Foundation
import MapboxDirections
import MapboxNavigation
import MapboxCoreNavigation

public class MapBoxRouteProgressData : Codable
{
    let arrived: Bool
    let distance: Double
    let duration: Double
    let distanceTraveled: Double
    let currentLegDistanceTraveled: Double
    let currentLegDistanceRemaining: Double
    let currentStepInstruction: String
    let legIndex: Int
    let stepIndex: Int
    let currentLeg: MapBoxRouteLeg
    var priorLeg: MapBoxRouteLeg? = nil
    var upcomingLeg: MapBoxRouteLeg? = nil
    var remainingLegs: [MapBoxRouteLeg] = []
    var currentLegProgress: MapBoxRouteLegProgress? = nil

    init(progress: RouteProgress) {

        arrived = progress.isFinalLeg && progress.currentLegProgress.userHasArrivedAtWaypoint
        distance = progress.distanceRemaining
        distanceTraveled = progress.distanceTraveled
        duration = progress.durationRemaining
        legIndex = progress.legIndex
        stepIndex = progress.currentLegProgress.stepIndex

        currentLeg = MapBoxRouteLeg(leg: progress.currentLeg)

        if(progress.priorLeg != nil)
        {
            priorLeg = MapBoxRouteLeg(leg: progress.priorLeg!)
        }

        if(progress.upcomingLeg != nil)
        {
            upcomingLeg = MapBoxRouteLeg(leg: progress.upcomingLeg!)
        }

        if(progress.currentLegProgress != nil) 
        {
            currentLegProgress = MapBoxRouteLegProgress(progress: progress.currentLegProgress)
        }

        for leg in progress.remainingLegs
        {
            remainingLegs.append(MapBoxRouteLeg(leg: leg))
        }

        currentLegDistanceTraveled = progress.currentLegProgress.distanceTraveled
        currentLegDistanceRemaining = progress.currentLegProgress.distanceRemaining
        currentStepInstruction = progress.currentLegProgress.currentStep.description
    }


}
