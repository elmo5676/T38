//
//  NearestTableViewController.swift
//  T38
//
//  Created by elmo on 3/27/18.
//  Copyright © 2018 elmo. All rights reserved.

import UIKit
import CoreData
import CoreLocation

class NearestTableViewController: UITableViewController, CLLocationManagerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        guard let model = moc.persistentStoreCoordinator?.managedObjectModel,
            let fetchAllAirports = model.fetchRequestTemplate(forName: "FetchAllAirports") as? NSFetchRequest<AirfieldCD> else {
                return
        }
        self.fetchAllAirports = fetchAllAirports
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAndSortByDistance()
        tableView.reloadData()
    }
   
    // MARK: CoreData Variables
    var moc: NSManagedObjectContext!
    var airfields: [AirfieldCD] = []
    var airportsSorted = [AirfieldCD:Double]()
    var fetchAllAirports: NSFetchRequest<AirfieldCD>?
    
    var cdu = CoreDataUtilies()
    
    // MARK: Location Variables
    let locManager = CLLocationManager()
    var deviceLat = 0.0
    var deviceLong = 0.0
    var deviceAlt = 0.0
    
    
    
    // MARK: CoreData Functions
    func fetchAndSortByDistance() {
//        guard let fetchRequest = fetchAllAirports else { return }
        getLocationInformation()
        do {
            airfields = cdu.getAirfieldWithRWYLengthGreaterThanOrEqualToUserDefaultsRWYLength(moc: moc)
            var preSorted = [AirfieldCD:Double]()
            for airport in airfields {
                let dictValue = cdu.distanceAway(deviceLat: deviceLat, deviceLong: deviceLong, airport: airport).airport
                let dictKey = cdu.distanceAway(deviceLat: deviceLat, deviceLong: deviceLong, airport: airport).distanceAway
                preSorted.updateValue(dictKey, forKey: dictValue)
            }
            let airportICAO = preSorted.keys.sorted{preSorted[$0]! < preSorted[$1]!}
            airfields = airportICAO.filter({$0.icao_CD != "" })
            
            print("\(deviceLat) : \(deviceLong)")
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }}
    
    
//    func fetchAndSortByDistance() {
//        guard let fetchRequest = fetchAllAirports else { return }
//        getLocationInformation()
//        do {
//            airfields = try moc.fetch(fetchRequest)
//            var preSorted = [AirfieldCD:Double]()
//            for airport in airfields {
//                let dictValue = cdu.distanceAway(deviceLat: deviceLat, deviceLong: deviceLong, airport: airport).airport
//                let dictKey = cdu.distanceAway(deviceLat: deviceLat, deviceLong: deviceLong, airport: airport).distanceAway
//                preSorted.updateValue(dictKey, forKey: dictValue)
//            }
//            let airportICAO = preSorted.keys.sorted{preSorted[$0]! < preSorted[$1]!}
//            airfields = airportICAO.filter({$0.icao_CD != "" })
//
//            print("\(deviceLat) : \(deviceLong)")
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }}
    
    // MARK: Location Functions
    func getLocationInformation() {
        if let loc = locManager.location {
            locManager.requestAlwaysAuthorization()
            locManager.requestWhenInUseAuthorization()
            self.deviceLat = loc.coordinate.latitude
            self.deviceLong = loc.coordinate.longitude
            self.deviceAlt = loc.altitude
        }}
        
    func printResults(){
        for airport in airfields {
            deviceLat = (locManager.location?.coordinate.latitude)!
            deviceLong = (locManager.location?.coordinate.longitude)!
            print("\(String(describing: airport.icao_CD)) : \(cdu.distanceAway(deviceLat: deviceLat, deviceLong: deviceLong, airport: airport).distanceAway)")
        }}
    
    // MARK: Seque
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "nearestDetail"?:
            let row = self.tableView.indexPathForSelectedRow?.row
            let selectedAirfield = airfields[row!] //else {print("No Airfield Found"); return }
            let destinationViewController = segue.destination as! AirfieldInfoViewController
            destinationViewController.currentAirport = selectedAirfield
            destinationViewController.myLat = self.deviceLat
            destinationViewController.myLong = self.deviceLong
        default:
            preconditionFailure("Unexpected segue identifier")
        }}

    
    

    // MARK: - TableView & UI
    @IBOutlet var tableViewOutlet: UITableView!
    @IBAction func dismissButton(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return airfields.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Nearest")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Nearest");
        }
        cell!.textLabel?.text = airfields[indexPath.row].icao_CD
        return cell!
    }
    private func updateUI(){
        if presentationController is UIPopoverPresentationController {
            view.backgroundColor = .clear
        } else { view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }}
    func alertPostition(){
        let alertController = UIAlertController(title: "No Position", message:
            "To use this function, the device must be able to determin it's location", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
    }
}
