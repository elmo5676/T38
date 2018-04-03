//
//  TOLDInputViewController.swift
//  T38
//
//  Created by elmo on 4/1/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit

class TOLDInputViewController: UIViewController, UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        aeroBreakingYesNoLabel.text = "No"
        celciusOrFehrenheitLabel.text = "C"
        podYesOrNoLabel.text = "No"
        
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
      
    }
    
    
    
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
            aeroBreaking = true
            aeroBreakingYesNoLabel.text = "Yes"
        } else {
            aeroBreaking = false
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
            pod = true
            podYesOrNoLabel.text = "Yes"
        } else {
            pod = false
            podYesOrNoLabel.text = "No"
        }
    }
    @IBOutlet weak var podYesOrNoLabel: UILabel!
    @IBOutlet weak var weightOfCargoInPODTextField: UITextField!
    @IBOutlet weak var wieghtUsedForTOLDTextField: UITextField!
    @IBOutlet weak var givenEngFailureTextField: UITextField!
    
    var aeroBreaking = false
    var temperature = ""
    var celciusOrFerenheight = ""
    var pressureAlt = ""
    var runwayLength = ""
    var runwayHDG = ""
    var windDirection = ""
    var windVelocity = ""
    var runwaySlope = ""
    var rcr = ""
    var aircraftGrossWeight = ""
    var pod = false
    var weightOfCargoInPOD = ""
    var weightUsedForTOLD = ""
    var givenEngFailure = ""
    var canContinuetoCalculate = true
    
    func alertBlankField(){
        let alertController = UIAlertController(title: "Missing Info!", message:
            "Please fill in all the required information", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        canContinuetoCalculate = false
    }
    
    
    
    func getInputFromTextfields() {
        if let temperature_ = temperatureTextField.text {
            canContinuetoCalculate = true
            temperature = temperature_
        } else {
            alertBlankField()
            print("\(temperature) wasn't set")
        }
        if let pressureAlt_ = pressureAltTextField.text {
            canContinuetoCalculate = true
            pressureAlt = pressureAlt_
        } else {
            alertBlankField()
            print("\(pressureAlt) wasn't set")
        }
        if let runwayLength_ = runwayLengthTextField.text {
            canContinuetoCalculate = true
            runwayLength = runwayLength_
        } else {
            alertBlankField()
            print("\(runwayLength) wasn't set")
        }
        if let runwayHDG_ = runwayHeadingTextField.text {
            canContinuetoCalculate = true
            runwayHDG = runwayHDG_
        } else {
            alertBlankField()
            print("\(runwayHDG) wasn't set")
        }
        if let windDirection_ = windDirectionTextField.text {
            canContinuetoCalculate = true
            windDirection = windDirection_
        } else {
            alertBlankField()
            print("\(windDirection) wasn't set")
        }
        if let windVelocity_ = windVelocityTextField.text {
            canContinuetoCalculate = true
            windVelocity = windVelocity_
        } else {
            alertBlankField()
            print("\(windVelocity) wasn't set")
        }
        if let runwaySlope_ = runwaySlopeTextField.text {
            canContinuetoCalculate = true
            runwaySlope = runwaySlope_
        } else {
            alertBlankField()
            print("\(runwaySlope) wasn't set")
        }
        if let rcr_ = rcrTextField.text {
            canContinuetoCalculate = true
            rcr = rcr_
        } else {
            alertBlankField()
            print("\(rcr) wasn't set")
        }
        if let aircraftGrossWeight_ = aircraftGrosWTTextField.text {
            canContinuetoCalculate = true
            aircraftGrossWeight = aircraftGrossWeight_
        } else {
            alertBlankField()
            print("\(aircraftGrossWeight) wasn't set")
        }
        if let weightOfCargoInPOD_ = weightOfCargoInPODTextField.text {
            canContinuetoCalculate = true
            weightOfCargoInPOD = weightOfCargoInPOD_
        } else {
            alertBlankField()
            print("\(weightOfCargoInPOD) wasn't set")
        }
        if let weightUsedForTold_ = wieghtUsedForTOLDTextField.text {
            canContinuetoCalculate = true
            weightUsedForTOLD = weightUsedForTold_
        } else {
            alertBlankField()
            print("\(weightUsedForTOLD) wasn't set")
        }
        if let givenEngFail_ = givenEngFailureTextField.text {
            canContinuetoCalculate = true
            givenEngFailure = givenEngFail_
        } else {
            alertBlankField()
            print("\(givenEngFailure) wasn't set")
        }
    }
    
    
    @IBAction func calculateButton(_ sender: UIButton) {
      
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "submitTOLD" {
            if canContinuetoCalculate == true {
                alertBlankField()
                return false
            } else {
                return true
            }}
        return true
            }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "submitTOLD"?:
            getInputFromTextfields()
            let aeroB = aeroBreaking
            let temp = temperature
            let cOrF = celciusOrFerenheight
            let pressAlt = pressureAlt
            let runL = runwayLength
            let runH = runwayHDG
            let windD = windDirection
            let windV = windVelocity
            let runS = runwaySlope
            let rcr_ = rcr
            let acGW = aircraftGrossWeight
            let pod_ = pod
            let weightCIP = weightOfCargoInPOD
            let weightUFT = weightUsedForTOLD
            let given = givenEngFailure
            let destinationViewController = segue.destination as! toldHTMLViewController
            destinationViewController.aeroBraking = aeroB
            destinationViewController.temperature = temp
            destinationViewController.tempScale = cOrF
            destinationViewController.pressureAlt = pressAlt
            destinationViewController.runwayLength = runL
            destinationViewController.runwayHDG = runH
            destinationViewController.windDir = windD
            destinationViewController.windVelocity = windV
            destinationViewController.runwaySlope = runS
            destinationViewController.rcr = rcr_
            destinationViewController.aircraftGrossWeight = acGW
            destinationViewController.podCargoWeight = weightCIP
            destinationViewController.podMounted = pod_
            destinationViewController.weightUsedForTOLD = weightUFT
            destinationViewController.givenEngFailure = given
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
 
}
