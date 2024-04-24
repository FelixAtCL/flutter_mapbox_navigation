import Foundation
import MapboxDirections
import MapboxNavigation
import MapboxNavigationNative

public class MapBoxRoadObject : Codable
{
    let identifier: String
    let location: MapBoxRoadObjectLocation
    let kind: String
    let isUserDefined: Bool
    var length: Double? = nil
    var isUrban: Bool? = nil

    init(road: RoadObject) {
        identifier = road.identifier
        length = road.length
        location = parseLocation(road.location)
        kind = parseKind(road.kind)
        isUserDefined = road.isUserDefined
        isUrban = road.isUrban    
    }
    
    func parseKind(_ kind: RoadObject.Kind) -> String {
        if case .borderCrossing(let borderCrossing) = kind {
            return "borderCrossing"
        }
        if case .bridge = kind {
            return "bridge"
        }
        if case .ic(let interchange) = kind {
            return "ic"
        }
        if case .incident(let incident) = kind {
            return "incident"
        }
        if case .jct(let junction) = kind {
            return "jct"
        }
        if case .railroadCrossing = kind {
            return "railroadCrossing"
        }
        if case .restrictedArea = kind {
            return "restrictedArea"
        }
        if case .serviceArea(let restStop) = kind {
            return "serviceArea"
        }
        if case .tollCollection(let tollCollection) = kind {
            return "tollCollection"
        }
        if case .tunnel(let tunnel) = kind {
            return "tunnel"
        }
        return "unknown"
    }
    
    func parseLocation(_ location: RoadObject.Location) -> MapBoxRoadObjectLocation {
        if case .gantry(let positions, let shape) = location {
            var latLng = MapBoxLatLng(positions.first?.coordinate)
            return MapBoxRoadObjectLocation(name: "gantry", geometry: latLng)
        }
        if case .openLRLine(let path, let shape) = location {
            return MapBoxRoadObjectLocation("openLRLine")
        }
        if case .openLRPoint(let position, let sideOfRoad, let orientation, let coordinate) = location {
            return MapBoxRoadObjectLocation(name: "openLRPoint", geometry: MapBoxLatLng(coordinate))
        }
        if case .point(let position) = location {
            return MapBoxRoadObjectLocation(name: "point", geometry: MapBoxLatLng(position.coordinate))
        }
        if case .polygon(let entries, let exits, let shape) = location {
            var latLng = MapBoxLatLng(entries.first?.coordinate)
            return MapBoxRoadObjectLocation(name: "polygon", geometry: latLng)
        }
        if case .polyline(let path, let shape) = location {
            return MapBoxRoadObjectLocation("polyline")
        }
        if case .routeAlert(let shape) = location {
            return MapBoxRoadObjectLocation("routeAlert")
        }
    }
}

class MapBoxRoadObjectLocation: Codable {
    let name: String
    let geometry: MapBoxLatLng?
    
    init(name: String, geometry: MapBoxLatLng) {
        self.name = name
        self.geometry = geometry
    }
    
    init(name: String) {
        self.name = name
        self.geometry = nil
    }
}
