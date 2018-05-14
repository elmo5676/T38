//////
//////  Scrap.swift
//////  T38
//////
//////  Created by elmo on 5/9/18.
//////  Copyright © 2018 elmo. All rights reserved.
//////
////
////import Foundation
////
//class Scrap {
//    
//    
//    
////    func <#BackgroundFunction#>() {
////        var container: NSPersistentContainer? = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
////        
////        
////        //this is for CoreData Stuff
////        container?.performBackgroundTask({ context in
////            self.<#functionToBeDonOnBackgroundThread#>(moc: context)
////            
////            DispatchQueue.main.async {
////                self.<#functionDoneAfterAboveIsComplete#>(moc: context)
////            }})
////        
////        
////        //This is for non CoreData stuff
////        DispatchQueue.global().async {
////            self.<#functionToBeDonOnBackgroundThread#>(moc: context)
////            DispatchQueue.main.async {
////                self.<#functionDoneAfterAboveIsComplete#>(moc: context)
////            }}}
////    
////
//    
//    
//    //
//    //  NearestTableViewController.swift
//    //  T38
//    //
//    //  Created by elmo on 3/27/18.
//    //  Copyright © 2018 elmo. All rights reserved.
//    
//    import UIKit
//    import CoreData
//    import CoreLocation
//    
//    class NearestTableViewController: UITableViewController, CLLocationManagerDelegate {
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            
//            updateUI()
//            moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//            guard let model = moc.persistentStoreCoordinator?.managedObjectModel,
//                let fetchAllAirports = model.fetchRequestTemplate(forName: "FetchAllAirports") as? NSFetchRequest<AirfieldCD> else {
//                    return
//            }
//            
//            
//            tableView.rowHeight = 80
//            self.fetchAllAirports = fetchAllAirports
//        }
//        
//        override func viewWillAppear(_ animated: Bool) {
//            fetchAndSortByDistance()
//            tableView.reloadData()
//        }
//        
//        //    func rangeAndBearing(latitude_01: Double, longitude_01: Double, latitude_02: Double, longitude_02: Double) -> (range: Double, bearing: Double) {
//        //        let majEarthAxis_WGS84: Double = 6_378_137.0                // maj      - meters
//        //        let minEarthAxis_WGS84: Double = 6_356_752.314_245          // min      - meters
//        //        let lat_01 = latitude_01.degreesToRadians
//        //        let lat_02 = latitude_02.degreesToRadians
//        //        let long_01 = longitude_01.degreesToRadians
//        //        let long_02 = longitude_02.degreesToRadians
//        //        let difLong = (longitude_02 - longitude_01).degreesToRadians
//        //        //1: radiusCorrectionFactor()
//        //        let a1 = 1.0/(majEarthAxis_WGS84 * majEarthAxis_WGS84)
//        //        let b1 = (tan(lat_01) * tan(lat_01)) / (minEarthAxis_WGS84 * minEarthAxis_WGS84)
//        //        let c1 = 1.0/((a1+b1).squareRoot())
//        //        let d1 = c1/(cos(lat_01))
//        //        //2: Law of Cosines
//        //        let range = (acos(sin(lat_01)*sin(lat_02) + cos(lat_01)*cos(lat_02) * cos(difLong)) * d1).metersToNauticalMiles
//        //        //3: Calculating Bearing from 1st coords to second
//        //        let a3 = sin(long_02 - long_01) * cos(lat_02)
//        //        let b3 = cos(lat_01) * sin(lat_02) - sin(lat_01) * cos(lat_02) * cos(long_02 - long_01)
//        //        let bearing = ((atan2(a3, b3).radiansToDegrees) + 360).truncatingRemainder(dividingBy: 360) //Might need mag variation here
//        //        let results = [range, bearing]
//        //        print(range)
//        //        return (range: results[0], bearing: results[1])
//        //    }
//        
//        
//        
//        // MARK: CoreData Variables
//        var moc: NSManagedObjectContext!
//        var airfields: [AirfieldCD] = []
//        var airportsSorted = [AirfieldCD:Double]()
//        //    var airportsSorted = [AirfieldCD:[Double]]()
//        var fetchAllAirports: NSFetchRequest<AirfieldCD>?
//        
//        var cdu = CoreDataUtilies()
//        
//        // MARK: Location Variables
//        let locManager = CLLocationManager()
//        var deviceLat = 0.0
//        var deviceLong = 0.0
//        var deviceAlt = 0.0
//        var range = 0.0
//        var bearing = 0.0
//        
//        
//        
//        // MARK: CoreData Functions
//        
//        func fetchAndSortByDistance() {
//            getLocationInformation()
//            do {
//                airfields = cdu.getAirfieldWithRWYLengthGreaterThanOrEqualToUserDefaultsRWYLength(moc: moc)
//                var preSorted = [AirfieldCD:[Double]]()
//                for airport in airfields {
//                    let dictKey = cdu.distanceAway(deviceLat: deviceLat, deviceLong: deviceLong, airport: airport).airport
//                    let dictValue_0 = cdu.distanceAway(deviceLat: deviceLat, deviceLong: deviceLong, airport: airport).distanceAway
//                    let dictValue_1 = cdu.distanceAway(deviceLat: deviceLat, deviceLong: deviceLong, airport: airport).bearing
//                    let dictValue = [dictValue_0, dictValue_1]
//                    preSorted.updateValue(dictValue, forKey: dictKey)
//                }
//                let airportICAO = preSorted.keys.sorted{(preSorted[$0]?.first!)! < (preSorted[$1]?.first!)!}
//                airfields = airportICAO.filter({$0.icao_CD != "" })
//                
//                print("\(deviceLat) : \(deviceLong)")
//            }}
//        
//        
//        //    func fetchAndSortByDistance() {
//        //        getLocationInformation()
//        //        do {
//        //            airfields = cdu.getAirfieldWithRWYLengthGreaterThanOrEqualToUserDefaultsRWYLength(moc: moc)
//        //            var preSorted = [AirfieldCD:Double]()
//        //            for airport in airfields {
//        //                let dictKey = cdu.distanceAway(deviceLat: deviceLat, deviceLong: deviceLong, airport: airport).airport
//        //                let dictValue = cdu.distanceAway(deviceLat: deviceLat, deviceLong: deviceLong, airport: airport).distanceAway
//        //                preSorted.updateValue(dictValue, forKey: dictKey)
//        //            }
//        //            let airportICAO = preSorted.keys.sorted{preSorted[$0]! < preSorted[$1]!}
//        //            airfields = airportICAO.filter({$0.icao_CD != "" })
//        //
//        //            print("\(deviceLat) : \(deviceLong)")
//        //        } catch let error as NSError {
//        //            print("Could not fetch \(error), \(error.userInfo)")
//        //        }}
//        
//        
//        //    func fetchAndSortByDistance() {
//        //        guard let fetchRequest = fetchAllAirports else { return }
//        //        getLocationInformation()
//        //        do {
//        //            airfields = try moc.fetch(fetchRequest)
//        //            var preSorted = [AirfieldCD:Double]()
//        //            for airport in airfields {
//        //                let dictValue = cdu.distanceAway(deviceLat: deviceLat, deviceLong: deviceLong, airport: airport).airport
//        //                let dictKey = cdu.distanceAway(deviceLat: deviceLat, deviceLong: deviceLong, airport: airport).distanceAway
//        //                preSorted.updateValue(dictKey, forKey: dictValue)
//        //            }
//        //            let airportICAO = preSorted.keys.sorted{preSorted[$0]! < preSorted[$1]!}
//        //            airfields = airportICAO.filter({$0.icao_CD != "" })
//        //
//        //            print("\(deviceLat) : \(deviceLong)")
//        //        } catch let error as NSError {
//        //            print("Could not fetch \(error), \(error.userInfo)")
//        //        }}
//        
//        // MARK: Location Functions
//        func getLocationInformation() {
//            if let loc = locManager.location {
//                locManager.requestAlwaysAuthorization()
//                locManager.requestWhenInUseAuthorization()
//                self.deviceLat = loc.coordinate.latitude
//                self.deviceLong = loc.coordinate.longitude
//                self.deviceAlt = loc.altitude
//            }}
//        
//        func printResults(){
//            for airport in airfields {
//                deviceLat = (locManager.location?.coordinate.latitude)!
//                deviceLong = (locManager.location?.coordinate.longitude)!
//                print("\(String(describing: airport.icao_CD)) : \(cdu.distanceAway(deviceLat: deviceLat, deviceLong: deviceLong, airport: airport).distanceAway)")
//            }}
//        
//        // MARK: Seque
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            switch segue.identifier {
//            case "nearestDetail"?:
//                let row = self.tableView.indexPathForSelectedRow?.row
//                let selectedAirfield = airfields[row!] //else {print("No Airfield Found"); return }
//                let destinationViewController = segue.destination as! AirfieldInfoViewController
//                destinationViewController.currentAirport = selectedAirfield
//                destinationViewController.myLat = self.deviceLat
//                destinationViewController.myLong = self.deviceLong
//            default:
//                preconditionFailure("Unexpected segue identifier")
//            }}
//        
//        
//        
//        
//        // MARK: - TableView & UI
//        @IBOutlet var tableViewOutlet: UITableView!
//        @IBAction func dismissButton(_ sender: UIBarButtonItem) {
//            presentingViewController?.dismiss(animated: true, completion: nil)
//        }
//        override func numberOfSections(in tableView: UITableView) -> Int {
//            return 1
//        }
//        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return airfields.count
//        }
//        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "NearestTableViewCell", for: indexPath) as! NearestTableViewCell
//            
//            //        range = rangeAndBearing(latitude_01: deviceLat, longitude_01: deviceLong, latitude_02: airfields[indexPath.row].latitude_CD, longitude_02: airfields[indexPath.row].longitude_CD).range
//            //        bearing = rangeAndBearing(latitude_01: deviceLat, longitude_01: deviceLong, latitude_02: airfields[indexPath.row].latitude_CD, longitude_02: airfields[indexPath.row].longitude_CD).bearing
//            cell.icaoLabel.text = airfields[indexPath.row].icao_CD
//            
//            let b = airfields[indexPath.row].
//            
//            cell.bearingLabel.text = String(format: "%.0f",bearing) + "°"
//            cell.rangeLabel.text = String(format: "%.0f",range) + " NM"
//            cell.directToButtonOutlet.layer.cornerRadius = 0
//            return cell
//        }
//        private func updateUI(){
//            if presentationController is UIPopoverPresentationController {
//                view.backgroundColor = .clear
//            } else { view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }}
//        func alertPostition(){
//            let alertController = UIAlertController(title: "No Position", message:
//                "To use this function, the device must be able to determin it's location", preferredStyle: UIAlertControllerStyle.alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
//        }
//    }
//
//
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
////*********************************** PreferencesViewController **************************************************
////        downLoader.downloadAllStates(baseUrl: baseUrlJSON)
////        downLoader.printAvailableDownloads()
////        var airfields = [AirfieldCD]()
////        let fetchRequest = NSFetchRequest<AirfieldCD>(entityName: "AirfieldCD")
////        do {
////            airfields = try moc.fetch(fetchRequest)
////        } catch let error as NSError {
////            print("\(error)")
////        }
////
////        print(airfields[0].runways_CD)
////        print(airfields[0].runways_R_CD)
//
//
////        let runwaysArray = cdu.getRunwaysGreaterThan(5000.0, moc: moc)
////        for runway in runwaysArray {
////            print(runway.airfields_R_CD)
////        }
////        print(runwaysArray)
//
////        print(runwaysArray.count)
////        for runway in runwaysArray {
////            print("Runway Length: \(runway.length_CD)")
//////            print("*******************************************************")
//////            print("Runway ID: \(runway.id_CD)")
//////            print("Runway Length: \(runway.length_CD)")
//////            print("Runway Width: \(runway.width_CD)")
//////            print("Runway Condition: \(String(describing: runway.runwayCondition_CD))")
//////            print("Runway Surfacetype: \(String(describing: runway.surfaceType_CD))")
//////            print("Hi ID: \(runway.highID_CD as Any)")
//////            print("Hi Latitude: \(runway.coordLatHi_CD)")
//////            print("Hi Longitude: \(runway.coordLonHi_CD)")
//////            print("Hi Elevation: \(runway.elevHi_CD)")
//////            print("Hi Mag HDG: \(runway.magHdgHi_CD)")
//////            print("Hi True HDG: \(runway.trueHdgHi_CD)")
//////            print("Hi TDZE: \(runway.tdzeHi_CD)")
//////            print("Hi Slope: \(runway.slopeHi_CD)")
//////            print("Hi Overrun Length: \(runway.overrunHiLength_CD)")
//////            print("Hi Overrun Type: \(String(describing: runway.overrunHiType_CD))")
//////            print("Low ID: \(String(describing: runway.lowID_CD))")
//////            print("Low Latitude: \(runway.coordLatLow_CD)")
//////            print("Low Longitude: \(runway.coordLonLow_CD)")
//////            print("Low Latitude: \(runway.elevLow_CD)")
//////            print("Low Mag HDG: \(runway.magHdgLow_CD)")
//////            print("Low True HDG: \(runway.trueHdgLow_CD)")
//////            print("Low TDZE: \(runway.tdzeLow_CD)")
//////            print("Low Slope: \(runway.slopeLow_CD)")
//////            print("Low Overrun Length: \(runway.overrunLowLength_CD)")
//////            print("Low Overrun Type: \(String(describing: runway.overrunLowType_CD))")
//////            print("*******************************************************")
////        }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
////*********************************** XXXXXXXXXXXXXXXX **************************************************
