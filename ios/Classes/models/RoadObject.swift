import Foundation
import MapboxDirections
import MapboxNavigation
import MapboxCoreNavigation

public class MapBoxRoadObject : Codable
{
    let identifier: String
    // let location: String
    // let kind: String
    let isUserDefined: Bool
    var length: Double? = nil
    var isUrban: Bool? = nil

    init(road: RoadObject) {
        identifier = road.identifier
        length = road.length
        // location = road.location
        // kind = road.kind
        isUserDefined = road.isUserDefined
        isUrban = road.isUrban    
    }
}
