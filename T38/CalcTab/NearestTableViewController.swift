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
    }
    
    
    var airfields = AirfieldStore().airfieldsAll
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
    
    
//    popoverPresentationController.sourceRect = sender.bounds
    
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
    
    

    
    
//    // Override to support editing the table view.
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
