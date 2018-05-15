//
//  TOLDInputViewController.swift
//  T38
//
//  Created by elmo on 4/1/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import JavaScriptCore
import CoreData
import CoreLocation

protocol isAbleToReceiveData {
    func pass(data: String)
}

class TOLDInputViewController: UIViewController, UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsButtonOutlet.isHidden = true
        resultsButtonOutlet.isEnabled = false
        //KeyBoard Stuff
        self.hideKeyboardWhenTappedAround()
        self.temperatureTextField.delegate = self
        self.pressureAltTextField.delegate = self
        self.runwayLengthTextField.delegate = self
        self.runwayHeadingTextField.delegate = self
        self.windDirectionTextField.delegate = self
        self.windVelocityTextField.delegate = self
        self.windVelocityTextField.delegate = self
        self.runwaySlopeTextField.delegate = self
        self.rcrTextField.delegate = self
        self.aircraftGrosWTTextField.delegate = self
        self.weightOfCargoInPODTextField.delegate = self
        self.wieghtUsedForTOLDTextField.delegate = self
        self.givenEngFailureTextField.delegate = self
        
        aeroBreakingYesNoLabel.text = "No"
        celciusOrFehrenheitLabel.text = "C"
        podYesOrNoLabel.text = "No"
        
        spinner.isHidden = true
        calculator = Calculator()
        
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        guard let model = moc.persistentStoreCoordinator?.managedObjectModel,
            let fetchAllAirports = model.fetchRequestTemplate(forName: "FetchAllAirports") as? NSFetchRequest<AirfieldCD> else {
                return
        }
        self.fetchAllAirports = fetchAllAirports
        fetchAndSortByDistance()

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        autoFillButtonOutlet.isHidden = true
        jsonD.downloadWeatherWithIndicator(baseUrl:  cdu.getUserDefaults().baseWeatherUrl_UD, icao: cdu.getUserDefaults().homeFieldICAO_UD, button: autoFillButtonOutlet)
       }
    
    
    
    
    // MARK: CoreData Variables
    var moc : NSManagedObjectContext!
    var cdu = CoreDataUtilies()
    var airfields: [AirfieldCD] = []
    var airportsSorted = [AirfieldCD:Double]()
    var fetchAllAirports: NSFetchRequest<AirfieldCD>?
    
    // MARK: Location Variables
    let locManager = CLLocationManager()
    var deviceLat = 0.0
    var deviceLong = 0.0
    var deviceAlt = 0.0
    
    var jsonD = JSONHandler()
    var currentWeather: Weather?
    var useUDHomeField = true
    var homeFieldRunways = [RunwayCD]()
    
    
    
    
    func clearAllFields(){
        temperatureTextField.text = ""
        airfieldICAO.text = ""
        pressureAltTextField.text = ""
        runwayLengthTextField.text = ""
        runwayHeadingTextField.text = ""
        windDirectionTextField.text = ""
        windVelocityTextField.text = ""
        runwaySlopeTextField.text = ""
        rcrTextField.text = ""
        aircraftGrosWTTextField.text = ""
        weightOfCargoInPODTextField.text = ""
        wieghtUsedForTOLDTextField.text = ""
        givenEngFailureTextField.text = ""
    }
    
    
    func fetchAndSortByDistance() {
        guard let fetchRequest = fetchAllAirports else { return }
        getLocationInformation()
        do {
            airfields = try moc.fetch(fetchRequest)
            var preSorted = [AirfieldCD:Double]()
            for airport in airfields {
                let dictValue = cdu.distanceAway(deviceLat: deviceLat, deviceLong: deviceLong, airport: airport).airport
                let dictKey = cdu.distanceAway(deviceLat: deviceLat, deviceLong: deviceLong, airport: airport).distanceAway
                preSorted.updateValue(dictKey, forKey: dictValue)
            }
            let airportICAO = preSorted.keys.sorted{preSorted[$0]! < preSorted[$1]!}
            airfields = airportICAO.filter({$0.icao_CD != "" })
            
            print("\(deviceLat) : \(deviceLong)")
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }}

    func getLocationInformation() {
        if let loc = locManager.location {
            locManager.requestAlwaysAuthorization()
            locManager.requestWhenInUseAuthorization()
            self.deviceLat = loc.coordinate.latitude
            self.deviceLong = loc.coordinate.longitude
            self.deviceAlt = loc.altitude
        }}
    
    @IBOutlet weak var autoFillButtonOutlet: UIButton!
    @IBAction func autoFillButton(_ sender: UIButton) {
         _ = autoFill()
        
    }
    @IBAction func clearAllFieldsButton(_ sender: UIButton) {
        clearAllFields()
    }
    
    
    func calcPressureAlt(altSetting: Double, fieldElevation: Double) -> Double {
        let pa = ((29.92 - altSetting) * 1000) + fieldElevation
        return pa
    }
 
    
    // MARK: Runway Selection and Autofill
    var chosenRunway = [Any]()
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        let source = segue.source as? RunwayChoicesTableViewController
        chosenRunway = (source?.chosenRwy)!
        
        let icao = airfieldICAO.text!.prefix(4)
        let length_si = String(describing: chosenRunway[1])
        let heading_si = String(describing: chosenRunway[2])
        let slope_si = String(describing: chosenRunway[3])
        
        let length = Double(length_si)
        let heading = Double(heading_si)
        let slope = Double(slope_si)
        
        airfieldICAO.text = "\(String(describing: icao)) \(chosenRunway[0])"
        runwayLengthTextField.text = String(format: "%.0f", length!)
        runwayHeadingTextField.text = String(format: "%.0f", heading!)
        runwaySlopeTextField.text = String(format: "%.0f", slope!)
        
        print("*****************************************************************************")
        print(chosenRunway as Any)
        print("*****************************************************************************")

    }
 

    
    func autoFill() -> Bool {
        let result = true
        currentWeather = jsonD.currentWeather(icao: cdu.getUserDefaults().homeFieldICAO_UD)
        var fieldElev = 0.0
        if useUDHomeField == true {
            var homeFieldDict = [AirfieldCD:[RunwayCD]]()
            let defaults = cdu.getUserDefaults()
            
            // User Preferences aka: UserDefaults
            aircraftGrosWTTextField.text = defaults.aircraftGrossWeight_UD
            weightOfCargoInPODTextField.text = defaults.weightOfCargoInPOD_UD
            wieghtUsedForTOLDTextField.text = defaults.weightUsedForTOLD_UD
            givenEngFailureTextField.text = defaults.givenEngineFailure_UD
            
            // DAFIF Info
            homeFieldDict = cdu.getAirfieldByICAO(defaults.homeFieldICAO_UD, moc: moc)
            homeFieldRunways = homeFieldDict.values.first!
            
            print(homeFieldDict)
            
            for (key, value) in homeFieldDict {
                var runwayIdSet = Set<Int32>()

                for val in value {
                    runwayIdSet.insert(val.id_CD)
                }
                print(runwayIdSet)
                airfieldICAO.text = key.icao_CD
//                runwayLengthTextField.text = String(format: "%.0f", value[0].length_CD)
//                runwayHeadingTextField.text = String(format: "%.0f", value[0].magHdgHi_CD)
//                runwaySlopeTextField.text = String(format: "%.1f", value[0].slopeHi_CD)
                rcrTextField.text = "23"
                fieldElev = key.elevation_CD
            }
        } else {
            let alertController = UIAlertController(title: "No DAFIF Loaded", message:
                "You need to load Airfield information for autofill to work", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Bring It!", style: UIAlertActionStyle.default,handler: nil))
        }
        
        // Weather Info
        if let cw = currentWeather {
            print(cw)
            let altSetting = Double(cw.metars.metar.altimInHg)
            temperatureTextField.text = String(cw.metars.metar.tempC)
            pressureAltTextField.text = String(format: "%.0f", calcPressureAlt(altSetting: altSetting!, fieldElevation: fieldElev))
            windDirectionTextField.text = String(cw.metars.metar.windDirDegrees)
            windVelocityTextField.text = String(cw.metars.metar.windSpeedKt)
        }
        return result
        
    }
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    private let scriptContext = JSContext()!
    private var calculator: Calculator?

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == temperatureTextField {
            pressureAltTextField.becomeFirstResponder()
        } else if textField == pressureAltTextField {
            runwayLengthTextField.becomeFirstResponder()
        } else if textField == runwayLengthTextField {
            runwayHeadingTextField.becomeFirstResponder()
        } else if textField == runwayHeadingTextField {
            windDirectionTextField.becomeFirstResponder()
        } else if textField == windDirectionTextField {
            windVelocityTextField.becomeFirstResponder()
        } else if textField == windVelocityTextField {
            runwaySlopeTextField.becomeFirstResponder()
        } else if textField == runwaySlopeTextField {
            rcrTextField.becomeFirstResponder()
        } else if textField == rcrTextField {
            aircraftGrosWTTextField.becomeFirstResponder()
        } else if textField == aircraftGrosWTTextField {
            weightOfCargoInPODTextField.becomeFirstResponder()
        } else if textField == weightOfCargoInPODTextField {
            wieghtUsedForTOLDTextField.becomeFirstResponder()
        } else if textField == wieghtUsedForTOLDTextField {
            givenEngFailureTextField.becomeFirstResponder()
        } else if textField == givenEngFailureTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBOutlet weak var aeroBreakingYesNoLabel: UILabel!
    @IBOutlet weak var aeroBreakingSwitchOutlet: UISwitch!
    @IBAction func aeroBreakingSwitch(_ sender: UISwitch) {
        if sender.isOn {
            aeroBreaking = 1
            aeroBreakingYesNoLabel.text = "Yes"
        } else {
            aeroBreaking = 2
            aeroBreakingYesNoLabel.text = "No"
        }
    }
    @IBOutlet weak var temperatureTextField: UITextField!
    @IBOutlet weak var temperatureCorFSwitchOutlet: UISwitch!
    @IBAction func temperatureCorFSwitch(_ sender: UISwitch) {
        if sender.isOn {
            celciusOrFerenheight = "F"
            celciusOrFehrenheitLabel.text = "F"
        } else {
            celciusOrFerenheight = "C"
            celciusOrFehrenheitLabel.text = "C"
        }
    }
    @IBOutlet weak var airfieldICAO: UILabel!
    @IBOutlet weak var celciusOrFehrenheitLabel: UILabel!
    @IBOutlet weak var pressureAltTextField: UITextField!
    @IBOutlet weak var runwayLengthTextField: UITextField!
    @IBOutlet weak var runwayHeadingTextField: UITextField!
    @IBOutlet weak var windDirectionTextField: UITextField!
    @IBOutlet weak var windVelocityTextField: UITextField!
    @IBOutlet weak var runwaySlopeTextField: UITextField!
    @IBOutlet weak var rcrTextField: UITextField!
    @IBOutlet weak var aircraftGrosWTTextField: UITextField!
    @IBOutlet weak var podSwitchOutlet: UISwitch!
    @IBAction func podSwitch(_ sender: UISwitch) {
        if sender.isOn {
            podCalcTOLD = true
            podCalculate = 1
            podYesOrNoLabel.text = "Yes"
        } else {
            podCalcTOLD = false
            podCalculate = 1
            podYesOrNoLabel.text = "No"
        }
    }
    @IBOutlet weak var podYesOrNoLabel: UILabel!
    @IBOutlet weak var weightOfCargoInPODTextField: UITextField!
    @IBOutlet weak var wieghtUsedForTOLDTextField: UITextField!
    @IBOutlet weak var givenEngFailureTextField: UITextField!
    
    

//  Temp: -20 to 122
//  Pressure Alt: 0 to 6000
//  Runway Length: 7000 to 15000
//  Runway Heading: 0 to 359
//  WindDirectio: 0 to 359
//  Wind Velocity: 0 to 40
//  Runway Slope: -6 to 6
//  RCR: 5 to 23
//  Aircraft Gross Weight: 11000 to 14000
//  Pod Weight: 0 to 140
//  Weight used for told: Max = 14000
//  Given Engine Failure: No restrictions
    
    // MARK: INPUT Variables
    var aeroBreaking = 2
    var temperature = 0.0
    var celciusOrFerenheight = "C"
    var pressureAlt = 0.0
    var runwayLength = 0.0
    var runwayHDG = 0.0
    var windDirection = 0.0
    var windVelocity = 0.0
    var runwaySlope = 0.0
    var rcr = 0.0
    var aircraftGrossWeight = 0.0
    var podCalcTOLD = false //used for calcTOLD function for weight (1 = YES/True | 0 = NO/False) tied to podCalculate below
    var podCalculate = 0 //used for caclulate function
    var weightOfCargoInPOD = 0.0
    var weightUsedForTOLD = 0.0
    var givenEngFailure = 0.0
    
    
    
    var canContinuetoCalculate = true
    
    // MARK: RESULTS Variables
    var HeadwindKey = ""
    var CrosswindKey = ""
    var MACSKeyKey = ""
    var MACSDistanceKey = ""
    var DSKey = ""
    var RSEFKey = ""
    var SETOSKey = ""
    var SAEORKey = ""
    var GearDNSECGKey = ""
    var GearUPSECGKey = ""
    var CFLKey = ""
    var NACSKey = ""
    var RSBEOKey = ""
    var RotationSpeedKey = ""
    var TakeoffSpeedKey = ""
    var TakeoffDistanceKey = ""
    var CEFSKey = ""
    var EFSAEORKey = ""
    var EFGearDNSECGKey = ""
    var EFGearUPSECGKey = ""
    var givenEngFailAKey = ""
    // Error Array
    var resultsErrorArray = [String]()
    
    
    func getInputFromTextfields() {
        if let temperature_ = temperatureTextField.text {
            temperature = Double(temperature_)!
        } else {
            print("\(temperature) wasn't set")
        }
        if let pressureAlt_ = pressureAltTextField.text {
            pressureAlt = Double(pressureAlt_)!
        } else {
            print("\(pressureAlt) wasn't set")
        }
        if let runwayLength_ = runwayLengthTextField.text {
            runwayLength = Double(runwayLength_)!
        } else {
            print("\(runwayLength) wasn't set")
        }
        if let runwayHDG_ = runwayHeadingTextField.text {
            runwayHDG = Double(runwayHDG_)!
        } else {
            print("\(runwayHDG) wasn't set")
        }
        if let windDirection_ = windDirectionTextField.text {
            windDirection = Double(windDirection_)!
        } else {
            print("\(windDirection) wasn't set")
        }
        if let windVelocity_ = windVelocityTextField.text {
            windVelocity = Double(windVelocity_)!
        } else {
            print("\(windVelocity) wasn't set")
        }
        if let runwaySlope_ = runwaySlopeTextField.text {
            runwaySlope = Double(runwaySlope_)!
        } else {
            print("\(runwaySlope) wasn't set")
        }
        if let rcr_ = rcrTextField.text {
            rcr = Double(rcr_)!
        } else {
            print("\(rcr) wasn't set")
        }
        if let aircraftGrossWeight_ = aircraftGrosWTTextField.text {
            aircraftGrossWeight = Double(aircraftGrossWeight_)!
        } else {
            print("\(aircraftGrossWeight) wasn't set")
        }
        if let weightOfCargoInPOD_ = weightOfCargoInPODTextField.text {
            weightOfCargoInPOD = Double(weightOfCargoInPOD_)!
        } else {
            print("\(weightOfCargoInPOD) wasn't set")
        }
        if let weightUsedForTold_ = wieghtUsedForTOLDTextField.text {
            weightUsedForTOLD = Double(weightUsedForTold_)!
        } else {
            print("\(weightUsedForTOLD) wasn't set")
        }
        if let givenEngFail_ = givenEngFailureTextField.text {
            givenEngFailure = Double(givenEngFail_)!
        } else {
            print("\(givenEngFailure) wasn't set")
        }
    }

  
    func calculateTOLD() {
        getInputFromTextfields()
        spinner.isHidden = false
        spinner.startAnimating()
        
        let toldwt = calculator!.calcTOLDWt(podMounted: podCalcTOLD, acGrossWt: aircraftGrossWeight, wtOfCargoInPod: weightOfCargoInPOD)
        
        calculator!.calculate(aerobrake: aeroBreaking,
                              temperature: temperature,
                              temperatureScale: celciusOrFerenheight,
                              pressureAlt: pressureAlt,
                              runwayLength: runwayLength,
                              runwayHeading: runwayHDG,
                              windDirection: windDirection,
                              windVelocity: windVelocity,
                              runwaySlope: runwaySlope,
                              rcr: rcr,
                              acGrossWt: toldwt,
                              givenEngFailAt: givenEngFailure,
                              podMounted: podCalculate,
                              callback: { results in
                                //String
                                self.HeadwindKey = results.stringsDict[Results.HeadwindKey]!
                                self.CrosswindKey = results.stringsDict[Results.CrosswindKey]!
                                self.MACSKeyKey = results.stringsDict[Results.MACSKeyKey]!
                                self.MACSDistanceKey = results.stringsDict[Results.MACSDistanceKey]!
                                self.DSKey = results.stringsDict[Results.DSKey]!
                                self.RSEFKey = results.stringsDict[Results.RSEFKey]!
                                self.SETOSKey = results.stringsDict[Results.SETOSKey]!
                                self.SAEORKey = results.stringsDict[Results.SAEORKey]!
                                self.GearDNSECGKey = results.stringsDict[Results.GearDNSECGKey]!
                                self.GearUPSECGKey = results.stringsDict[Results.GearUPSECGKey]!
                                self.CFLKey = results.stringsDict[Results.CFLKey]!
                                self.NACSKey = results.stringsDict[Results.NACSKey]!
                                self.RSBEOKey = results.stringsDict[Results.RSBEOKey]!
                                self.RotationSpeedKey = results.stringsDict[Results.RotationSpeedKey]!
                                self.TakeoffSpeedKey = results.stringsDict[Results.TakeoffSpeedKey]!
                                self.TakeoffDistanceKey = results.stringsDict[Results.TakeoffDistanceKey]!
                                self.CEFSKey = results.stringsDict[Results.CEFSKey]!
                                self.EFSAEORKey = results.stringsDict[Results.EFSAEORKey]!
                                self.EFGearDNSECGKey = results.stringsDict[Results.EFGearDNSECGKey]!
                                self.EFGearUPSECGKey = results.stringsDict[Results.EFGearUPSECGKey]!
                                self.givenEngFailAKey = results.stringsDict[Results.givenEngFailAKey]!
                                // Error Array
                                self.resultsErrorArray = results.errorsArray
                                
                                self.spinner.isHidden = true
                                self.spinner.stopAnimating()
                                self.performSegue(withIdentifier: "calculateTOLD", sender: nil)
        })
    }
    
    func testPrint() {
        print("""
            aeroBreaking: \(aeroBreaking)
            temperature: \(temperature)
            celciusOrFerenheight: \(celciusOrFerenheight)
            pressureAlt: \(pressureAlt)
            runwayLength: \(runwayLength)
            runwayHDG: \(runwayHDG)
            windDirection: \(windDirection)
            windVelocity: \(windVelocity)
            runwaySlope: \(runwaySlope)
            rcr: \(rcr)
            aircraftGrossWeight: \(aircraftGrossWeight)
            podCalcTOLD: \(podCalcTOLD)
            podCalculate: \(podCalculate)
            weightOfCargoInPOD: \(weightOfCargoInPOD)
            weightUsedForTOLD: \(weightUsedForTOLD)
            givenEngFailure: \(givenEngFailure)
            """)
        
        print("""
            ************STRING ARRAY************
            HeadwindKey: \(HeadwindKey)
            CrosswindKey: \(CrosswindKey)
            MACSKeyKey: \(MACSKeyKey)
            MACSDistanceKey: \(MACSDistanceKey)
            DSKey: \(DSKey)
            RSEFKey: \(RSEFKey)
            SETOSKey: \(SETOSKey)
            SAEORKey: \(SAEORKey)
            GearDNSECGKey: \(GearDNSECGKey)
            GearUPSECGKey: \(GearUPSECGKey)
            CFLKey: \(CFLKey)
            NACSKey: \(NACSKey)
            RSBEOKey: \(RSBEOKey)
            RotationSpeedKey: \(RotationSpeedKey)
            TakeoffSpeedKey: \(TakeoffSpeedKey)
            TakeoffDistanceKey: \(TakeoffDistanceKey)
            CEFSKey: \(CEFSKey)
            EFSAEORKey: \(EFSAEORKey)
            EFGearDNSECGKey: \(EFGearDNSECGKey)
            EFGearUPSECGKey: \(EFGearUPSECGKey)
            givenEngFailAKey: \(givenEngFailAKey)
            """)
        print("""
            ************ERROR ARRAY************
            resultsErrorArray: \(resultsErrorArray)
            """)

    }
    
    @IBAction func calculateButton(_ sender: UIButton) {
        calculateTOLD()
        
        
    }
    @IBOutlet weak var resultsButtonOutlet: UIButton!
    
  
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "calculateTOLD"?:
            testPrint()
            let destinationViewController = segue.destination as! TOLDResultsViewController
            destinationViewController.HeadwindKey = HeadwindKey
            destinationViewController.CrosswindKey = CrosswindKey
            destinationViewController.MACSKeyKey = MACSKeyKey
            destinationViewController.MACSDistanceKey = MACSDistanceKey
            destinationViewController.DSKey = DSKey
            destinationViewController.RSEFKey = RSEFKey
            destinationViewController.SETOSKey = SETOSKey
            destinationViewController.SAEORKey = SAEORKey
            destinationViewController.GearDNSECGKey = GearDNSECGKey
            destinationViewController.GearUPSECGKey = GearUPSECGKey
            destinationViewController.CFLKey = CFLKey
            destinationViewController.NACSKey = NACSKey
            destinationViewController.RSBEOKey = RSBEOKey
            destinationViewController.RotationSpeedKey = RotationSpeedKey
            destinationViewController.TakeoffSpeedKey = TakeoffSpeedKey
            destinationViewController.TakeoffDistanceKey = TakeoffDistanceKey
            destinationViewController.CEFSKey = CEFSKey
            destinationViewController.EFSAEORKey = EFSAEORKey
            destinationViewController.EFGearDNSECGKey = EFGearDNSECGKey
            destinationViewController.EFGearUPSECGKey = EFGearUPSECGKey
            destinationViewController.givenEngFailAKey = givenEngFailAKey
            // Error Array
            destinationViewController.resultsErrorArray = resultsErrorArray
        case "runwayChoicesSeque"?:
            let destinationViewController = segue.destination as! RunwayChoicesTableViewController
            destinationViewController.runways = homeFieldRunways
            //print(homeFieldRunways)
            
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    
    
    
 
}
