import Foundation

public class MapBoxRouteEvent : Codable
{
    let eventType: MapBoxEventType
    let data: Any

    init(eventType: MapBoxEventType, data: Any) {
        self.eventType = eventType
        self.data = data
    }
}