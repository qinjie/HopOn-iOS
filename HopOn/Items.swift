//
//  Items.swift
//  HopOn
//
//  Created by Intern on 5/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import Foundation
import EVReflection
import Alamofire
import MapKit

struct Constants {
    static let baseURL = "http://188.166.247.154"
    static var token = ""
    static var fullname = ""
    static var curLat = 0.0
    static var curLong = 0.0
    static var station = [Station]()
    static var beaconList = [BeaconObj]()
}

class History: EVObject {
    var rental_id: String!
    var booking_id: String!
    var bicycle_id: String!
    var bicycle_serial: String!
    var desc: String!
    var brand: String!
    var model: String!
    var pickup_station_name: String!
    var pickup_station_address: String!
    var pickup_station_postal: String!
    var pickup_station_lat: String!
    var pickup_station_lng: String!
    var book_at: String!
    var pickup_at: String!
    var return_at: String!
    var duration: String!
    var return_station_name: String!
    var return_station_address: String!
    var return_station_postal: String!
    var return_station_lat: String!
    var return_station_lng: String!
}

class Station: EVObject {
    var id: String!
    var name: String!
    var address: String!
    var latitude: String!
    var longitude: String!
    var postal: String!
    var bicycle_count: String!
    var available_bicycle: String!
    var distanceText: String!
    var distanceValue: String!
}

class Bicycle: EVObject, EVArrayConvertable {
    var bicycle_type_id: String!
    var brand: String!
    var model: String!
    var desc: String!
    var availableBicycle: String!
    var totalBicycle: String!
    var listImageUrl: Array<String> = Array()
    
    func convertArray(_ key: String, array: Any) -> NSArray {
        switch key {
        case "listImageUrl":
            print("\(array)")
        default:
            break
        }
        return []
    }
}

struct BeaconObj {
    var uuid: String!
    var major: String!
    var minor: String!
    var rssi: String!
    static func jsonArray(array : [BeaconObj]) -> [Parameters]
    {
        var result: [Parameters] = []
        for item in array{
            result.append(item.jsonRepresentation)
        }
        return result
    }
    
    var jsonRepresentation : Parameters {
        return [
            "uuid" : uuid,
            "major" : major,
            "minor" : minor,
            "rssi" : rssi
        ]
    }
}

class StationAnno: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D, subtitle: String) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
    }
}

class SearchAnno: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D, subtitle: String) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
    }
}
