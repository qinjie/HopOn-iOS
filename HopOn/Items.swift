//
//  Items.swift
//  HopOn
//
//  Created by Intern on 5/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import Foundation
import EVReflection

struct Constants {
    static let baseURL = "http://153.20.44.136"
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
    var distanceValue: Int!
}

class Bicycle: EVObject {
    var bicycle_type_id: String!
    var brand: String!
    var model: String!
}

class BeaconObj: EVObject {
    var UUID: String!
    var major: String!
    var minor: String!
}
