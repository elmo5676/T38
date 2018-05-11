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
    
    
    // MARK: UserDefaults List
    let defaults = UserDefaults.standard
    //    var runwayLength: Double = 8000.0
    //    var homeAirfieldICAO: String = "KSMF"
    
    // MARK: Setting UserDefaults
    func setUserDefaults(runwayLength: Double,
                         homeAirfieldICAO: String,
                         baseWeatherUrl: String,
                         baseDafifUrl: String,
                         aeroBraking: String,
                         tempScaleCorF: String,
                         aircraftGrossWeight: String,
                         podInstalled: String,
                         weightOfCargoInPOD: String,
                         weightUsedForTOLD: String,
                         givenEngineFailure: String){
        
        defaults.set(runwayLength, forKey: "runwayLength_UD")
        defaults.set(homeAirfieldICAO, forKey: "homeAirfieldICAO_UD")
        defaults.set(baseWeatherUrl, forKey: "baseWeatherUrl_UD")
        defaults.set(baseDafifUrl, forKey: "baseDafifUrl_UD")
        defaults.set(aeroBraking, forKey: "aeroBraking_UD")
        defaults.set(tempScaleCorF, forKey: "tempScaleCorF_UD")
        defaults.set(aircraftGrossWeight, forKey: "aircraftGrossWeight_UD")
        defaults.set(podInstalled, forKey: "podInstalled_UD")
        defaults.set(weightOfCargoInPOD, forKey: "weightOfCargoInPOD_UD")
        defaults.set(weightUsedForTOLD, forKey: "weightUsedForTOLD_UD")
        defaults.set(givenEngineFailure, forKey: "givenEngineFailure_UD")
        //defaults.set(<#xxx#>, forKey: "<#xxx#>_UD")
    }
    
    // MARK: Getting UserDefaults
    func getUserDefaults() -> (runwayLength_UD: Double,
        homeFieldICAO_UD: String,
        baseWeatherUrl_UD: String,
        baseDafifUrl_UD: String,
        aeroBraking_UD: String,
        tempScaleCorF_UD: String,
        aircraftGrossWeight_UD: String,
        podInstalled_UD: String,
        weightOfCargoInPOD_UD: String,
        weightUsedForTOLD_UD: String,
        givenEngineFailure_UD: String){
            
            let runwayLength = defaults.double(forKey: "runwayLength_UD")
            let homeAirfieldICAO = defaults.string(forKey: "homeAirfieldICAO_UD")!
            let baseWeatherUrl = defaults.string(forKey: "baseWeatherUrl_UD")!
            let baseDafifUrl = defaults.string(forKey: "baseDafifUrl_UD")!
            let aeroBraking = defaults.string(forKey: "aeroBraking_UD")!
            let tempScaleCorF = defaults.string(forKey: "tempScaleCorF_UD")!
            let aircraftGrossWeight = defaults.string(forKey: "aircraftGrossWeight_UD")!
            let podInstalled = defaults.string(forKey: "podInstalled_UD")!
            let weightOfCargoInPOD = defaults.string(forKey: "weightOfCargoInPOD_UD")!
            let weightUsedForTOLD = defaults.string(forKey: "weightUsedForTOLD_UD")!
            let givenEngineFailure = defaults.string(forKey: "givenEngineFailure_UD")!
            //let <#xxxxx#> = defaults.string(forKey: "<#xxxxx#>_UD")!
            
            return (runwayLength_UD: runwayLength,
                    homeFieldICAO_UD: homeAirfieldICAO,
                    baseWeatherUrl_UD: baseWeatherUrl,
                    baseDafifUrl_UD: baseDafifUrl,
                    aeroBraking_UD: aeroBraking,
                    tempScaleCorF_UD: tempScaleCorF,
                    aircraftGrossWeight_UD: aircraftGrossWeight,
                    podInstalled_UD: podInstalled,
                    weightOfCargoInPOD_UD: weightOfCargoInPOD,
                    weightUsedForTOLD_UD: weightUsedForTOLD,
                    givenEngineFailure_UD: givenEngineFailure)
            //<#xxxxxx#>: <#xxxxxx#>,
    }
    
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
    
    // MARK: Calculations
    func distanceAway(deviceLat lat: Double, deviceLong long: Double, airport: AirfieldCD) -> (airport: AirfieldCD, distanceAway: Double) {
        let airportLat = airport.latitude_CD
        let airportLong = airport.longitude_CD
        let myCoords =  CLLocation(latitude: lat, longitude: long)
        let airportCoords = CLLocation(latitude: airportLat, longitude: airportLong)
        let distanceAwayInNM = myCoords.distance(from: airportCoords).metersToNauticalMiles
        return (airport, distanceAwayInNM)
    }
    
    // MARK: CD Queries
    func getRunwaysGreaterThanOrEqualToUserDefaultsRWYLength(moc: NSManagedObjectContext) -> [RunwayCD] {
        let runwayLength = getUserDefaults().runwayLength_UD
        var runways = [RunwayCD]()
        let runwayLengthFetchRequest = NSFetchRequest<RunwayCD>(entityName: "RunwayCD")
        let runwayLengthPredicate: NSPredicate = {
            return NSPredicate(format: "%K => %@", #keyPath(RunwayCD.length_CD), "\(runwayLength)")
        }()
        runwayLengthFetchRequest.predicate = runwayLengthPredicate
        do {
            runways = try moc.fetch(runwayLengthFetchRequest)
        } catch let error as NSError {
            print("Could not fetch the Runways: \(error) : \(error.userInfo)")
        }
        return runways
    }
    
    func getAirfieldsWith(airfieldID id: Int32, moc: NSManagedObjectContext) -> [AirfieldCD] {
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
    
    func getRunwaysAtAirfieldWithRWYLengthGreaterThanOrEqualToUserDefaultsRWYLength(airfieldId: Int32 , moc: NSManagedObjectContext) -> [RunwayCD] {
        let runwayLength = getUserDefaults().runwayLength_UD
        var runways = [RunwayCD]()
        let runwayFetchRequest = NSFetchRequest<RunwayCD>(entityName: "RunwayCD")
        let lengthPredicate: NSPredicate = {
            return NSPredicate(format: "%K => %@", #keyPath(RunwayCD.length_CD), "\(runwayLength)")
        }()
        let airfieldIdPredicate: NSPredicate = {
            return NSPredicate(format: "%K = %@", #keyPath(RunwayCD.airfieldID_CD), "\(airfieldId)")
        }()
        let groupedPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [lengthPredicate, airfieldIdPredicate])
        runwayFetchRequest.predicate = groupedPredicate
        do {
            runways = try moc.fetch(runwayFetchRequest)
        } catch let error as NSError {
            print("Could not fetch the Runways: \(error) : \(error.userInfo)")
        }
        return runways
    }
    
    
    
    func getAirfieldAndRunwaysWithRWYLengthGreaterThanOrEqualToUserDefaultsRWYLength(moc: NSManagedObjectContext) -> [AirfieldCD:[RunwayCD]] {
        var resultsDict = [AirfieldCD:[RunwayCD]]()
        var airfields = [AirfieldCD]()
        var runwaysIntermediate = [RunwayCD]()
        var airfieldIDSet = Set<Int32>()
        
        //Step - 1: Get Runways with a length of: length
        runwaysIntermediate = getRunwaysGreaterThanOrEqualToUserDefaultsRWYLength(moc: moc)
        
        //Step - 2: Get Set of Airfield IDs from: Step - 1
        for runway in runwaysIntermediate {
            airfieldIDSet.insert(runway.airfieldID_CD)
        }
        
        //Step - 3: Get Airfields with ID of: airfieldIDSet
        for id in airfieldIDSet {
            var afs = [AirfieldCD]()
            afs = getAirfieldsWith(airfieldID: id, moc: moc)
            for af in afs {
                airfields.append(af)
            }
        }
        
        //Step - 4: Set dictionary with Airfield and Runways
        for airfield in airfields {
            var runways = [RunwayCD]()
            runways = getRunwaysAtAirfieldWithRWYLengthGreaterThanOrEqualToUserDefaultsRWYLength(airfieldId: airfield.id_CD, moc: moc)
            resultsDict[airfield] = runways
        }
        
        return resultsDict
    }
    
    
    
        func getAirfieldWithRWYLengthGreaterThanOrEqualToUserDefaultsRWYLength(moc: NSManagedObjectContext) -> [AirfieldCD] {
            var airfields = [AirfieldCD]()
            var runwaysIntermediate = [RunwayCD]()
            var airfieldIDSet = Set<Int32>()
            
            //Step - 1: Get Runways with a length of: length
            runwaysIntermediate = getRunwaysGreaterThanOrEqualToUserDefaultsRWYLength(moc: moc)
            
            //Step - 2: Get Set of Airfield IDs from: Step - 1
            for runway in runwaysIntermediate {
                airfieldIDSet.insert(runway.airfieldID_CD)
            }
            
            //Step - 3: Get Airfields with ID of: airfieldIDSet
            for id in airfieldIDSet {
                var afs = [AirfieldCD]()
                afs = getAirfieldsWith(airfieldID: id, moc: moc)
                for af in afs {
                    airfields.append(af)
                }
            }
        
        return airfields
    }
    
    
    
    func getAirfieldByICAO(_ icao: String, moc: NSManagedObjectContext)  -> [AirfieldCD:[RunwayCD]] {
        var resultsDict = [AirfieldCD:[RunwayCD]]()
        var airfields = [AirfieldCD]()
        var airfieldIDSet = Set<Int32>()
        let airfieldFetchRequest = NSFetchRequest<AirfieldCD>(entityName: "AirfieldCD")
        let airfieldPredicate: NSPredicate = {
            return NSPredicate(format: "%K = %@", #keyPath(AirfieldCD.icao_CD),"\(icao)")
        }()
        airfieldFetchRequest.predicate = airfieldPredicate
        do {
            airfields = try moc.fetch(airfieldFetchRequest)
        } catch let error as NSError {
            print("Could not fetch the Runways: \(error) : \(error.userInfo)")
        }
        for airfield in airfields {
            airfieldIDSet.insert(airfield.id_CD)
        }
        for id in airfieldIDSet {
            var afs = [AirfieldCD]()
            afs = getAirfieldsWith(airfieldID: id, moc: moc)
            for af in afs {
                airfields.append(af)
            }
        }
        for airfield in airfields {
            var runways = [RunwayCD]()
            runways = getRunwaysAtAirfieldWithRWYLengthGreaterThanOrEqualToUserDefaultsRWYLength(airfieldId: airfield.id_CD, moc: moc)
            resultsDict[airfield] = runways
        }
        return resultsDict
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
    
    
    
    func loadJSONInBackground(state: String) {
        let container: NSPersistentContainer? = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        var counter = 1
        let start = Date()
        for state in StateCode.allValues {
            container?.performBackgroundTask({ context in
                self.loadToDBFromJSON(state.rawValue, moc: context)
                DispatchQueue.main.async {
                    self.printResults(moc: context)
                    print(counter)
                    counter += 1
                    let end = Date()
                    print("Completion Time: \(end.timeIntervalSince(start))")
                }
            })
        }
        
        }
    
    
    
    
    
    
    
    // MARK: JSON Loading
    func loadToDBFromJSON(_ nameOfJSON: String, moc: NSManagedObjectContext){
        let documentsURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let airfieldstURL = documentsURL.appendingPathComponent(nameOfJSON).appendingPathExtension("json")
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
//                print(counter)
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
                
//                for navaid in airfield.navaids {
//                    let navaidDB = NavaidCD(context: moc)
//                    navaidDB.airfieldID_CD = airfieldDB.id_CD
//                    navaidDB.id_CD = Int32(navaid.id)
//                    navaidDB.name_CD = navaid.name
//                    navaidDB.ident_CD = navaid.ident
//                    navaidDB.type_CD = navaid.type
//                    navaidDB.lat_CD = navaid.lat
//                    navaidDB.long_CD = navaid.lon
//                    navaidDB.frequency_CD = navaid.frequency
//                    navaidDB.channel_CD = Int32(navaid.channel)
//                    navaidDB.tacanDMEMode_CD = navaid.tacanDMEMode
//                    navaidDB.course_CD = Int32(navaid.course)
//                    navaidDB.distance_CD = navaid.distance
//                    airfieldDB.addToNavaids_R_CD(navaidDB)
//                    try? moc.save()
//                }
//
//                for comm in airfield.communications {
//                    let communicationDB = CommunicationCD(context: moc)
//                    communicationDB.airfieldID_CD = airfieldDB.id_CD
//                    communicationDB.id_CD = Int32(comm.id)
//                    communicationDB.name_CD = comm.name
//                    try? moc.save()
//                    for freq in comm.freqs {
//                        let freqDB = FreqCD(context: moc)
//                        freqDB.communicationsId_CD = communicationDB.id_CD
//                        freqDB.id_CD = Int32(freq.id)
//                        freqDB.freq_CD = freq.freq
//                        communicationDB.addToFreqs_R_CD(freqDB)
//                        try? moc.save()
//                    }
//                    airfieldDB.addToCommunications_R_CD(communicationDB)
//                    try? moc.save()
//                }
            }
            try? moc.save()
        } catch {print(error)}
    }
    
    // MARK: CD Save/Delete
    func mocSave(moc: NSManagedObjectContext){
        do {
            try moc.save()
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }}
    
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



