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
//        self.title = ICAO
        
        
        
        
        print(deviceLat, deviceLong)

        
        
        
    }

    let locManager = CLLocationManager()
    let cdu = CoreDataUtilies()
    var currentAirport: AirfieldCD?
    var deviceLat = 0.0
    var deviceLong = 0.0
    var deviceAlt = 0.0
    
    
    
   


//    @IBOutlet weak var ICAOLabel: UILabel!
//    @IBOutlet weak var lattitudeLabel: UILabel!
//    @IBOutlet weak var longitudeLabel: UILabel!
//    @IBOutlet weak var elevationLabel: UILabel!
//    @IBOutlet weak var runwaysLabel: UILabel!
//    @IBOutlet weak var stateLabel: UILabel!
//    @IBOutlet weak var cityLabel: UILabel!
//    @IBOutlet weak var rangeLabel: UILabel!
//    @IBOutlet weak var bearingLabel: UILabel!
    

    @IBAction func copyDirect(_ sender: UIButton!){
//        UIPasteboard.general.string = "D \(ICAO)"
        presentingViewController?.dismiss(animated: true, completion: nil)
        var urlString = URLComponents(string: "foreflightmobile://maps/search?")!
//        urlString.query = "q=D \(currentAirport?.icao_CD!)"
        let url = urlString.url!
        UIApplication.shared.open(url , options: [:], completionHandler: nil)
    }


    func loadDetail() {
//        if let airfieldLat_ = currentAirport?.latitude_CD {
////            airfieldLat = airfieldLat_
//        }
    }



    override func viewWillDisappear(_ animated: Bool) {
    }
}

