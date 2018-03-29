//
//  SpeedsViewController.swift
//  T38
//
//  Created by elmo on 1/15/17.
//  Copyright © 2017 elmo. All rights reserved.
//

import UIKit

class SpeedsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    var fuelArray:[Int] = [4000,3900,3800,3700,3600,3500,3400,3300,3200,3100,3000,2900,2800,2700,2600,2500,2400,2300,2200,2100,2000,1900,1800,1700,1600,1500,1400,1300,1200,1100,1000]
    
    func calculation(gas: Double) {
        let FF_LandingDistance = 2500 + gas
        let FF_WetLandingDistance = (2500 + gas) * 1.3
        let FF_XWindLandingDistance = (2500 + gas) * 1.2
        
        //60% Flap Shiza
        let Sixty_FinalTurnSpeed = 145 + 20 + (gas/100)
        let Sixty_FinalSpeed = 145 + (gas/100)
        
        let Sixty_LandingDistance = 2500 + 500 + gas
        let Sixty_WetLandingDistance = (2500 + 500 + gas) * 1.3
        let Sixty_XWindLandingDistance = (2500 + 500 + gas) * 1.2
        
        //No Flap Shiza
        let NF_FinalTurnSpeed = 160 + 20 + (gas/100)
        let NF_FinalSpeed = 160 + (gas/100)
        
        let NF_LandingDistance = (2500+gas)*2
        let NF_WetLandingDistance = ((2500+gas)*2)*1.3
        let NF_XWindLandingDistance = ((2500+gas)*2)*1.2
        
        //LABELS
        //FF
        label_FF_LAndingDistance.text = String(format: "%.0f", FF_LandingDistance)
        label_FF_WetLandingDistance.text = String(format: "%.0f", FF_WetLandingDistance)
        label_FF_XWindLandingDistance.text = String(format: "%.0f", FF_XWindLandingDistance)
        
        //60
        label_Sixty_FinalTurnSpeed.text = String(format: "%.0f", Sixty_FinalTurnSpeed)
        label_Sixty_FinalSpeed.text = String(format: "%.0f", Sixty_FinalSpeed)
        label_Sixty_LandingDistance.text = String(format: "%.0f", Sixty_LandingDistance)
        label_Sixty_WetLandingDistance.text = String(format: "%.0f", Sixty_WetLandingDistance)
        label_Sixty_XWindLandingDistance.text = String(format: "%.0f", Sixty_XWindLandingDistance)
        
        //No Flap
        label_NF_FinalTurnSpeed.text = String(format: "%.0f", NF_FinalTurnSpeed)
        label_NF_FinalSpeed.text = String(format: "%.0f", NF_FinalSpeed)
        label_NF_LandingDistance.text = String(format: "%.0f", NF_LandingDistance)
        label_NF_WetLandingDistance.text = String(format: "%.0f", NF_WetLandingDistance)
        label_NF_XWindLandingDistance.text = String(format: "%.0f", NF_XWindLandingDistance)
    }
    
    //LABELS
    //FF
    @IBOutlet weak var label_FF_LAndingDistance: UILabel!
    @IBOutlet weak var label_FF_WetLandingDistance: UILabel!
    @IBOutlet weak var label_FF_XWindLandingDistance: UILabel!
    //60
    @IBOutlet weak var label_Sixty_FinalTurnSpeed: UILabel!
    @IBOutlet weak var label_Sixty_FinalSpeed: UILabel!
    @IBOutlet weak var label_Sixty_LandingDistance: UILabel!
    @IBOutlet weak var label_Sixty_WetLandingDistance: UILabel!
    @IBOutlet weak var label_Sixty_XWindLandingDistance: UILabel!
    //No Flap
    @IBOutlet weak var label_NF_FinalTurnSpeed: UILabel!
    @IBOutlet weak var label_NF_FinalSpeed: UILabel!
    @IBOutlet weak var label_NF_LandingDistance: UILabel!
    @IBOutlet weak var label_NF_WetLandingDistance: UILabel!
    @IBOutlet weak var label_NF_XWindLandingDistance: UILabel!

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(fuelArray[row])
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fuelArray.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        calculation(gas: Double(fuelArray[row]))
       // label_Gas.text = String(fuelArray[row])
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FF
        label_FF_LAndingDistance.text = "---"
        label_FF_WetLandingDistance.text = "---"
        label_FF_XWindLandingDistance.text = "---"
        //60
        label_Sixty_FinalTurnSpeed.text = "---"
        label_Sixty_FinalSpeed.text = "---"
        label_Sixty_LandingDistance.text = "---"
        label_Sixty_WetLandingDistance.text = "---"
        label_Sixty_XWindLandingDistance.text = "---"
        //No Flap
        label_NF_FinalTurnSpeed.text = "---"
        label_NF_FinalSpeed.text = "---"
        label_NF_LandingDistance.text = "---"
        label_NF_WetLandingDistance.text = "---"
        label_NF_XWindLandingDistance.text = "---"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
