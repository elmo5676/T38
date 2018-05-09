//
//  CoreDataUtilies.swift
//  T38
//
//  Created by elmo on 5/3/18.
//  Copyright © 2018 elmo. All rights reserved.
//

//import Foundation
import UIKit
import CoreData
import CoreLocation

class CoreDataUtilies {
    func mocSave(moc: NSManagedObjectContext){
        do {
            try moc.save()
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }}
    
    
    func printResults(moc: NSManagedObjectContext) {
        do {
            let runwayRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RunwayCD")
            let runwayCount = try moc.count(for: runwayRequest)
            print("Number of Runways: \(runwayCount)")
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        do {
            let navRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NavaidCD")
            let navCount = try moc.count(for: navRequest)
            print("Number of Navaids: \(navCount)")
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        do {
            let comRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CommunicationCD")
            let comCount = try moc.count(for: comRequest)
            print("Number of Freqs: \(comCount)")
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        do {
            let airportValidationRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AirfieldCD")
            let airportCount = try moc.count(for: airportValidationRequest)
            print("Number of Airports: \(airportCount)")
        }   catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }}
    
    func distanceAway(deviceLat lat: Double, deviceLong long: Double, airport: AirfieldCD) -> (airport: AirfieldCD, distanceAway: Double) {
        let airportLat = airport.latitude_CD
        let airportLong = airport.longitude_CD
        let myCoords =  CLLocation(latitude: lat, longitude: long)
        let airportCoords = CLLocation(latitude: airportLat, longitude: airportLong)
        let distanceAwayInNM = myCoords.distance(from: airportCoords).metersToNauticalMiles
        return (airport, distanceAwayInNM)
    }
    
    func getRunwaysGreaterThan(_ length: Double, moc: NSManagedObjectContext) -> [RunwayCD] {
        var runways = [RunwayCD]()
        let runwayLengthFetchRequest = NSFetchRequest<RunwayCD>(entityName: "RunwayCD")
        let runwayLengthPredicate: NSPredicate = {
            return NSPredicate(format: "%K > %@", #keyPath(RunwayCD.length_CD), "\(length)")
        }()
        runwayLengthFetchRequest.predicate = runwayLengthPredicate
        do {
            runways = try moc.fetch(runwayLengthFetchRequest)
        } catch let error as NSError {
            print("Could not fetch the Runways: \(error) : \(error.userInfo)")
        }
        return runways
    }
    
    func getAirfieldsForRunwayReturnOf(airfieldID id: Int32, moc: NSManagedObjectContext) -> [AirfieldCD] {
        var airfields = [AirfieldCD]()
        let airfieldFetchRequest = NSFetchRequest<AirfieldCD>(entityName: "AirfieldCD")
        let airfieldPredicate: NSPredicate = {
            return NSPredicate(format: "%K = %@", #keyPath(AirfieldCD.id_CD),"\(id)")
        }()
        airfieldFetchRequest.predicate = airfieldPredicate
        do {
            airfields = try moc.fetch(airfieldFetchRequest)
        } catch let error as NSError {
            print("Could not fetch the Runways: \(error) : \(error.userInfo)")
        }
        return airfields
    }
    
    
    
    func checkIfCoreDataIsLoaded(moc: NSManagedObjectContext) -> Bool {
        var airportsLoaded = true
        var allLoaded = true
        do {
            let airportValidationRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AirfieldCD")
            let airportCount = try moc.count(for: airportValidationRequest)
            if airportCount > 0 {
                airportsLoaded = true
            } else {
                airportsLoaded = false
            }
        }   catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        if airportsLoaded == true  {
            allLoaded = true
        } else {
            allLoaded = false
        }
        return allLoaded
    }
    
    
    
    
    func loadToDBFromJSON(_ nameOfJSON: String, moc: NSManagedObjectContext){
        let documentsURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let airfieldstURL = documentsURL.appendingPathComponent(nameOfJSON).appendingPathExtension("json")
        //        let airfieldstURL = Bundle.main.url(forResource: nameOfJSON, withExtension: "json")!
        let decoder = JSONDecoder()
        var counter = 0
        do {
            let resultAirfields = try decoder.decode(Airfields.self, from: Data(contentsOf: airfieldstURL))
            for airfield in resultAirfields {
                let airfieldDB = AirfieldCD(context: moc)
                airfieldDB.country_CD = airfield.country
                airfieldDB.elevation_CD = airfield.elevation
                airfieldDB.faa_CD = airfield.faa
                airfieldDB.icao_CD = airfield.icao
                airfieldDB.id_CD = Int32(airfield.id)
                airfieldDB.latitude_CD = airfield.lat
                airfieldDB.longitude_CD = airfield.lon
                airfieldDB.mgrs_CD = airfield.mgrs
                airfieldDB.name_CD = airfield.name
                airfieldDB.state_CD = airfield.state
                airfieldDB.timeConversion_CD = airfield.timeConversion
                print(counter)
                counter += 1
                
                for runway in airfield.runways {
                    let runwayDB = RunwayCD(context: moc)
                    runwayDB.airfieldID_CD = airfieldDB.id_CD
                    runwayDB.id_CD = Int32(runway.id)
                    runwayDB.lowID_CD = runway.lowID
                    runwayDB.highID_CD = runway.highID
                    runwayDB.length_CD = runway.length
                    runwayDB.width_CD = runway.width
                    runwayDB.surfaceType_CD = runway.surfaceType
                    runwayDB.runwayCondition_CD = runway.runwayCondition
                    runwayDB.magHdgHi_CD = runway.magHdgHi
                    runwayDB.magHdgLow_CD = runway.magHdgLow
                    runwayDB.trueHdgHi_CD = runway.trueHdgHi
                    runwayDB.trueHdgLow_CD = runway.trueHdgLow
                    runwayDB.coordLatHi_CD = runway.coordLatHi
                    runwayDB.coordLatLow_CD = runway.coordLatLo
                    runwayDB.coordLonHi_CD = runway.coordLonHi
                    runwayDB.coordLonLow_CD = runway.coordLonLo
                    runwayDB.elevHi_CD = runway.elevHi
                    runwayDB.elevLow_CD = runway.elevLow
                    runwayDB.slopeHi_CD = runway.slopeHi
                    runwayDB.slopeLow_CD = runway.slopeLow
                    runwayDB.tdzeHi_CD = runway.tdzeHi
                    runwayDB.tdzeLow_CD = runway.tdzeLow
                    runwayDB.overrunHiLength_CD = runway.overrunHiLength
                    runwayDB.overrunLowLength_CD = runway.overrunLowLength
                    runwayDB.overrunHiType_CD = runway.overrunHiType
                    runwayDB.overrunLowType_CD = runway.overrunLowType
                    airfieldDB.addToRunways_R_CD(runwayDB)
                    try? moc.save()
                }
                
                for navaid in airfield.navaids {
                    let navaidDB = NavaidCD(context: moc)
                    navaidDB.airfieldID_CD = airfieldDB.id_CD
                    navaidDB.id_CD = Int32(navaid.id)
                    navaidDB.name_CD = navaid.name
                    navaidDB.ident_CD = navaid.ident
                    navaidDB.type_CD = navaid.type
                    navaidDB.lat_CD = navaid.lat
                    navaidDB.long_CD = navaid.lon
                    navaidDB.frequency_CD = navaid.frequency
                    navaidDB.channel_CD = Int32(navaid.channel)
                    navaidDB.tacanDMEMode_CD = navaid.tacanDMEMode
                    navaidDB.course_CD = Int32(navaid.course)
                    navaidDB.distance_CD = navaid.distance
                    airfieldDB.addToNavaids_R_CD(navaidDB)
                    try? moc.save()
                }

                for comm in airfield.communications {
                    let communicationDB = CommunicationCD(context: moc)
                    communicationDB.airfieldID_CD = airfieldDB.id_CD
                    communicationDB.id_CD = Int32(comm.id)
                    communicationDB.name_CD = comm.name
                    try? moc.save()
                    for freq in comm.freqs {
                        let freqDB = FreqCD(context: moc)
                        freqDB.communicationsId_CD = communicationDB.id_CD
                        freqDB.id_CD = Int32(freq.id)
                        freqDB.freq_CD = freq.freq
                        communicationDB.addToFreqs_R_CD(freqDB)
                        try? moc.save()
                    }
                    airfieldDB.addToCommunications_R_CD(communicationDB)
                    try? moc.save()
                }
            }
            try? moc.save()
        } catch {print(error)}
    }
    
    func deleteAllFromDB(moc: NSManagedObjectContext) {
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
































