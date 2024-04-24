import Foundation

public class MapBoxRouteProgressEvent : Codable {
    let eventType: MapBoxEventType
    let data: MapBoxRouteProgressData

    init(eventType: MapBoxEventType, data: MapBoxRouteProgressData) {
        self.eventType = eventType
        self.data = data
    }
}