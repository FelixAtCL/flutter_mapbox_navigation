import Foundation
import MapboxDirections
import MapboxNavigation
import MapboxCoreNavigation

public class MapBoxRouteLegProgress : Codable
{
    let leg : RouteLeg
    let distanceTraveled : Double
    let durationRemaining : Double
    let distanceRemaining : Double
    let fractionTraveled : Double
    let userHasArrivedAtWaypoint : Bool
    let stepIndex : Int
    let currentStep : MapBoxRouteStep 
    let shapeIndex : Int
    var priorStep : MapBoxRouteStep? = nil
    var upcomingStep : MapBoxRouteStep? = nil
    var followOnStep : MapBoxRouteStep? = nil
    // var currentStepProgress : MapBoxRouteStepProgress
    var currentSpeedLimit : Measurement<UnitSpeed>? = nil
    var remainingSteps : [MapBoxRouteStep] = []

    init(progress: RouteLegProgress) {
        leg = progress.leg
        distanceTraveled = progress.distanceTraveled
        durationRemaining = progress.durationRemaining
        distanceRemaining = progress.distanceRemaining
        fractionTraveled = progress.fractionTraveled
        userHasArrivedAtWaypoint = progress.userHasArrivedAtWaypoint
        stepIndex = progress.stepIndex
        remainingSteps = progress.remainingSteps.map { MapBoxRouteStep(step: $0) }
        priorStep = progress.priorStep != nil ? MapBoxRouteStep(step: progress.priorStep!) : nil
        currentStep = MapBoxRouteStep(step: progress.currentStep)
        upcomingStep = progress.upcomingStep != nil ? MapBoxRouteStep(step: progress.upcomingStep!) : nil
        followOnStep = progress.followOnStep != nil ? MapBoxRouteStep(step: progress.followOnStep!) : nil
        // currentStepProgress = MapBoxRouteStepProgress(stepProgress: progress.currentStepProgress)
        currentSpeedLimit = progress.currentSpeedLimit
        shapeIndex = progress.shapeIndex
    }
}