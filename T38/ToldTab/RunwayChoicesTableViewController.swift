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
        self.title = "Test"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        currentWeather = jsonD.currentWeather(icao: cdu.getUserDefaults().homeFieldICAO_UD)
    }

 
    
    @IBAction func dismissButton(_ sender: UIButton!) {
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
    
    
    
    
    // MARK: Runway Variables Here
    var currentRunwayDict = [String: [Any]]()
    var chosenRwy = [Any]()
    func setSelectedRWY(indexPath: Int) {
        
        
        currentRunwayDict["H"] = [runways[indexPath].highID_CD!,
                                  runways[indexPath].length_CD,
                                  runways[indexPath].magHdgHi_CD,
                                  runways[indexPath].slopeHi_CD,
        ]
        currentRunwayDict["L"] = [runways[indexPath].lowID_CD!,
                                  runways[indexPath].length_CD,
                                  runways[indexPath].magHdgLow_CD,
                                  runways[indexPath].slopeLow_CD,
        ]
    }
    
    @IBAction func hiRwySelectedButton_(_ sender: UIButton) {
        if let indexPath = self.tableView.indexPathForView(sender) {
            setSelectedRWY(indexPath: indexPath[1])
            chosenRwy = currentRunwayDict["H"]!
            print("Button tapped at indexPath \(String(describing: currentRunwayDict["H"]))")
        } else {
            print("Button indexPath not found")
        }
    }
    @IBAction func lowRwySelectedButton_(_ sender: UIButton) {
        if let indexPath = self.tableView.indexPathForView(sender) {
            setSelectedRWY(indexPath: indexPath[1])
            chosenRwy = currentRunwayDict["L"]!
            print("Button tapped at indexPath \(String(describing: currentRunwayDict["L"]))")
        } else {
            print("Button indexPath not found")
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return runways.count
    }

//    func xwindColorifyLimits(label: UILabel, xWind: Double, hWind: Double) -> (label: UILabel, color: UIColor) {
//        var label = label
//        var
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "runwayCell", for: indexPath) as! RunwayCell
        
        let currentWeather = self.currentWeather!
        
        
        let windHeading = Heading(Int((currentWeather.metars.metar.windDirDegrees))!)
        let hiRunwayHeading = Heading(Int(runways[indexPath.row].magHdgHi_CD))
        let hiRWYwind = Wind(windHeading: windHeading, windSpeed: Double(currentWeather.metars.metar.windSpeedKt)!, runwayHeading: hiRunwayHeading)
        let hi_xWind = hiRWYwind.crossWind
        let hi_hWind = hiRWYwind.headWind
        
        let lowRunwayHeading = Heading(Int(runways[indexPath.row].magHdgHi_CD))
        let lowRWYwind = Wind(windHeading: windHeading, windSpeed: Double(currentWeather.metars.metar.windSpeedKt)!, runwayHeading: lowRunwayHeading)
        let low_xWind = lowRWYwind.crossWind
        let low_hWind = lowRWYwind.headWind
       
        cell.hi_RwyHwind.text = "XW: \(String(format: "%.0f", hi_xWind))"
        cell.hi_RwyXwind.text = "HW: \(String(format: "%.0f", hi_hWind))"
        cell.lengthLabel.text = String(format: "%.0f", runways[indexPath.row].length_CD) + " Ft"
        cell.hi_RwyButtonOutlet.setTitle(runways[indexPath.row].highID_CD, for: .normal)
        cell.low_RwyButtonOutlet.setTitle(runways[indexPath.row].lowID_CD, for: .normal)
        cell.low_RwyXwind.text = "XW: \(String(format: "%.0f", low_xWind))"
        cell.low_RwyHwind.text = "HW: \(String(format: "%.0f", low_hWind))"
        return cell
    }
    

}
