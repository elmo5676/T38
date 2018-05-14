//
//  RunwayChoicesTableViewController.swift
//  T38
//
//  Created by elmo on 5/10/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import CoreData

class RunwayChoicesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

//        guard let model = moc.persistentStoreCoordinator?.managedObjectModel,
//            let fetchAllAirports = model.fetchRequestTemplate(forName: "FetchAllAirports") as? NSFetchRequest<AirfieldCD> else {
//                return

        self.title = "Test"
//        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        currentWeather = jsonD.currentWeather(icao: cdu.getUserDefaults().homeFieldICAO_UD)
    }

 
    
    @IBAction func dismissButton(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    var rwyID = ""
    var xWind = 0.0
    var hWind = 0.0
    var length = 0.0
    var heading = 0.0
    
    
    var moc: NSManagedObjectContext!
    var currentFieldDict = [AirfieldCD:[RunwayCD]]()
    var airfields: [AirfieldCD] = []
    var runways: [RunwayCD] = []
    var fetchAllRunways: NSFetchRequest<RunwayCD>?
    var cdu = CoreDataUtilies()
    var currentWeather: Weather?
    var jsonD = JSONHandler()
    
//    func getWindInfoForRwyHeading(_ rwyHdg: Heading){
//        var wind = Wind(windHeading: Heading((Int((currentWeather?.metars.metar.windDirDegrees)!))!), windSpeed: Double(currentWeather?.metars.metar.windSpeedKt)!, runwayHeading: rwyHdg)
//
//    }
    
    
    
    // MARK: Runway Variables Here


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return runways.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "runwayCell", for: indexPath) as! RunwayCell

        cell.hi_RwyButtonOutlet.setTitle(runways[indexPath.row].highID_CD, for: .normal)
        cell.hi_RwyHwind.text = "X-Wind"
        cell.hi_RwyXwind.text = "H-Wind"
        
        
        cell.lengthLabel.text = String(format: "%.0f", runways[indexPath.row].length_CD) + " Ft"
        
        
        
        cell.low_RwyButtonOutlet.setTitle(runways[indexPath.row].lowID_CD, for: .normal)
        cell.low_RwyXwind.text = "X-Wind"
        cell.low_RwyHwind.text = "H-Wind"
        return cell
    }

}
