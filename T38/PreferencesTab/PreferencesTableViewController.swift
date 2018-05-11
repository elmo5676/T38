//
//  PreferencesTableViewController.swift
//  T38
//
//  Created by elmo on 5/10/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import CoreData

class PreferencesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    }


    var airport: [NSManagedObject] = []
    var downLoader = JSONHandler()
    var cdu = CoreDataUtilies()
    var moc: NSManagedObjectContext!
    var dafifUrlJSONBase = "http://getatis.com/DAFIF/GetAirfieldsByState?state="
    var weatherUrlJSONBase = "https://www.getatis.com/services/GetMETAR?stations="
    //    var homeStation =
    var state = "CA"
    
    var cw: Weather?
    
    
    
    
    @IBAction func first_Button(_ sender: Any) {
        //        cdu.loadToDBFromJSON(state, moc: moc)
        //        cdu.printResults(moc: moc)
        
        
        cdu.loadJSONInBackground(state: state)
        
        //        DispatchQueue.global().async {
        //            var moc2: NSManagedObjectContext
        //
        //            self.cdu.loadToDBFromJSON(self.state, moc: moc2)
        //
        //            DispatchQueue.main.async {
        //                self.cdu.printResults(moc: moc2)
        //            }
        //        }
        //        cdu.loadJSONInBackground(state: state, moc: moc)
        
        
        
        //        downLoader.removeFile(fileNamewithExtension: "\(cdu.getUserDefaults().homeFieldICAO_UD).json")
        //        downLoader.downloadWeather(baseUrl: cdu.getUserDefaults().baseWeatherUrl_UD, icao: cdu.getUserDefaults().homeFieldICAO_UD)
        //        print(downLoader.currentWeather(icao: cdu.getUserDefaults().homeFieldICAO_UD))
        //        downLoader.downloadAllStates(baseUrl: dafifUrlJSONBase)
        //        print(loadCD.checkIfCoreDataIsLoaded(moc: moc))
        //        downLoader.printAvailableDownloads()
    }
    
    @IBAction func second_Button(_ sender: Any) {
        cdu.printResults(moc: moc)
        
        
        //        print(downLoader.currentWeather(icao: "KBAB"))
        //        print(downLoader.currentWeather(icao: cdu.getUserDefaults().homeFieldICAO_UD))
        //        var resultsDict = [AirfieldCD:[RunwayCD]]()
        ////        resultsDict = cdu.getAirfieldAndRunwaysWithRWYLengthGreaterThanOrEqualTo(moc: moc)
        //        resultsDict = cdu.getAirfieldByICAO("KBAB", moc: moc)
        //        for (key, value) in resultsDict {
        //            print("Airfield ID: \(key.icao_CD!)")
        //            for runway in value {
        //                print("Runway Hi ID: \(runway.highID_CD!), Runway Length: \(runway.length_CD)")
        //                print("Runway Low ID: \(runway.lowID_CD!), Runway Length: \(runway.length_CD)")
        //            }
        //        }
    }
    
    @IBAction func third_Button(_ sender: Any) {
        cdu.deleteAllFromDB(moc: moc)
        cdu.printResults(moc: moc)
        
        
        //        downLoader.removeFile(fileNamewithExtension: "\(cdu.getUserDefaults().homeFieldICAO_UD).json")
        //        downLoader.removeFile(fileNamewithExtension: "\(state).json")
        //        downLoader.removeAllFiles()
        //        downLoader.printAvailableDownloads()
        
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
    
 
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 9
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
