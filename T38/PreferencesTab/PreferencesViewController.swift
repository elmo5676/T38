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
    var loadCD = LoadCD()
    var moc: NSManagedObjectContext!
    var baseUrlJSON = "http://getatis.com/DAFIF/GetAirfieldsByState?state="
    var state = "CA"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    
    @IBAction func addButton(_ sender: Any) {
        loadCD.loadToDBFromJSON(state, moc: moc)
//        downLoader.downloadAllStates(baseUrl: baseUrlJSON)

//        print(loadCD.checkIfCoreDataIsLoaded(moc: moc))
        loadCD.printResults(moc: moc)
//        downLoader.printAvailableDownloads()
        
    }
    
    
    @IBAction func printButton(_ sender: Any) {
        downLoader.printAvailableDownloads()
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        downLoader.removeAllFiles()
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
    
    func deleteAllFromDB() {
        let deleteAirPort = NSBatchDeleteRequest(fetchRequest: AirfieldCD.fetchRequest())
        let deleteRunway = NSBatchDeleteRequest(fetchRequest: RunwayCD.fetchRequest())
        let deleteNavaids = NSBatchDeleteRequest(fetchRequest: NavaidCD.fetchRequest())
        let deleteFreqs = NSBatchDeleteRequest(fetchRequest: CommunicationCD.fetchRequest())
        do {
            try moc.execute(deleteAirPort)
            try moc.execute(deleteRunway)
            try moc.execute(deleteNavaids)
            try moc.execute(deleteFreqs)
            try moc.save()
        } catch {
            print("Nope")
        }
        
    }
}
