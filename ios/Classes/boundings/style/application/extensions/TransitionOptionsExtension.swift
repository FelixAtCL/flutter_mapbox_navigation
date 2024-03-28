import Foundation
import MapboxMaps

extension FLTTransitionOptions {
    func toTransitionOptions() -> TransitionOptions {
        return TransitionOptions(
            duration: self.duration?.doubleValue,
            delay: self.delay?.doubleValue,
            enablePlacementTransitions: self.enablePlacementTransitions?.boolValue)
    }
}

extension TransitionOptions {
    func toFLTTransitionOptions() -> FLTTransitionOptions {
        let duration = self.duration != nil ? NSNumber(value: Int(self.duration!)) : nil
        let delay = self.delay != nil ? NSNumber(value: Int(self.delay!)) : nil
        let enablePlacementTransitions = self.enablePlacementTransitions != nil ? NSNumber(value: self.enablePlacementTransitions!) : nil

        return FLTTransitionOptions.make(withDuration: duration, delay: delay, enablePlacementTransitions: enablePlacementTransitions)
    }
}
