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
    var downLoader = JSONDownLoader()
    var cdu = CoreDataUtilies()
    var moc: NSManagedObjectContext!
    var baseUrlJSON = "http://getatis.com/DAFIF/GetAirfieldsByState?state="
    var state = "CA"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    
    @IBAction func addButton(_ sender: Any) {
        cdu.loadToDBFromJSON(state, moc: moc)
//        downLoader.downloadAllStates(baseUrl: baseUrlJSON)

//        print(loadCD.checkIfCoreDataIsLoaded(moc: moc))
        cdu.printResults(moc: moc)
//        downLoader.printAvailableDownloads()
        
    }
    
    
    @IBAction func printButton(_ sender: Any) {
        cdu.printResults(moc: moc)
        var airfieldIDSet = Set<Int32>()
        
        
        
        let runways = cdu.getRunwaysGreaterThan(13000.0, moc: moc)
        for runway in runways {
            print(runway.airfieldID_CD)
            airfieldIDSet.insert(runway.airfieldID_CD)

        }
        
        for airfield in airfieldIDSet {
            let airfields = cdu.getAirfieldsForRunwayReturnOf(airfieldID: airfield, moc: moc)
            for airfield in airfields {
                print(airfield.icao_CD!)
            }
        }
    
        
        
        
        
        
        
        
        
        
        

        
        

        
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        cdu.deleteAllFromDB(moc: moc)
//        downLoader.removeAllFiles()
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
