import SwiftUI
import CoreLocation
import Foundation

public class MapBoxLatLng : Codable 
{
    let latitude: Double
    let longitude: Double

    init(point: CLLocationCoordinate2D) {
        latitude = point.latitude
        longitude = point.longitude
    }
}