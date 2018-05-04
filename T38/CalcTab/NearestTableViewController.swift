//
//  NearestTableViewController.swift
//  T38
//
//  Created by elmo on 3/27/18.
//  Copyright © 2018 elmo. All rights reserved.
//


//        let allICAO2s = airfields.map {$0.ICAO ?? "Default"}
//        let allNewICAOS = airfields.filter {$0.ICAO != nil}//.map {$0.ICAO!}
//        let newOne = allICAO2s[0]
//        let allNewICAOS = airfields.map {$0}
//        let airfieldInfoFull = allNewICAOS
//        let new = allNewICAOS
//        let sortedArray = Array(preSorted).sorted{$0.1 < $1.1}

import UIKit
import CoreData
import CoreLocation

class NearestTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadAirports()
        updateUI()
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        guard let model = moc.persistentStoreCoordinator?.managedObjectModel,
            let fetchAllAirports = model.fetchRequestTemplate(forName: "FetchAllAirports") as? NSFetchRequest<AirportCD> else {
                return
        }
        self.fetchAllAirports = fetchAllAirports
        fetchAndReload()
    }
    
    
    var moc: NSManagedObjectContext!
    var airports: [AirportCD] = []
    var airportsSorted = [AirportCD:Double]()
    var fetchAllAirports: NSFetchRequest<AirportCD>?
    
    var loadCD = LoadCD()
    let myLat = 39.119150812
    let myLong = -121.539447243
 
    
    func printResults(){
        for airport in airports {
            print("\(String(describing: airport.icaoID_CD)) : \(distanceAway(deviceLat: myLat, deviceLong: myLong, airport: airport).distanceAway)")
        }
    }
    
    func fetchAndReload() {
        guard let fetchRequest = fetchAllAirports else {
            return
        }
        do {
            airports = try moc.fetch(fetchRequest)
            var preSorted = [AirportCD:Double]()
            for airport in airports {
                let dictValue = distanceAway(deviceLat: myLat, deviceLong: myLong, airport: airport).airport
                let dictKey = distanceAway(deviceLat: myLat, deviceLong: myLong, airport: airport).distanceAway
                preSorted.updateValue(dictKey, forKey: dictValue)
            }
            let airportICAO = preSorted.keys.sorted{preSorted[$0]! < preSorted[$1]!}
            airports = airportICAO.filter({$0.icaoID_CD != nil })
            tableView.reloadData()
//            printResults()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    
    private func updateUI(){
        if presentationController is UIPopoverPresentationController {
            view.backgroundColor = .clear
        } else {
            view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }

    @IBOutlet var tableViewOutlet: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "nearestDetail"?:
            let row = self.tableView.indexPathForSelectedRow?.row
            let selectedAirfield = airports[row!] //else {print("No Airfield Found"); return }
            let destinationViewController = segue.destination as! AirfieldInfoViewController
            destinationViewController.currentAirport = selectedAirfield
            destinationViewController.myLat = self.myLat
            destinationViewController.myLong = self.myLong
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }

    func distanceAway(deviceLat lat: Double, deviceLong long: Double, airport: AirportCD) -> (airport: AirportCD, distanceAway: Double) {
        let airportLat = airport.geometryCoordinates_CD[1]
        let airportLong = airport.geometryCoordinates_CD[0]
        let myCoords =  CLLocation(latitude: lat, longitude: long)
        let airportCoords = CLLocation(latitude: airportLat, longitude: airportLong)
        let distanceAwayInNM = myCoords.distance(from: airportCoords).metersToNauticalMiles
        //airportDictEntry[airport] = distanceAwayInNM
        return (airport, distanceAwayInNM)
    }
    
    
    func loadAirports(){
//        let myLat = 39.0
//        let myLong = -121.0

    }

    // MARK: - Table view data
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return airports.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Nearest")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Nearest");
        }
        cell!.textLabel?.text = airports[indexPath.row].icaoID_CD
        return cell!
    }
    
    @IBAction func dismissButton(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    


}
