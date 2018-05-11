//
//  AirfieldInfoViewController.swift
//  T38
//
//  Created by elmo on 3/29/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class AirfieldInfoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDetail()
        
        range = rangeAndBearing(latitude_01: myLat, longitude_01: myLong, latitude_02: airfieldLat, longitude_02: airfieldLong).range
        bearing = rangeAndBearing(latitude_01: myLat, longitude_01: myLong, latitude_02: airfieldLat, longitude_02: airfieldLong).bearing
        self.title = ICAO
        
        
        ICAOLabel.text = ICAO
        lattitudeLabel.text = "Range: \(String(format: "%.0f", range)) NM"
        longitudeLabel.text = "Bearing:  \(String(format: "%.0f", bearing))°"
        elevationLabel.text = ""
        runwaysLabel.text = ""
        stateLabel.text = ""
        cityLabel.text = ""
        
        
        //        rangeLabel.text = "0.0"
        //        bearingLabel.text = "0.0"

        //        print(selectedAirfield.Runways!.first?.Designator)
        
        
        
        print(myLat, myLong)

        
        
        
    }

    let locManager = CLLocationManager()
    let cdu = CoreDataUtilies()
    var currentAirport: AirfieldCD?
    var myLat = 0.0
    var myLong = 0.0
    var airfieldLat = 0.0
    var airfieldLong = 0.0
    var range = 0.0
    var bearing = 0.0
    
    

    func rangeAndBearing(latitude_01: Double, longitude_01: Double, latitude_02: Double, longitude_02: Double) -> (range: Double, bearing: Double) {
        let majEarthAxis_WGS84: Double = 6_378_137.0                // maj      - meters
        let minEarthAxis_WGS84: Double = 6_356_752.314_245          // min      - meters
        let lat_01 = latitude_01.degreesToRadians
        let lat_02 = latitude_02.degreesToRadians
        let long_01 = longitude_01.degreesToRadians
        let long_02 = longitude_02.degreesToRadians
        let difLong = (longitude_02 - longitude_01).degreesToRadians
        //1: radiusCorrectionFactor()
        let a1 = 1.0/(majEarthAxis_WGS84 * majEarthAxis_WGS84)
        let b1 = (tan(lat_01) * tan(lat_01)) / (minEarthAxis_WGS84 * minEarthAxis_WGS84)
        let c1 = 1.0/((a1+b1).squareRoot())
        let d1 = c1/(cos(lat_01))
        //2: Law of Cosines
        let range = (acos(sin(lat_01)*sin(lat_02) + cos(lat_01)*cos(lat_02) * cos(difLong)) * d1).metersToNauticalMiles
        //3: Calculating Bearing from 1st coords to second
        let a3 = sin(long_02 - long_01) * cos(lat_02)
        let b3 = cos(lat_01) * sin(lat_02) - sin(lat_01) * cos(lat_02) * cos(long_02 - long_01)
        let bearing = ((atan2(a3, b3).radiansToDegrees) + 360).truncatingRemainder(dividingBy: 360) //Might need mag variation here
        let results = [range, bearing]
        print(range)
        return (range: results[0], bearing: results[1])
    }
    

    var ICAO = ""
    var lat = ""
    var long = ""
    var elevation = 0.0

    var numberOfRunways = 0
    var runwayDesignatorList = [""]
    var runwayListString = ""
    var state = ""
    var city = ""


    @IBOutlet weak var ICAOLabel: UILabel!
    @IBOutlet weak var lattitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var elevationLabel: UILabel!
    @IBOutlet weak var runwaysLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var bearingLabel: UILabel!
    
    
    
    func distanceAway(deviceLat lat: Double, deviceLong long: Double, airport: AirfieldCD) -> Double {
        let airportLat = airport.latitude_CD
        let airportLong = airport.longitude_CD
        let myCoords =  CLLocation(latitude: lat, longitude: long)
        let airportCoords = CLLocation(latitude: airportLat, longitude: airportLong)
        let distanceAwayInNM = myCoords.distance(from: airportCoords).metersToNauticalMiles
        return distanceAwayInNM
    }
    


    @IBAction func copyDirect(_ sender: UIButton!){
//        UIPasteboard.general.string = "D \(ICAO)"
        presentingViewController?.dismiss(animated: true, completion: nil)
        var urlString = URLComponents(string: "foreflightmobile://maps/search?")!
        urlString.query = "q=D \(ICAO)"
        let url = urlString.url!
        UIApplication.shared.open(url , options: [:], completionHandler: nil)
    }


    func loadDetail() {
        if let airfieldLat_ = currentAirport?.latitude_CD {
            airfieldLat = airfieldLat_
        }
        if let airfieldLong_ = currentAirport?.longitude_CD {
            airfieldLong = airfieldLong_
        }
        
        if let newICAO = currentAirport?.icao_CD {
            ICAO = newICAO
        } else {
            ICAO = " "
        }
        if let newElevation = currentAirport?.elevation_CD {
            elevation = newElevation
        } else {
            elevation = 0.0
        }
        if let newLat = currentAirport?.latitude_CD {
            lat = String(newLat)
        } else {
            lat = " "
        }
        if let newLong = currentAirport?.longitude_CD {
            long = String(newLong)
        } else {
            long = " "
        }
        //runways = airfields[row].Runways
        if let newCity = currentAirport?.mgrs_CD{
            city = newCity
        } else {
            city = " "
        }
        if let newState = currentAirport?.state_CD{
            state = newState
        } else {
            state = " "
        }
//        if let newRunways = selectedAirfield.Runways {
//            runways = newRunways
//            numberOfRunways = runways.count
//            runwayDesignatorList = runways.map({$0.Designator!})
//            for runway in runwayDesignatorList {
//                runwayListString += " \(runway) "
//            }
//        } else {
//            print("No Runways: AirfieldInfoViewController 122")
//        }
    }

    func clearState() {
        ICAO = ""
        lat = ""
        long = ""
        elevation = 0.0
        //        runways = ""
        state = ""
        city = ""
        range = 0.0
        bearing = 0.0
    }

    override func viewWillDisappear(_ animated: Bool) {
        clearState()
    }
}

