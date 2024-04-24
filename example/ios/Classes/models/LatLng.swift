import SwiftUI
import CoreLocation
import Foundation

public class MapBoxLatLng : Codable 
{
    let latitude: Double
    let longitude: Double

    init(point: CLLocationCoordinate2D?) {
        latitude = point?.latitude != nil ? point.latitude : 0.0
        longitude = point?.longitude != nil ? point.longitude : 0.0
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
