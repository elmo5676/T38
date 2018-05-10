//////////////////THIS IS THE WORKING COPY///////////////////////// c

import UIKit
import CoreData
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var baseDafifUrl = "http://getatis.com/DAFIF/GetAirfieldsByState?state="
    let baseWeatherUrl_METAR = "https://www.getatis.com/services/GetMETAR?stations="
    var jsonD = JSONHandler()
    


    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let moc = persistentContainer.viewContext
        let cdu = CoreDataUtilies()
        cdu.printResults(moc: moc)
        cdu.setUserDefaults(runwayLength: 8000.0,
                            homeAirfieldICAO: "KSFO",
                            baseWeatherUrl: baseWeatherUrl_METAR,
                            baseDafifUrl: baseDafifUrl,
                            aeroBraking: "No",
                            tempScaleCorF: "C",
                            aircraftGrossWeight: "12700",
                            podInstalled: "No",
                            weightOfCargoInPOD: "0",
                            weightUsedForTOLD: "12700",
                            givenEngineFailure: "0")
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







