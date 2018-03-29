//
//  AirfieldJOSNProcessor.swift
//  T38
//
//  Created by elmo on 3/27/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import Foundation

struct Airfield: Decodable {
    var ObjectID: Int? = 0
    var AirportID: String? = ""
    var Ident: String? = ""
    var Lat: String? = ""
    var Lon: String? = ""
    var Elevation: Double? = 0.0
    var ICAO: String? = ""
    var City: String? = ""
    var State: String? = ""
    var Runways : [Runway]?
    
    struct Runway: Codable {
        var AirportID : String? = ""
        var Designator : String? = ""
        var Length : Int? = 0
        var Width : Int? = 0
        var Coordinates : [String]? = [""]
    }
}











