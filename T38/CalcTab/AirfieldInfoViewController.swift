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
        self.title = ICAO
        ICAOLabel.text = ICAO
        lattitudeLabel.text = lat
        longitudeLabel.text = long
        elevationLabel.text = String(elevation)
        runwaysLabel.text = "\(runwayListString)"
        stateLabel.text = state
        cityLabel.text = city
        //        rangeLabel.text = "0.0"
        //        bearingLabel.text = "0.0"

        //        print(selectedAirfield.Runways!.first?.Designator)

    }

    var currentAirport: AirfieldCD?
    var myLat = 0.0
    var myLong = 0.0
    
    
    


    var ICAO = ""
    var lat = ""
    var long = ""
    var elevation = 0.0

    var numberOfRunways = 0
    var runwayDesignatorList = [""]
    var runwayListString = ""
    var state = ""
    var city = ""
    var range = 0.0
    var bearing = 0.0

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

