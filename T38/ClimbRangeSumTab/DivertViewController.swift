import UIKit

class DivertViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    //Variables
    //Input Switches
    var numberOfEnginesValue:String = ""
    var PODValue:String = ""
    //Input Picker
    var altitudeValue:String = ""
    var fuelStatusValue:String = ""
    var climbToAltFlameOutValue:String = ""
    var climbToTemperatureFlameOutValue:String = ""
    
    //Results Variables:
    var divertResultArray = Array <String> (arrayLiteral: "", "", "", "", "", "", "", "", "")
    var stayAtAltitudeValue:String = ""
    var stayAtRangeValue:String = ""
    var stayAtMachValue:String = ""
    var stayAtFuelFlowValue:String = ""
   
    var climbToAltitudeValue:String = ""
    var climbToRangeValue:String = ""
    var climbToMachValue:String = ""
    var climbToFuelFlowValue:String = ""
    
    var climbScheduleKCASValue:String = ""
    var climbScheduleMachValue:String = ""
    
    var descendDistanceOutValue:String = ""
    var descendFuelRemainingValue:String = ""
    
    var flameOutMachValue:String = ""
    
    //Data Input for the Picker Controller
    var Input_Array = [
        ["SL","5K","10K","20K","30K","40K"],
        ["600","800","1000","1400"],
        ["35","36","37","38","39","40","41","42","43","44","45"],
        ["-56","-57","-58","-59","-60","-61","-62","-63","-64","-65","-66"],
        ]
    
    //Functions:
    //Diversion Table Function
    func getDiversionData (numberOfEngines: String, pod: String, altitude: String, fuelStatus: String) -> Array<Any>{
        let numberOfEnginesDefault:String
        let podDefault:String
        let altitudeDefault:String
        let fuelStatusDefault:String
        if numberOfEngines == "" {
            numberOfEnginesDefault = "BEO"
        } else {
            numberOfEnginesDefault = numberOfEngines
        }
        if pod == "" {
            podDefault = "NP"
        } else {
            podDefault = pod
        }
        if altitude == "" {
            altitudeDefault = "SL"
        } else {
            altitudeDefault = altitude
        }
        if fuelStatus == "" {
            fuelStatusDefault = "600"
        } else {
            fuelStatusDefault = fuelStatus
        }
     

        var diversionData = ["BEO_NP_SL":["600":["39","0.54","1325","64","20K","0.68","900","32","352"],
                                          "800":["65","0.54","1325","124","35K","0.81","700","59","386"],
                                          "1000":["90","0.54","1325","196","45K","0.89","650","81","407"],
                                          "1400":["142","0.54","1325","339","45K","0.89","650","81","407"]],
                             "BEO_NP_5K":["600":["46","0.56","1200","74","25K","0.73","825","40","363"],
                                          "800":["76","0.56","1200","139","40K","0.85","675","70","397"],
                                          "1000":["106","0.56","1200","212","45K","0.89","650","81","407"],
                                          "1400":["166","0.56","1200","352","45K","0.89","650","81","407"]],
                             "BEO_NP_10K":["600":["51","0.59","1050","84","30K","0.77","750","49","375"],
                                           "800":["86","0.59","1050","152","40K","0.85","675","70","397"],
                                           "1000":["121","0.59","1050","226","45K","0.89","650","81","407"],
                                           "1400":["192","0.59","1050","369","45K","0.89","650","81","407"]],
                             "BEO_NP_20K":["600":["60","0.68","900","105","35K","0.81","700","59","386"],
                                           "800":["106","0.68","900","179","45K","0.89","650","81","407"],
                                           "1000":["152","0.68","900","252","45K","0.89","650","81","407"],
                                           "1400":["244","0.68","900","395","45K","0.89","650","81","407"]],
                             "BEO_NP_30K":["600":["70","0.77","750","128","40K","0.85","675","70","397"],
                                           "800":["130","0.77","750","203","45K","0.89","650","81","407"],
                                           "1000":["189","0.77","750","276","45K","0.89","650","81","407"],
                                           "1400":["306","0.77","750","418","45K","0.89","650","81","407"]],
                             "BEO_NP_40K":["600":["76","0.85","675","148","45K","0.89","650","81","407"],
                                           "800":["148","0.85","675","222","45K","0.89","650","81","407"],
                                           "1000":["219","0.85","675","295","45K","0.89","650","81","407"],
                                           "1400":["360","0.85","675","437","45K","0.89","650","81","407"]],
                             "BEO_P_SL":["600":["37","0.50","1350","54","15K","0.63","1025","22","337"],
                                         "800":["61","0.50","1350","108","35K","0.80","750","53","373"],
                                         "1000":["86","0.50","1350","171","40K","0.85","725","62","382"],
                                         "1400":["134","0.50","1350","304","45K","0.89","725","69","390"]],
                             "BEO_P_5K":["600":["43","0.54","1225","66","20K","0.67","950","30","347"],
                                         "800":["72","0.54","1225","123","35K","0.80","750","53","373"],
                                         "1000":["100","0.54","1225","188","45K","0.89","725","69","390"],
                                         "1400":["156","0.54","1225","321","45K","0.89","725","69","390"]],
                             "BEO_P_10K":["600":["48","0.58","1100","74","25K","0.71","825","38","356"],
                                          "800":["81","0.58","1100","137","40K","0.85","725","62","382"],
                                          "1000":["114","0.58","1100","204","45K","0.89","725","69","390"],
                                          "1400":["180","0.58","1100","337","45K","0.89","725","69","390"]],
                             "BEO_P_20K":["600":["57","0.67","950","98","35K","0.80","750","53","373"],
                                          "800":["101","0.67","950","163","40K","0.85","725","62","382"],
                                          "1000":["144","0.67","950","231","45K","0.89","725","69","390"],
                                          "1400":["230","0.67","950","365","45K","0.89","725","69","390"]],
                             "BEO_P_30K":["600":["68","0.76","800","119","40K","0.85","725","62","382"],
                                          "800":["124","0.76","800","187","45K","0.89","725","69","390"],
                                          "1000":["179","0.76","800","255","45K","0.89","725","69","390"],
                                          "1400":["288","0.76","800","392","45K","0.89","725","69","390"]],
                             "BEO_P_40K":["600":["75","0.85","725","138","45K","0.89","725","69","390"],
                                          "800":["141","0.85","725","207","45K","0.89","725","69","390"],
                                          "1000":["207","0.85","725","275","45K","0.89","725","69","390"],
                                          "1400":["336","0.85","725","398","45K","0.89","725","69","390"]],
                             "SEO_NP_SL":["600":["53","0.44","1650","70","15K","0.54","1350","24","320"],
                                          "800":["87","0.44","1650","123","20K","0.58","1300","32","326"],
                                          "1000":["122","0.44","1650","178","25K","0.62","1275","40","332"],
                                          "1400":["189","0.44","1650","282","25K","0.62","1275","40","332"]],
                             "SEO_NP_5K":["600":["60","0.47","1550","80","20K","0.58","1300","32","326"],
                                          "800":["99","0.47","1550","134","25K","0.62","1275","40","326"],
                                          "1000":["138","0.47","1550","190","25K","0.62","1275","40","332"],
                                          "1400":["214","0.47","1550","294","25K","0.62","1275","40","332"]],
                             "SEO_NP_10K":["600":["65","0.50","1400","91","20K","0.58","1300","32","326"],
                                           "800":["110","0.50","1400","146","25K","0.62","1275","40","332"],
                                           "1000":["154","0.50","1400","201","25K","0.62","1275","40","332"],
                                           "1400":["239","0.50","1400","305","25K","0.62","1275","40","332"]],
                             "SEO_NP_20K":["600":["76","0.58","1300","110","25K","0.62","1275","40","332"],
                                           "800":["131","0.58","1300","166","25K","0.62","1275","40","332"],
                                           "1000":["185","0.58","1300","221","25K","0.62","1275","40","332"],
                                           "1400":["288","0.58","1300","325","25K","0.62","1275","40","332"]],
                             "SEO_NP_30K":["600":["-","-","-","","25K","0.62","1275","40","332"],
                                           "800":["-","-","-","","25K","0.62","1275","40","332"],
                                           "1000":["-","-","-","","25K","0.62","1275","40","332"],
                                           "1400":["-","-","-","","25K","0.62","1275","40","332"]],
                             "SEO_NP_40K":["600":["-","-","-","","25K","0.62","1275","40","332"],
                                           "800":["-","-","-","","25K","0.62","1275","40","332"],
                                           "1000":["-","-","-","","25K","0.62","1275","40","332"],
                                           "1400":["-","-","-","","25K","0.62","1275","40","332"]],
                             "SEO_P_SL":["600":["49","0.41","1650","63","15K","0.53","1450","22","319"],
                                         "800":["81","0.41","1650","111","20K","0.57","1375","30","325"],
                                         "1000":["113","0.41","1650","160","20K","0.57","1375","30","325"],
                                         "1400":["176","0.41","1650","253","20K","0.57","1375","30","325"]],
                             "SEO_P_5K":["600":["55","0.45","1575","72","15K","0.53","1450","22","319"],
                                         "800":["92","0.45","1575","123","20K","0.57","1375","30","325"],
                                         "1000":["128","0.45","1575","171","25K","0.62","1400","30","330"],
                                         "1400":["198","0.45","1575","264","20K","0.57","1375","30","330"]],
                             "SEO_P_10K":["600":["61","0.49","1500","84","20K","0.57","1375","30","325"],
                                          "800":["102","0.49","1500","133","20K","0.57","1375","30","325"],
                                          "1000":["142","0.49","1500","185","25K","0.62","1400","30","330"],
                                          "1400":["221","0.49","1500","275","20K","0.57","1375","30","325"]],
                             "SEO_P_20K":["600":["71","0.57","1375","101","20K","0.57","1375","30","325"],
                                          "800":["120","0.57","1375","153","25K","0.62","1400","30","330"],
                                          "1000":["169","0.57","1375","199","20K","0.57","1375","30","325"],
                                          "1400":["262","0.57","1375","292","20K","0.57","1375","30","325"]],
                             "SEO_P_30K":["600":["-","-","-","","20K","0.57","1375","30","325"],
                                          "800":["-","-","-","","20K","0.57","1375","30","325"],
                                          "1000":["-","-","-","","20K","0.57","1375","30","325"],
                                          "1400":["-","-","-","","20K","0.57","1375","30","325"]],
                             "SEO_P_40K":["600":["-","-","-","","20K","0.57","1375","30","325"],
                                          "800":["-","-","-","","20K","0.57","1375","30","325"],
                                          "1000":["-","-","-","","20K","0.57","1375","30","325"],
                                          "1400":["-","-","-","","20K","0.57","1375","30","325"]]]
        let chartData = "\(numberOfEnginesDefault)_\(podDefault)_\(altitudeDefault)"
        let divertResult = diversionData[chartData]![fuelStatusDefault]!
        return(divertResult)
    }
    //FlameOut Mach at altitude Function
    func getFlameOutMach (flameOutAltitude: String, flameOutTemperature: String) -> String {
        
        let flameOutAltitudeDefault:String
        let flameOutTemperatureDefault:String
        if flameOutAltitude == "" {
            flameOutAltitudeDefault = "35"
        }else {
            flameOutAltitudeDefault = flameOutAltitude
        }
        if flameOutTemperature == "" {
            flameOutTemperatureDefault = "-56"
        }else {
            flameOutTemperatureDefault = flameOutTemperature
        }
        
        var flameOutTable = ["FO_Alt_35":["-56":"0.77","-57":"0.79",
                                          "-58":"0.80","-59":"0.81",
                                          "-60":"0.83","-61":"0.85",
                                          "-62":"0.86","-63":"0.88",
                                          "-64":"0.89","-65":"0.90",
                                          "-66":"0.92"],
                             "FO_Alt_36": ["-56":"0.79",
                                           "-57":"0.80",
                                           "-58":"0.81",
                                           "-59":"0.83",
                                           "-60":"0.84",
                                           "-61":"0.86",
                                           "-62":"0.87",
                                           "-63":"0.89",
                                           "-64":"0.90",
                                           "-65":"0.92",
                                           "-66":"0.93"],
                             "FO_Alt_37": ["-56":"0.80",
                                           "-57":"0.81",
                                           "-58":"0.83",
                                           "-59":"0.84",
                                           "-60":"0.86",
                                           "-61":"0.87",
                                           "-62":"0.89",
                                           "-63":"0.90",
                                           "-64":"0.92",
                                           "-65":"0.93",
                                           "-66":"0.95"],
                             "FO_Alt_38": ["-56":"0.81",
                                           "-57":"0.83",
                                           "-58":"0.84",
                                           "-59":"0.86",
                                           "-60":"0.87",
                                           "-61":"0.89",
                                           "-62":"0.90",
                                           "-63":"0.92",
                                           "-64":"0.93",
                                           "-65":"0.95",
                                           "-66":"0.96"],
                             "FO_Alt_39": ["-56":"0.83",
                                           "-57":"0.84",
                                           "-58":"0.86",
                                           "-59":"0.87",
                                           "-60":"0.89",
                                           "-61":"0.90",
                                           "-62":"0.91",
                                           "-63":"0.93",
                                           "-64":"0.94",
                                           "-65":"0.96",
                                           "-66":"0.98"],
                             "FO_Alt_40" :["-56":"0.85",
                                           "-57":"0.86",
                                           "-58":"0.87",
                                           "-59":"0.89",
                                           "-60":"0.90",
                                           "-61":"0.92",
                                           "-62":"0.93",
                                           "-63":"0.94",
                                           "-64":"0.96",
                                           "-65":"0.98",
                                           "-66":"0.99"],
                             "FO_Alt_41":["-56":"0.86",
                                          "-57":"0.87",
                                          "-58":"0.89",
                                          "-59":"0.90",
                                          "-60":"0.91",
                                          "-61":"0.93",
                                          "-62":"0.94",
                                          "-63":"0.96",
                                          "-64":"0.97",
                                          "-65":"0.99",
                                          "-66":"---"],
                             "FO_Alt_42":["-56":"0.87",
                                          "-57":"0.89",
                                          "-58":"0.90",
                                          "-59":"0.91",
                                          "-60":"0.93",
                                          "-61":"0.94",
                                          "-62":"0.96",
                                          "-63":"0.97",
                                          "-64":"0.99",
                                          "-65":"---",
                                          "-66":"---"],
                             "FO_Alt_43":["-56":"0.89",
                                          "-57":"0.90",
                                          "-58":"0.91",
                                          "-59":"0.93",
                                          "-60":"0.94",
                                          "-61":"0.96",
                                          "-62":"0.97",
                                          "-63":"0.99",
                                          "-64":"---",
                                          "-65":"---",
                                          "-66":"---"],
                             "FO_Alt_44":["-56":"0.90",
                                          "-57":"0.91",
                                          "-58":"0.93",
                                          "-59":"0.94",
                                          "-60":"0.96",
                                          "-61":"0.97",
                                          "-62":"0.99",
                                          "-63":"---",
                                          "-64":"---",
                                          "-65":"---",
                                          "-66":"---"],
                             "FO_Alt_45":["-56":"0.91",
                                          "-57":"0.93",
                                          "-58":"0.94",
                                          "-59":"0.96",
                                          "-60":"0.97",
                                          "-61":"0.99",
                                          "-62":"---",
                                          "-63":"---",
                                          "-64":"---",
                                          "-65":"---",
                                          "-66":"---"]
        ]
        let FO_Alt = "FO_Alt_\(flameOutAltitudeDefault)"
        let flameOutResults = flameOutTable[FO_Alt]![flameOutTemperatureDefault]!
        return(flameOutResults)
    }
    func updateDisplay(){
        if altitudeValue == "" {
            stayAtAltitudeLabel.text = "SL"
        } else {
            stayAtAltitudeLabel.text = altitudeValue
        }
        if divertResultArray[0] == "" {
            stayAtRangeLabel.text = "39"
        }else{
            stayAtRangeLabel.text = divertResultArray[0]
        }
        
        if divertResultArray[1] == "" {
            stayAtMachLabel.text = "0.54"
        }else{
            stayAtMachLabel.text = divertResultArray[1]
        }
        if divertResultArray[2] == "" {
            stayAtFuelFlowLabel.text = "1325"
        }else{
            stayAtFuelFlowLabel.text = divertResultArray[2]
        }
        if divertResultArray[3] == "" {
            climbToRangeLabel.text = "64"
        }else{
            climbToRangeLabel.text = divertResultArray[3]
        }
        if divertResultArray[4] == "" {
            climbToAltitudeLabel.text = "25K"
        }else{
            climbToAltitudeLabel.text = divertResultArray[4]
        }
        if divertResultArray[5] == "" {
            climbToMachLabel.text = "0.68"
        }else{
            climbToMachLabel.text = divertResultArray[5]
        }
        if divertResultArray[6] == "" {
            climbToFuelFlowLabel.text = "900"
        }else{
            climbToFuelFlowLabel.text = divertResultArray[6]
        }
        if divertResultArray[7] == "" {
            descendDistanceOutLabel.text = "32"
        }else{
            descendDistanceOutLabel.text = divertResultArray[7]
        }
        if divertResultArray[8] == "" {
            descendFuelRemainingLabel.text = "352"
        }else{
            descendFuelRemainingLabel.text = divertResultArray[8]
        }

        climbScheduleKCASLabel.text = climbScheduleKCASValue
        climbScheduleMachLabel.text = climbScheduleMachValue
        
        
        
        if flameOutMachValue == "" {
            flameOutMachLabel.text = "---"
        }else if flameOutMachValue == "---" {
            flameOutMachLabel.textColor = UIColor.black
            flameOutMachLabel.text = flameOutMachValue
        }else{
            if let flameOutInt = Float(flameOutMachValue) {
                
                if let climbToMachFloat = Float(divertResultArray[5]){
                    if climbToMachFloat <= flameOutInt {
                        climbToMachLabel.textColor = UIColor.red
                    }else{
                        climbToMachLabel.textColor = UIColor.black
                    }

                }
                if flameOutInt >= 0.90 {
                    flameOutMachLabel.text = flameOutMachValue
                    flameOutMachLabel.textColor = UIColor.red
                }else {
                    flameOutMachLabel.text = flameOutMachValue
                    flameOutMachLabel.textColor = UIColor.black
                }
            }
        }
        }
    
    //GUI's:
    @IBOutlet weak var numberOfEnginesSwitch: UISwitch!
    @IBAction func numberOfEnginesSwitch(_ sender: Any) {
        if (sender as AnyObject).isOn == true{
            numberOfEnginesLabel.text = "2 Engine"
            mainTitleLabel.text = "2 ENGINE"
            mainTitleLabel.textColor = UIColor.black
            numberOfEnginesValue = "BEO"
            divertResultArray = getDiversionData(numberOfEngines: numberOfEnginesValue, pod: PODValue, altitude: altitudeValue, fuelStatus: fuelStatusValue) as! [String]
            print(numberOfEnginesValue)
            print(divertResultArray)
            updateDisplay()
        }
        else{
            numberOfEnginesLabel.text = "1 Engine"
            mainTitleLabel.text = "1 ENGINE"
            mainTitleLabel.textColor = UIColor.red
            numberOfEnginesValue = "SEO"
            divertResultArray = getDiversionData(numberOfEngines: numberOfEnginesValue, pod: PODValue, altitude: altitudeValue, fuelStatus: fuelStatusValue) as! [String]
            print(numberOfEnginesValue)
            print(divertResultArray)
            updateDisplay()
        }
    }
    @IBOutlet weak var podSwitch: UISwitch!
    @IBAction func podSwitch(_ sender: Any) {
        if (sender as AnyObject).isOn == true {
            PODLabel.text = "With POD (WSSP)    "
            PODValue = "P"
            divertResultArray = getDiversionData(numberOfEngines: numberOfEnginesValue, pod: PODValue, altitude: altitudeValue, fuelStatus: fuelStatusValue) as! [String]
            print(divertResultArray)
            print(PODValue)
            updateDisplay()
        }
        else{
            PODLabel.text = "With Out POD (WSSP)"
            PODValue = "NP"
            divertResultArray = getDiversionData(numberOfEngines: numberOfEnginesValue, pod: PODValue, altitude: altitudeValue, fuelStatus: fuelStatusValue) as! [String]
            print(divertResultArray)
            print(PODValue)
            updateDisplay()
        }
    }
    @IBOutlet weak var inputPicker: UIPickerView!
    //Labels
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var numberOfEnginesLabel: UILabel!
    @IBOutlet weak var PODLabel: UILabel!
    //Stay At OutPut Labels:
    @IBOutlet weak var stayAtAltitudeLabel: UILabel!
    @IBOutlet weak var stayAtRangeLabel: UILabel!
    @IBOutlet weak var stayAtMachLabel: UILabel!
    @IBOutlet weak var stayAtFuelFlowLabel: UILabel!
    //Climb To OutPut Labels:
    @IBOutlet weak var climbToAltitudeLabel: UILabel!
    @IBOutlet weak var climbToRangeLabel: UILabel!
    @IBOutlet weak var climbToMachLabel: UILabel!
    @IBOutlet weak var climbToFuelFlowLabel: UILabel!
    //Divert Climb Schedule OutPut Labels:
    @IBOutlet weak var climbScheduleKCASLabel: UILabel!
    @IBOutlet weak var climbScheduleMachLabel: UILabel!
    //Descend Data Labels:
    @IBOutlet weak var descendDistanceOutLabel: UILabel!
    @IBOutlet weak var descendFuelRemainingLabel: UILabel!
    //FlameOut
    @IBOutlet weak var flameOutMachLabel: UILabel!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Input_Array.count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Input_Array[component].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Input_Array[component][row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(component)
        print(row)
        switch (component){
        case 0:
            altitudeValue = Input_Array[component][row]
            divertResultArray = getDiversionData(numberOfEngines: numberOfEnginesValue, pod: PODValue, altitude: altitudeValue, fuelStatus: fuelStatusValue) as! [String]
            print(divertResultArray)
            print(altitudeValue)
            updateDisplay()
        case 1:
            fuelStatusValue = Input_Array[component][row]
            divertResultArray = getDiversionData(numberOfEngines: numberOfEnginesValue, pod: PODValue, altitude: altitudeValue, fuelStatus: fuelStatusValue) as! [String]
            print(divertResultArray)
            print(fuelStatusValue)
            updateDisplay()
        case 2:
            climbToAltFlameOutValue = Input_Array[component][row]
            flameOutMachValue = getFlameOutMach(flameOutAltitude: climbToAltFlameOutValue, flameOutTemperature: climbToTemperatureFlameOutValue)
            print(flameOutMachValue)
            print(climbToAltFlameOutValue)
            updateDisplay()
        case 3:
            climbToTemperatureFlameOutValue = Input_Array[component][row]
            flameOutMachValue = getFlameOutMach(flameOutAltitude: climbToAltFlameOutValue, flameOutTemperature: climbToTemperatureFlameOutValue)
            print(flameOutMachValue)
            print(climbToTemperatureFlameOutValue)
            updateDisplay()
        default:break
        }
        
    }
    
 
    
    //Variations with iPad in Landscape
    //Portrait  = wR x hR
    //landscape = wR x hC
    override public var traitCollection: UITraitCollection {
        if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isLandscape {
            return UITraitCollection(traitsFrom:[UITraitCollection(horizontalSizeClass: .regular), UITraitCollection(verticalSizeClass: .compact)])
        }
        return super.traitCollection
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTitleLabel.text = "2 ENGINE"
        numberOfEnginesLabel.text = "2 Engine"
        podSwitch.isOn = false
        PODLabel.text = "With Out POD (WSSP)"
        stayAtAltitudeLabel.text = "SL"
        stayAtRangeLabel.text = "39"
        stayAtMachLabel.text = "0.54"
        stayAtFuelFlowLabel.text = "1325"
        climbToAltitudeLabel.text = "25K"
        climbToRangeLabel.text = "64"
        climbToMachLabel.text = "0.68"
        climbToFuelFlowLabel.text = "900"
        climbScheduleKCASLabel.text = climbScheduleKCASValue
        climbScheduleMachLabel.text = climbScheduleMachValue
        descendDistanceOutLabel.text = "32"
        descendFuelRemainingLabel.text = "352"
        flameOutMachLabel.text = "---"


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

