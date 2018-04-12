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

import UIKit

class NearestTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAirfileds()
        updateUI()
//        loadRunwayFromJSON()
    }
    
    
    var airfields = AirfieldStore().airfieldsAll
    var allAirields1 = [Airfield]()
    var allAirields = [Airfield]()
    var ICAO = ""
    var elevation = 0.0
    var lat = ""
    var long = ""
    var runways = ""
    var city = ""
    var state = ""
    var airportID = ""
    var ident = ""
    
    // MARK: JSON Parse
    func loadAirportFromJSON(){
        let airportURL = Bundle.main.url(forResource: "Airports", withExtension: "json")!
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(Airport.self, from: Data(contentsOf: airportURL))
//            print(result.features[0].properties.icaoID as Any)
            for airport in result.features {
//                print(airport.properties.icaoID as Any)
//                print(airport.geometry.coordinates)
            }
        } catch {
            print(error)
        }
    }
    
    func loadRunwayFromJSON(){
        let airportURL = Bundle.main.url(forResource: "Runways", withExtension: "json")!
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(Runway.self, from: Data(contentsOf: airportURL))
//            print(result.features[0].properties)
            for runway in result.features {
//                print(runway.properties.globalID)
//                print(runway.properties.length)
            }
        } catch {
            print(error)
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
            let selectedAirfield = allAirields[row!] //else {print("No Airfield Found"); return }
            let destinationViewController = segue.destination as! AirfieldInfoViewController
            destinationViewController.selectedAirfield = selectedAirfield
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }

    func loadAirfileds(){
        let url = Bundle.main.url(forResource: "getAtis7000", withExtension: "json")!
        let decoder = JSONDecoder()
        let data = try! Data(contentsOf: url)
        let resultAirfields = try? decoder.decode([Airfield].self, from: data)
        allAirields.removeAll()
        airfields.removeAll()
        airfields = resultAirfields!
        allAirields = airfields.filter {$0.ICAO != nil}
    }

    // MARK: - Table view data
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAirields.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Nearest")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Nearest");
        }
        cell!.textLabel?.text = allAirields[indexPath.row].ICAO
        return cell!
    }
    
    @IBAction func dismissButton(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    


}
