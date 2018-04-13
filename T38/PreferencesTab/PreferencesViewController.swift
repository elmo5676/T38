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

    var moc: NSManagedObjectContext!
    var airport: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    
    @IBAction func addButton(_ sender: Any) {
        loadToDBFromJSON()
    }
    
    
    @IBAction func printButton(_ sender: Any) {
        retrieveFromDB()
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        deleteAllFromDB()
    }
    
    func retrieveFromDB() {
        let airportRequest: NSFetchRequest<AirportCD> = AirportCD.fetchRequest()
        airportRequest.returnsObjectsAsFaults = true
        var airportICAOArray = [AirportCD]()
        do {
            airportICAOArray = try moc.fetch(airportRequest)
            for i in airportICAOArray {
                if let icao = i.icaoID_CD {
                    print(icao)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func deleteAllFromDB() {
        let deleteAirPort = NSBatchDeleteRequest(fetchRequest: AirportCD.fetchRequest())
        let deleteRunway = NSBatchDeleteRequest(fetchRequest: RunwayCD.fetchRequest())
        do {
            try moc.execute(deleteAirPort)
            try moc.execute(deleteRunway)
            try moc.save()
        } catch {
            print("Nope")
        }
        
    }
    
    func loadToDBFromJSON(){
        let airportURL = Bundle.main.url(forResource: "Airports", withExtension: "json")!
        let runwayURL = Bundle.main.url(forResource: "Runways", withExtension: "json")!
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(Airport.self, from: Data(contentsOf: airportURL))
            for airport in result.features {
                let airportDB = AirportCD(context: moc)
                airportDB.objectID_CD = Int32(airport.properties.objectid)
                airportDB.globalID_CD = airport.properties.globalID
                airportDB.ident_CD = airport.properties.ident
                airportDB.name_CD = airport.properties.name
                airportDB.latitude_CD = airport.properties.latitude
                airportDB.longitude_CD = airport.properties.longitude
                airportDB.elevation_CD = airport.properties.elevation
                airportDB.icaoID_CD = airport.properties.icaoID
                airportDB.typeCode_CD = airport.properties.typeCode.rawValue
                airportDB.serviceCity_CD = airport.properties.servcity
                airportDB.state_CD = airport.properties.state.map { $0.rawValue }
                airportDB.country_CD = airport.properties.country.rawValue
                airportDB.operStatus_CD = airport.properties.operstatus.rawValue
                airportDB.privateUse_CD = Int32(airport.properties.privateuse)
                airportDB.iapExists_CD = Int32(airport.properties.iapexists)
                airportDB.dodHiFlip_CD = Int32(airport.properties.dodhiflip)
                airportDB.far91_CD = Int32(airport.properties.far91)
                airportDB.far93_CD = Int32(airport.properties.far93)
                airportDB.milCode_CD = airport.properties.milCode.rawValue
                airportDB.airAnal_CD = airport.properties.airanal.rawValue
                airportDB.usHigh_CD = Int32(airport.properties.usHigh)
                airportDB.usLow_CD = Int32(airport.properties.usLow)
                airportDB.akHigh_CD = Int32(airport.properties.akHigh)
                airportDB.akLow_CD = Int32(airport.properties.akLow)
                airportDB.usArea_CD = Int32(airport.properties.usArea)
                airportDB.pacific_CD = Int32(airport.properties.pacific)
                airportDB.geometryCoordinates_CD = airport.geometry.coordinates as NSObject
                try moc.save()
            }
        } catch {
            print(error)
        }
        
        
        do {
            let result = try decoder.decode(Runway.self, from: Data(contentsOf: runwayURL))
            for runway in result.features {
                let runwayDB = RunwayCD(context: moc)
                runwayDB.objectID_CD = Int32(runway.properties.objectid)
                runwayDB.globalID_CD = runway.properties.globalID
                runwayDB.airportID_CD = runway.properties.airportID
                runwayDB.designator_CD = runway.properties.designator
                runwayDB.length_CD = Int32(runway.properties.length)
                runwayDB.width_CD = Int32(runway.properties.width)
                runwayDB.dimUom_CD = runway.properties.dimUom.rawValue
                runwayDB.akLow_CD = Int32(runway.properties.akLow)
                runwayDB.akHigh_CD = Int32(runway.properties.akHigh)
                runwayDB.usLow_CD = Int32(runway.properties.usLow)
                runwayDB.usHigh_CD = Int32(runway.properties.usHigh)
                runwayDB.usArea_CD = Int32(runway.properties.usArea)
                runwayDB.pacific_CD = Int32(runway.properties.pacific)
                runwayDB.shapeArea_CD = runway.properties.shapeArea
                runwayDB.shapeLength_CD = runway.properties.shapeLength
                runwayDB.geometryCoordinates_CD = runway.geometry.coordinates as NSObject
                try moc.save()
            }
        } catch {
            print(error)
        }
        do {
            try moc.save()
        } catch {
            print(error)
        }}
    

}
