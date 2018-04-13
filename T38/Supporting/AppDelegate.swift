//////////////////THIS IS THE WORKING COPY///////////////////////// c

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func loadAirportFromJSON(){
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        let moc = persistentContainer.viewContext
//        let airportURL = Bundle.main.url(forResource: "Airports", withExtension: "json")!
//        let airportDB = AirportCD(context: moc)
//        let decoder = JSONDecoder()
//        do {
//            let result = try decoder.decode(Airport.self, from: Data(contentsOf: airportURL))
//            for airport in result.features {
//                airportDB.objectID_CD = Int32(airport.properties.objectid)
//                airportDB.globalID_CD = airport.properties.globalID
//                airportDB.ident_CD = airport.properties.ident
//                airportDB.name_CD = airport.properties.name
//                airportDB.latitude_CD = airport.properties.latitude
//                airportDB.longitude_CD = airport.properties.longitude
//                airportDB.elevation_CD = airport.properties.elevation
//                airportDB.icaoID_CD = airport.properties.icaoID
//                airportDB.typeCode_CD = airport.properties.typeCode.rawValue
//                airportDB.serviceCity_CD = airport.properties.servcity
//                airportDB.state_CD = airport.properties.state.map { $0.rawValue }
//                airportDB.country_CD = airport.properties.country.rawValue
//                airportDB.operStatus_CD = airport.properties.operstatus.rawValue
//                airportDB.privateUse_CD = Int32(airport.properties.privateuse)
//                airportDB.iapExists_CD = Int32(airport.properties.iapexists)
//                airportDB.dodHiFlip_CD = Int32(airport.properties.dodhiflip)
//                airportDB.far91_CD = Int32(airport.properties.far91)
//                airportDB.far93_CD = Int32(airport.properties.far93)
//                airportDB.milCode_CD = airport.properties.milCode.rawValue
//                airportDB.airAnal_CD = airport.properties.airanal.rawValue
//                airportDB.usHigh_CD = Int32(airport.properties.usHigh)
//                airportDB.usLow_CD = Int32(airport.properties.usLow)
//                airportDB.akHigh_CD = Int32(airport.properties.akHigh)
//                airportDB.akLow_CD = Int32(airport.properties.akLow)
//                airportDB.usArea_CD = Int32(airport.properties.usArea)
//                airportDB.pacific_CD = Int32(airport.properties.pacific)
//                airportDB.geometryCoordinates_CD = airport.geometry.coordinates as NSObject
//                try moc.save()
//            }
//        } catch {
//            print(error)
//        }
//        
        //        let airportRequest: NSFetchRequest<AirportCD> = AirportCD.fetchRequest()
        //        airportRequest.returnsObjectsAsFaults = true
        //        let moc = persistentContainer.viewContext
        //        var airportICAOArray = [AirportCD]()
        //        do {
        //            airportICAOArray = try moc.fetch(airportRequest)
        //        } catch {
        //            print(error)
        //        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        //Name of CoreData Model File:
        let container = NSPersistentContainer(name: "T38CD")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error.localizedDescription)
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}







