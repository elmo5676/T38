//
//  coreDataUtilities.swift
//  T38
//
//  Created by elmo on 5/7/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class CoreDataUtilies {
    
    func distanceAway(deviceLat lat: Double, deviceLong long: Double, airport: AirfieldCD) -> (airport: AirfieldCD, distanceAway: Double) {
        let airportLat = airport.latitude_CD
        let airportLong = airport.longitude_CD
        let myCoords =  CLLocation(latitude: lat, longitude: long)
        let airportCoords = CLLocation(latitude: airportLat, longitude: airportLong)
        let distanceAwayInNM = myCoords.distance(from: airportCoords).metersToNauticalMiles
        return (airport, distanceAwayInNM)
    }
    
    
    
    
    
}
