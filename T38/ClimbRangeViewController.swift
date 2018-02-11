//
//  ClimbRangeViewController.swift
//  T38
//
//  Created by elmo on 1/1/17.
//  Copyright © 2017 elmo. All rights reserved.
//

import UIKit
import CoreLocation


class ClimbRangeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    
    var updateAlt: Double = 0.0
    var currentAltitude:Int? = 41
    var tempDeviation:Double = 0
    var tempCorrection:Double = 0.0
    var climbOutFromOtherThanInitialTO = 0.0 //lbs
    var altitudeArray: [Int] = [41, 39, 37, 35, 33, 31, 29, 25, 20, 15, 10, 5]
    var altFromPicker:String = "41"
    var timer = Timer()
    var manager = CLLocationManager()
    
    // MARK: Label Outlets
    //RESTRICTED CLIMB
    @IBOutlet weak var RC_Label_Mach: UILabel!
    @IBOutlet weak var RC_Label_KIAS: UILabel!
    @IBOutlet weak var RC_Label_Time: UILabel!
    @IBOutlet weak var RC_Label_Distance: UILabel!
    @IBOutlet weak var RC_Label_FuelUsed: UILabel!
    
    //MAX RANGE CRUISE
    @IBOutlet weak var MRC_Label_Mach: UILabel!
    @IBOutlet weak var MRC_Label_KIAS: UILabel!
    @IBOutlet weak var MRC_Label_KTAS: UILabel!
    @IBOutlet weak var MRC_Label_FF_HR: UILabel!
    @IBOutlet weak var MRC_Label_FF_MIN: UILabel!
    
    //0.9 MACH CRUISE
    @IBOutlet weak var PT9MC_Label_Mach: UILabel!
    @IBOutlet weak var PT9MC_Label_KIAS: UILabel!
    @IBOutlet weak var PT9MC_Label_KTAS: UILabel!
    @IBOutlet weak var PT9MC_Label_FF_HR: UILabel!
    @IBOutlet weak var PT9MC_Label_FF_MIN: UILabel!
    
    
    // MARK: - Lattitude, Longitude, Altitude, Heading and more.
    let locManager = CLLocationManager()
    // This function will be called whenever your heading is updated.
    func getpositionPermission(){
        locManager.requestAlwaysAuthorization()
        locManager.requestWhenInUseAuthorization()
        locManager.distanceFilter = kCLDistanceFilterNone
        locManager.headingFilter = kCLHeadingFilterNone
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.headingOrientation = .portrait
        locManager.delegate = self
        locManager.startUpdatingHeading()
        locManager.startUpdatingLocation()
    }

    // MARK: GPS Altitude functionality here
    //Gets the altitude in meters
    func getGPSAltitudeInFeet() -> Int {
         //3.28083989501312 meters to feet conversion
        if let GPSAltDouble = locManager.location?.altitude {
            currentAltitude = Int(GPSAltDouble)
            print(currentAltitude!)
            return currentAltitude!
        } else {
            print(currentAltitude!)
            return currentAltitude!
        }
    }
  
    // MARK: Results
    //Takes the inputes, calculates the results and displays them on the labels
    func updateResults(altitude:Int) {
        var restrictedClimb: Dictionary<Int, Array<Double>> = [
                                41:[-56.5,259,0.87,13.0,100,890,8,0.88,261,505,1380,23.0],
                                39:[-56.5,275,0.87,10.5,85,805,7,0.86,268,493,1385,23.1],
                                37:[-56.5,285,0.87,9.0,70,770,7,0.85,275,487,1450,24.2],
                                35:[-54.3,295,0.86,8.0,63,730,6,0.84,283,484,1510,25.2],
                                33:[-50.4,305,0.85,7.0,55,690,6,0.82,294,487,1530,25.5],
                                31:[-46.4,317,0.84,6.5,50,670,6,0.81,298,475,1600,26.7],
                                29:[-42.4,328,0.84,6.0,45,635,5,0.79,307,467,1630,27.2],
                                25:[-34.5,349,0.83,5.0,37,585,5,0.75,321,457,1730,28.8],
                                20:[-24.7,377,0.80,3.7,28,520,4,0.70,327,433,1890,31.5],
                                15:[-14.7,406,0.79,3.0,23,450,3,0.66,336,413,1980,33.0],
                                10:[-4.8,300,0.52,2.5,11,385,2,0.61,324,380,2040,34.0],
                                5:[5.1,300,0.50,2.0,5,250,2,0.46,280,300,2020,33.6]]
        
        var machCruise: Dictionary<Int, Array<Double>> = [
                                41:[0.90,266,516,1455,24.3],
                                39:[0.90,280,516,1470,24.5],
                                37:[0.90,293,516,1560,26.0],
                                35:[0.90,305,518,1720,28.7],
                                33:[0.90,323,525,1780,29.7],
                                31:[0.90,337,528,1950,32.5],
                                29:[0.90,352,532,2080,34.7],
                                25:[0.90,380,543,2260,37.7],
                                20:[0.90,421,553,2840,47.3],
                                15:[0.90,464,565,3320,55.3],
                                10:[0.90,491,577,3750,62.5],
                                5:[0.50,300,320,2200,36.7]]
        
        let machCruiseArray: [Double] = machCruise[altitude]!
        let restrictedClimbArray: [Double] = restrictedClimb[altitude]!
      
        RC_Label_Mach.text = String(describing: restrictedClimbArray[2])
        RC_Label_KIAS.text = String(format: "%.0f", restrictedClimbArray[1])
        RC_Label_Time.text = String(format: "%.0f", restrictedClimbArray[3])
        RC_Label_Distance.text = String(format: "%.0f", restrictedClimbArray[4])
       
        if tempDeviation == 0 {
            RC_Label_FuelUsed.text = String(format: "%.0f", (restrictedClimbArray[5] - climbOutFromOtherThanInitialTO))
        } else {
            tempCorrection = restrictedClimbArray[6]
            let fuelUsedCorrected = (restrictedClimbArray[5] + (tempCorrection * tempDeviation))
            RC_Label_FuelUsed.text = String(format: "%.0f", (fuelUsedCorrected - climbOutFromOtherThanInitialTO))
        }
        
        MRC_Label_Mach.text = String(describing: restrictedClimbArray[7])
        MRC_Label_KIAS.text = String(format: "%.0f", restrictedClimbArray[8])
        MRC_Label_KTAS.text = String(format: "%.0f", restrictedClimbArray[9])
        MRC_Label_FF_HR.text = String(format: "%.0f", restrictedClimbArray[10])
        MRC_Label_FF_MIN.text = String(format: "%.0f", restrictedClimbArray[11])
        
        PT9MC_Label_Mach.text = String(describing: machCruiseArray[0])
        PT9MC_Label_KIAS.text = String(format: "%.0f", machCruiseArray[1])
        PT9MC_Label_KTAS.text = String(format: "%.0f", machCruiseArray[2])
        PT9MC_Label_FF_HR.text = String(format: "%.0f", machCruiseArray[3])
        PT9MC_Label_FF_MIN.text = String(format: "%.0f", machCruiseArray[4])
    }
    

    // MARK: Alt Converter
    //Converts the altitude provided by internal GPS to something the updateResults() can use to look up data
    func GPSAltitudeAdjustmentForTable(GPSAltitude:Int) -> Int {
        if GPSAltitude <= 4 {
            return 5
        }else if GPSAltitude <= 9 {
            return 5
        }else if GPSAltitude <= 14  {
            return 10
        }else if GPSAltitude <= 19 {
            return 15
        }else if GPSAltitude <= 24 {
            return 20
        }else if GPSAltitude <= 28{
            return 25
        }else if GPSAltitude <= 30{
            return 29
        }else if GPSAltitude <= 32{
            return 31
        }else if GPSAltitude <= 34{
            return 33
        }else if GPSAltitude <= 36{
            return 35
        }else if GPSAltitude <= 38{
            return 37
        }else if GPSAltitude <= 40{
            return 39
        }else {
            return 41
        }
    }
    
    
    //initialTakeOffSwitch sets the calculation for Fuel Used to either use 0 or 200lbs
    @IBOutlet weak var initialTakeOffLabel: UILabel!
    @IBOutlet weak var initialTakeOffSwitch: UISwitch!
    @IBOutlet weak var initialTakeOffSwitchController: UISwitch!
    @IBAction func initialTakeOffSwitch(_ sender: Any) {
        if (sender as AnyObject).isOn == true {
            initialTakeOffLabel.text = "Initial Take Off"
            climbOutFromOtherThanInitialTO = 0
        }else {
            initialTakeOffLabel.text = "Not Initial Take Off"
            climbOutFromOtherThanInitialTO = 200
        }}

    @IBOutlet weak var altitudePicker: UIPickerView!
    @IBOutlet weak var altitudeLabel: UILabel!

    // MARK: Temp Corrections
    //Input Temp Deviation
    @IBOutlet weak var standardTempLabel: UILabel!
    @IBOutlet weak var standardTempButton: UIButton!
    @IBOutlet weak var minusButtonVisual: UIButton!
    @IBAction func minusButton(_ sender: Any) {
        if standardTempLabel.text == "ST°" {
            standardTempLabel.text = "0"
            tempDeviation = 0
            print(tempDeviation)
        } else if standardTempLabel.text == "---" {
            standardTempLabel.text = "0"
            tempDeviation = 0
            print(tempDeviation)
        } else {
            if tempDeviation <= 0 {
                if Int(altitudeLabel.text!) != nil{
                }
                tempDeviation = 0
                standardTempLabel.text! = "0"
                print(tempDeviation)
            } else {
                if Int(altitudeLabel.text!) != nil{
                }

                tempDeviation = tempDeviation - 1
                let tempLabelDisplay = String(format: "%.0f°", tempDeviation)
                standardTempLabel.text = tempLabelDisplay
                print(tempDeviation)
            }
        }}
    @IBOutlet weak var plusButtonVisual: UIButton!
    @IBAction func plusButton(_ sender: Any) {
        if standardTempLabel.text == "ST°" {
            standardTempLabel.text = "0"
            tempDeviation = 0
            print(tempDeviation)
        } else if standardTempLabel.text == "---" {
            standardTempLabel.text = "0"
            tempDeviation = 0
            print(tempDeviation)
        } else {
            if tempDeviation < 0 {
                if Int(altitudeLabel.text!) != nil{
                }
                tempDeviation = 0
                standardTempLabel.text! = "0"
                print(tempDeviation)
            } else {
                if Int(altitudeLabel.text!) != nil{
                }
                tempDeviation = tempDeviation + 1
                let tempLabelDisplay = String(format: "%.0f°", tempDeviation)
                standardTempLabel.text = tempLabelDisplay
                print(tempDeviation)
            }
        }}
    
    @IBAction func standardTempButton(_ sender: Any) {
        standardTempLabel.text = "ST°"
        if Int(altitudeLabel.text!) != nil{
            tempDeviation = 0
        }}
    
    // MARK: PickerView Controls
    @IBOutlet weak var altPicker: UIPickerView!
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(altitudeArray[row])
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return altitudeArray.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        altFromPicker = String(altitudeArray[row])
        currentAltitude = altitudeArray[row]
        altitudeLabel.text = String(altitudeArray[row])
        updateResults(altitude: currentAltitude!)
        print(String(altitudeArray[row]))
        }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        return NSAttributedString(string: String(altitudeArray[row]), attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
    }
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (Timer) in
            if self.currentAltitude != nil{
                self.updateResults(altitude: self.currentAltitude!)
            }})
        
        getpositionPermission()
        altPicker.dataSource = self
        altPicker.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        standardTempButton.layer.cornerRadius = 22
        standardTempButton.layer.borderColor = #colorLiteral(red: 1, green: 0.1475811303, blue: 0, alpha: 1)
        standardTempButton.layer.borderWidth = 3
        
        RC_Label_Mach.text = "---"
        RC_Label_KIAS.text = "---"
        RC_Label_Time.text = "---"
        RC_Label_Distance.text = "---"
        RC_Label_FuelUsed.text = "---"
        MRC_Label_Mach.text = "---"
        MRC_Label_KIAS.text = "---"
        MRC_Label_KTAS.text = "---"
        MRC_Label_FF_HR.text = "---"
        MRC_Label_FF_MIN.text = "---"
        PT9MC_Label_Mach.text = "---"
        PT9MC_Label_KIAS.text = "---"
        PT9MC_Label_KTAS.text = "---"
        PT9MC_Label_FF_HR.text = "---"
        PT9MC_Label_FF_MIN.text = "---"
        standardTempLabel.text = "ST°"
        altitudeLabel.text = "41"
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

