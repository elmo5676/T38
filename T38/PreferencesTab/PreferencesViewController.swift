//
//  PreferencesViewController.swift
//  T38
//
//  Created by elmo on 4/13/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import CoreData

class PreferencesViewController: UIViewController {

    
    var airport: [NSManagedObject] = []
    var downLoader = JSONHandler()
    var cdu = CoreDataUtilies()
    var moc: NSManagedObjectContext!
    var dafifUrlJSONBase = "http://getatis.com/DAFIF/GetAirfieldsByState?state="
    var weatherUrlJSONBase = "https://www.getatis.com/services/GetMETAR?stations="
//    var homeStation =
    var state = "CA"
    
    var cw: Weather?
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    
    @IBAction func addButton(_ sender: Any) {
//        downLoader.removeFile(fileNamewithExtension: "\(cdu.getUserDefaults().homeFieldICAO_UD).json")
        downLoader.downloadWeather(baseUrl: cdu.getUserDefaults().baseWeatherUrl_UD, icao: cdu.getUserDefaults().homeFieldICAO_UD)
//        print(downLoader.currentWeather(icao: cdu.getUserDefaults().homeFieldICAO_UD))

        
        
        
        
        
//        cdu.loadToDBFromJSON(state, moc: moc)
//        downLoader.downloadAllStates(baseUrl: dafifUrlJSONBase)
//        print(loadCD.checkIfCoreDataIsLoaded(moc: moc))
//        cdu.printResults(moc: moc)
//        downLoader.printAvailableDownloads()
        
    }
    
    
    @IBAction func printButton(_ sender: Any) {
        print(downLoader.currentWeather(icao: "KBAB"))
//        print(downLoader.currentWeather(icao: cdu.getUserDefaults().homeFieldICAO_UD))
//        cdu.printResults(moc: moc)
//        var resultsDict = [AirfieldCD:[RunwayCD]]()
////        resultsDict = cdu.getAirfieldAndRunwaysWithRWYLengthGreaterThanOrEqualTo(moc: moc)
//        resultsDict = cdu.getAirfieldByICAO("KBAB", moc: moc)
//
//        for (key, value) in resultsDict {
//            print("Airfield ID: \(key.icao_CD!)")
//            for runway in value {
//                print("Runway Hi ID: \(runway.highID_CD!), Runway Length: \(runway.length_CD)")
//                print("Runway Low ID: \(runway.lowID_CD!), Runway Length: \(runway.length_CD)")
//            }
//        }
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        downLoader.removeFile(fileNamewithExtension: "\(cdu.getUserDefaults().homeFieldICAO_UD).json")
//        cdu.deleteAllFromDB(moc: moc)
//        downLoader.removeFile(fileNamewithExtension: "\(state).json")
        downLoader.printAvailableDownloads()
        
    }
    
    func retrieveFromDB() {
        let airportRequest: NSFetchRequest<AirfieldCD> = AirfieldCD.fetchRequest()
        airportRequest.returnsObjectsAsFaults = true
        var airportICAOArray = [AirfieldCD]()
        do {
            airportICAOArray = try moc.fetch(airportRequest)
            for i in airportICAOArray {
                if let icao = i.icao_CD {
                    print(icao)
                }
            }
        } catch {
            print(error)
        }
    }
    
    }
