//
//  AirfieldInfoViewController.swift
//  T38
//
//  Created by elmo on 3/29/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit

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
    
    var selectedAirfield = Airfield()
    var ICAO = ""
    var lat = ""
    var long = ""
    var elevation = 0.0
    var runways = [Airfield.Runway]()
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
    
    @IBAction func copyDirect(_ sender: UIButton!){
        UIPasteboard.general.string = "D \(ICAO)"
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    func loadDetail() {
        if let newICAO = selectedAirfield.ICAO {
            ICAO = newICAO
        } else {
            ICAO = " "
        }
        if let newElevation = selectedAirfield.Elevation {
            elevation = newElevation
        } else {
            elevation = 0.0
        }
        if let newLat = selectedAirfield.Lat {
            lat = newLat
        } else {
            lat = " "
        }
        if let newLong = selectedAirfield.Lon {
            long = newLong
        } else {
            long = " "
        }
        //runways = airfields[row].Runways
        if let newCity = selectedAirfield.City{
            city = newCity
        } else {
            city = " "
        }
        if let newState = selectedAirfield.State{
            state = newState
        } else {
            state = " "
        }
        if let newRunways = selectedAirfield.Runways {
            runways = newRunways
            numberOfRunways = runways.count
            runwayDesignatorList = runways.map({$0.Designator!})
            for runway in runwayDesignatorList {
                runwayListString += " \(runway) "
            }
        } else {
            print("No Runways: AirfieldInfoViewController 122")
        }
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

