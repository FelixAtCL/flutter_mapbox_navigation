import Foundation
import MapboxMaps

extension FLTLayerPosition {
    func toLayerPosition() -> LayerPosition {
        var position = LayerPosition.default
        if self.above != nil {position = LayerPosition.above(self.above!)} else if self.below != nil {position = LayerPosition.below(self.below!)} else if self.at != nil {position = LayerPosition.at(Int(truncating: (self.at)!))}
        return position
    }
}