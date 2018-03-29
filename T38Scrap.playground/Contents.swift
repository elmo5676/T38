//: Playground - noun: a place where people can play

import UIKit

////FLAME OUT Inputs
//var flameOutAltitudeScroll:String = ""
//var flameOutTemperatureScroll:String = ""
//var flameOutInputArray = Array<String>()
////Flame Out Results
//var flameOutMach:String
////DiversionInputs
//var diversionDefaultsInputArray = Array<String>()
//var diversionArray = Array<String>()
//var numberOfEnginesSwitchValue:String = ""
//var podSwitchValue:String = ""
//var currentAltitude:String = ""
//var currentFuel:String = ""
////Diversion Results
//var stayAtDivertRange:String
//var stayAtMach:String
//var stayAtFuelFlow:String
//var climbToDivertRange:String
//var climbToAltitude :String
//var climbToMach :String
//var climbToFuelFlow :String
//var descendDistance :String
//var descendFuelRemaining :String
//
//
////Functions:
//func setFlameOutDefaults (flameOutAltitudeDefaultInput: String, flameOutTemperatureDefaultInput: String) -> Array<Any> {
//    let flameOutAltitudeDefault:String
//    let flameOutTemperatureDefault:String
//    let resultsArray:Array<Any>
//    if flameOutAltitudeDefaultInput == "" {
//        flameOutAltitudeDefault = "35"
//    }else {
//        flameOutAltitudeDefault = flameOutAltitudeDefaultInput
//    }
//    if flameOutTemperatureDefaultInput == "" {
//        flameOutTemperatureDefault = "-56"
//    }else {
//        flameOutTemperatureDefault = flameOutTemperatureDefaultInput
//    }
//    resultsArray = [flameOutAltitudeDefault, flameOutTemperatureDefault]
//    print(resultsArray as Any)
//    return(resultsArray)
//}
//flameOutInputArray = (setFlameOutDefaults(flameOutAltitudeDefaultInput: flameOutAltitudeScroll, flameOutTemperatureDefaultInput: flameOutTemperatureScroll) as! Array<String>)
//func getFlameOutMach (flameOutAltitude: String, flameOutTemperature: String) -> String {
//    var flameOutTable = ["FO_Alt_35":["-56":"0.77","-57":"0.79","-58":"0.80","-59":"0.81","-60":"0.83","-61":"0.85","-62":"0.86","-63":"0.88","-64":"0.89","-65":"0.90","-66":"0.92"], "FO_Alt_36": ["-56":"0.79","-57":"0.80","-58":"0.81","-59":"0.83","-60":"0.84","-61":"0.86","-62":"0.87","-63":"0.89","-64":"0.90","-65":"0.92","-66":"0.93"], "FO_Alt_37": ["-56":"0.80","-57":"0.81","-58":"0.83","-59":"0.84","-60":"0.86","-61":"0.87","-62":"0.89","-63":"0.90","-64":"0.92","-65":"0.93","-66":"0.95"], "FO_Alt_38": ["-56":"0.81","-57":"0.83","-58":"0.84","-59":"0.86","-60":"0.87","-61":"0.89","-62":"0.90","-63":"0.92","-64":"0.93","-65":"0.95","-66":"0.96"], "FO_Alt_39": ["-56":"0.83","-57":"0.84","-58":"0.86","-59":"0.87","-60":"0.89","-61":"0.90","-62":"0.91","-63":"0.93","-64":"0.94","-65":"0.96","-66":"0.98"],"FO_Alt_40" :["-56":"0.85","-57":"0.86","-58":"0.87","-59":"0.89","-60":"0.90","-61":"0.92","-62":"0.93","-63":"0.94","-64":"0.96","-65":"0.98","-66":"0.99"],"FO_Alt_41":["-56":"0.86","-57":"0.87","-58":"0.89","-59":"0.90","-60":"0.91","-61":"0.93","-62":"0.94","-63":"0.96","-64":"0.97","-65":"0.99","-66":"---"],"FO_Alt_42":["-56":"0.87","-57":"0.89","-58":"0.90","-59":"0.91","-60":"0.93","-61":"0.94","-62":"0.96","-63":"0.97","-64":"0.99","-65":"---","-66":"---"],"FO_Alt_43":["-56":"0.89","-57":"0.90","-58":"0.91","-59":"0.93","-60":"0.94","-61":"0.96","-62":"0.97","-63":"0.99","-64":"---","-65":"---","-66":"---"],"FO_Alt_44":["-56":"0.90","-57":"0.91","-58":"0.93","-59":"0.94","-60":"0.96","-61":"0.97","-62":"0.99","-63":"---","-64":"---","-65":"---","-66":"---"],"FO_Alt_45":["-56":"0.91","-57":"0.93","-58":"0.94","-59":"0.96","-60":"0.97","-61":"0.99","-62":"---","-63":"---","-64":"---","-65":"---","-66":"---"]
//    ]
//    let FO_Alt = "FO_Alt_\(flameOutAltitude)"
//    let flameOutResults = flameOutTable[FO_Alt]![flameOutTemperature]!
//    return(flameOutResults)
//}
//flameOutMach = (getFlameOutMach(flameOutAltitude: flameOutInputArray[0], flameOutTemperature: flameOutInputArray[1]))
//
//
////setDiversionDefaults sets the inputs to BEO_NP_SL and 600 lbs of gas if nothing has been entered
//func setDiversionDefaults (numberOfEnginesDefaultInput: String, podDefaultInput: String, altitudeDefaultInput: String, fuelStatusDefaultInput: String) -> Array<Any>{
//    let numberOfEnginesDefault:String
//    let podDefault:String
//    let altitudeDefault:String
//    let fuelStatusDefault:String
//    let resultsArray:Array<Any>
//
//    if numberOfEnginesDefaultInput == "" {
//        numberOfEnginesDefault = "BEO"
//    } else {
//        numberOfEnginesDefault = numberOfEnginesDefaultInput
//    }
//    if podDefaultInput == "" {
//        podDefault = "NP"
//    } else {
//        podDefault = podDefaultInput
//    }
//    if altitudeDefaultInput == "" {
//        altitudeDefault = "SL"
//    } else {
//        altitudeDefault = altitudeDefaultInput
//    }
//    if fuelStatusDefaultInput == "" {
//        fuelStatusDefault = "600"
//    } else {
//        fuelStatusDefault = fuelStatusDefaultInput
//    }
//
//    resultsArray = [numberOfEnginesDefault, podDefault, altitudeDefault, fuelStatusDefault]
//    print(resultsArray)
//    return(resultsArray)
//}
//
////diversionDefaultsInputArray creates an input array for getDiversionData
//diversionDefaultsInputArray = (setDiversionDefaults(numberOfEnginesDefaultInput: numberOfEnginesSwitchValue, podDefaultInput: podSwitchValue, altitudeDefaultInput: currentAltitude, fuelStatusDefaultInput: currentFuel) as! Array<String>)
//
//func getDiversionData (numberOfEngines: String, pod: String, altitude: String, fuelStatus: String) -> Array<Any>{
//
//    let numberOfEnginesDefault:String
//    let podDefault:String
//    let altitudeDefault:String
//    let fuelStatusDefault:String
//    let resultsArray:Array<Any>
//
//    if numberOfEngines == "" {
//        numberOfEnginesDefault = "BEO"
//    } else {
//        numberOfEnginesDefault = numberOfEngines
//    }
//    if pod == "" {
//        podDefault = "NP"
//    } else {
//        podDefault = pod
//    }
//    if altitude == "" {
//        altitudeDefault = "SL"
//    } else {
//        altitudeDefault = altitude
//    }
//    if fuelStatus == "" {
//        fuelStatusDefault = "600"
//    } else {
//        fuelStatusDefault = fuelStatus
//    }
//
//
//    var diversionData = ["BEO_NP_SL":["600":["39","0.54","1325","64","20K","0.68","900","32","352"],"800":["65","0.54","1325","124","35K","0.81","700","59","386"],"1000":["90","0.54","1325","196","45K","0.89","650","81","407"],"1400":["142","0.54","1325","339","45K","0.89","650","81","407"]],"BEO_NP_5K":["600":["46","0.56","1200","74","25K","0.73","825","40","363"],"800":["76","0.56","1200","139","40K","0.85","675","70","397"],"1000":["106","0.56","1200","212","45K","0.89","650","81","407"],"1400":["166","0.56","1200","352","45K","0.89","650","81","407"]],"BEO_NP_10K":["600":["51","0.59","1050","84","30K","0.77","750","49","375"],"800":["86","0.59","1050","152","40K","0.85","675","70","397"],"1000":["121","0.59","1050","226","45K","0.89","650","81","407"],"1400":["192","0.59","1050","369","45K","0.89","650","81","407"]],"BEO_NP_20K":["600":["60","0.68","900","105","35K","0.81","700","59","386"],"800":["106","0.68","900","179","45K","0.89","650","81","407"],"1000":["152","0.68","900","252","45K","0.89","650","81","407"],"1400":["244","0.68","900","395","45K","0.89","650","81","407"]],"BEO_NP_30K":["600":["70","0.77","750","128","40K","0.85","675","70","397"],"800":["130","0.77","750","203","45K","0.89","650","81","407"],"1000":["189","0.77","750","276","45K","0.89","650","81","407"],"1400":["306","0.77","750","418","45K","0.89","650","81","407"]],"BEO_NP_40K":["600":["76","0.85","675","148","45K","0.89","650","81","407"],"800":["148","0.85","675","222","45K","0.89","650","81","407"],"1000":["219","0.85","675","295","45K","0.89","650","81","407"],"1400":["360","0.85","675","437","45K","0.89","650","81","407"]],"BEO_P_SL":["600":["37","0.50","1350","54","15K","0.63","1025","22","337"],"800":["61","0.50","1350","108","35K","0.80","750","53","373"],"1000":["86","0.50","1350","171","40K","0.85","725","62","382"],"1400":["134","0.50","1350","304","40K","0.89","725","69","390"]],"BEO_P_5K":["600":["43","0.54","1225","66","20K","0.67","950","30","347"],"800":["72","0.54","1225","123","35K","0.80","750","53","373"],"1000":["100","0.54","1225","188","45K","0.89","725","69","390"],"1400":["156","0.54","1225","321","45K","0.89","725","69","390"]],"BEO_P_10K":["600":["48","0.58","1100","74","25K","0.71","825","38","356"],"800":["81","0.58","1100","137","40K","0.85","725","62","382"],"1000":["114","0.58","1100","204","45K","0.89","725","69","390"],"1400":["180","0.58","1100","337","45K","0.89","725","69","390"]],"BEO_P_20K":["600":["57","0.67","950","98","35K","0.80","750","53","373"],"800":["101","0.67","950","163","40K","0.85","725","62","382"],"1000":["144","0.67","950","231","45K","0.89","725","69","390"],"1400":["230","0.67","950","365","45K","0.89","725","69","390"]],"BEO_P_30K":["600":["68","0.76","800","119","40K","0.85","725","62","382"],"800":["124","0.76","800","187","45K","0.89","725","69","390"],"1000":["179","0.76","800","255","45K","0.89","725","69","390"],"1400":["288","0.76","800","392","45K","0.89","725","69","390"]],"BEO_P_40K":["600":["75","0.85","725","138","45K","0.89","725","69","390"],"800":["141","0.85","725","207","45K","0.89","725","69","390"],"1000":["207","0.85","725","275","45K","0.89","725","69","390"],"1400":["336","0.85","725","398","45K","0.89","725","69","390"]],"SEO_NP_SL":["600":["53","0.44","1650","70","15K","0.54","1350","24","320"],"800":["87","0.44","1650","123","20K","0.58","1300","32","326"],"1000":["122","0.44","1650","178","25K","0.62","1275","40","332"],"1400":["189","0.44","1650","282","25K","0.62","1275","40","332"]],"SEO_NP_5K":["600":["60","0.47","1550","80","20K","0.58","1300","32","326"],"800":["99","0.47","1550","134","25K","0.62","1275","40","326"],"1000":["138","0.47","1550","190","25K","0.62","1275","40","332"],"1400":["214","0.47","1550","294","25K","0.62","1275","40","332"]],"SEO_NP_10K":["600":["65","0.50","1400","91","20K","0.58","1300","32","326"],"800":["110","0.50","1400","146","25K","0.62","1275","40","332"],"1000":["154","0.50","1400","201","25K","0.62","1275","40","332"],"1400":["239","0.50","1400","305","25K","0.62","1275","40","332"]],"SEO_NP_20K":["600":["76","0.58","1300","110","25K","0.62","1275","40","332"],"800":["131","0.58","1300","166","25K","0.62","1275","40","332"],"1000":["185","0.58","1300","221","25K","0.62","1275","40","332"],"1400":["288","0.58","1300","325","25K","0.62","1275","40","332"]],"SEO_NP_30K":["600":["-","-","-","","25K","0.62","1275","40","332"],"800":["-","-","-","","25K","0.62","1275","40","332"],"1000":["-","-","-","","25K","0.62","1275","40","332"],"1400":["-","-","-","","25K","0.62","1275","40","332"]],"SEO_NP_40K":["600":["-","-","-","","25K","0.62","1275","40","332"],"800":["-","-","-","","25K","0.62","1275","40","332"],"1000":["-","-","-","","25K","0.62","1275","40","332"],"1400":["-","-","-","","25K","0.62","1275","40","332"]],"SEO_P_SL":["600":["49","0.41","1650","63","15K","0.53","1450","22","319"],"800":["81","0.41","1650","111","20K","0.57","1375","30","325"],"1000":["113","0.41","1650","160","20K","0.57","1375","30","325"],"1400":["176","0.41","1650","253","20K","0.57","1375","30","325"]],"SEO_P_5K":["600":["55","0.45","1575","72","15K","0.53","1450","22","319"],"800":["92","0.45","1575","123","20K","0.57","1375","30","325"],"1000":["128","0.45","1575","171","25K","0.62","11400","30","330"],"1400":["198","0.45","1575","264","20K","0.57","1375","30","330"]],"SEO_P_10K":["600":["61","0.49","1500","84","20K","0.57","1375","30","325"],"800":["102","0.49","1500","133","20K","0.57","1375","30","325"],"1000":["142","0.49","1500","185","25K","0.62","1400","30","330"],"1400":["221","0.49","1500","275","20K","0.57","1375","30","325"]],"SEO_P_20K":["600":["71","0.57","1375","101","20K","0.57","1375","30","325"],"800":["120","0.57","1375","153","25K","0.62","1400","30","330"],"1000":["169","0.57","1375","199","20K","0.57","1375","30","325"],"1400":["262","0.57","1375","292","20K","0.57","1375","30","325"]],"SEO_P_30K":["600":["-","-","-","","20K","0.57","1375","30","325"],"800":["-","-","-","","20K","0.57","1375","30","325"],"1000":["-","-","-","","20K","0.57","1375","30","325"],"1400":["-","-","-","","20K","0.57","1375","30","325"]],"SEO_P_40K":["600":["-","-","-","","20K","0.57","1375","30","325"],"800":["-","-","-","","20K","0.57","1375","30","325"],"1000":["-","-","-","","20K","0.57","1375","30","325"],"1400":["-","-","-","","20K","0.57","1375","30","325"]]]
//    let chartData = "\(numberOfEnginesDefault)_\(podDefault)_\(altitudeDefault)"
//    let divertResult = diversionData[chartData]![fuelStatusDefault]!
//
//    print(divertResult)
//    return(divertResult)
//}
//
////diversionArray returns the results from the charted tab data using diversionDefaultsInputArray as inputs
//diversionArray = getDiversionData(numberOfEngines: diversionDefaultsInputArray[0], pod: diversionDefaultsInputArray[1], altitude: diversionDefaultsInputArray[2], fuelStatus: diversionDefaultsInputArray[3]) as! Array<String>
//
//
//
//
//
//stayAtDivertRange = diversionArray[0]
//stayAtMach = diversionArray[1]
//stayAtFuelFlow = diversionArray[2]
//climbToDivertRange = diversionArray[3]
//climbToAltitude = diversionArray[4]
//climbToMach = diversionArray[5]
//climbToFuelFlow = diversionArray[6]
//descendDistance = diversionArray[7]
//descendFuelRemaining = diversionArray[8]
//
//print(stayAtDivertRange)
//print(stayAtMach)
//print(stayAtFuelFlow)
//print(climbToDivertRange)
//print(climbToAltitude)
//print(climbToMach)
//print(climbToFuelFlow)
//print(descendDistance)
//print(descendFuelRemaining)
//
//
//
//
/////Below HERE
/////class FirstViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
//
////Pod Switch Controller
//@IBAction func POD_Switch(_ sender: UISwitch) {
//    if (sender.isOn == true){
//        POD_Label.text = "With POD (WSSP)"
//        let podText = "P"
//        podTextLabel.text = podText
//        results()
//
//    }
//    else{
//        POD_Label.text = "With Out POD (WSSP)"
//        let podText = "NP"
//        podTextLabel.text = podText
//        results()
//
//    }
//}
//
////Number of Engines Switch Controller
//@IBAction func numberOfEnginesSwitch(_ sender: UISwitch) {
//    if (sender.isOn == true){
//        numberOfEnginesLabel.text = "2 Engine"
//        mainTitleLabel.text = "2 Engine"
//        mainTitleLabel.textColor = UIColor.black
//        let engineText = "BEO"
//        engineTextLabel.text = engineText
//        results()
//
//    }
//    else{
//        numberOfEnginesLabel.text = "1 Engine"
//        mainTitleLabel.text = "1 Engine"
//        mainTitleLabel.textColor = UIColor.red
//        let engineText = "SEO"
//        engineTextLabel.text = engineText
//        results()
//    }
//}
//
/////Picker View
////Input variables order: Current Altitude, Climb to Altitude, Temperature, Current Fule state
//var Input_Array = [
//    ["SL","5K","10K","20K","30K","40K"],["600","800","1000","1400"],["35","36","37","38","39","40","41","42","43","44","45"],["-56","-57","-58","-59","-60","-61","-62","-63","-64","-65","-66"],
//]
//func numberOfComponents(in pickerView: UIPickerView) -> Int {
//    return Input_Array.count
//}
//func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//    return Input_Array[component].count
//}
//func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//    return Input_Array[component][row]
//}
//func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//    print(component)
//    print(row)
//    switch (component){
//    case 0:
//        currentAltitude = Input_Array[component][row]
//        alt_Label.text = currentAltitude
//        altitudeTextLabel.text = currentAltitude
//        Fuel_Label.text = currentFuel
//
//    case 1:
//        currentFuel = Input_Array[component][row]
//        alt_Label.text = currentAltitude
//        Fuel_Label.text = currentFuel
//
//    case 2:
//        flameOutAltitudeScroll = Input_Array[component][row]
//        ClimbTo_Label.text = flameOutAltitudeScroll
//        flameOutMach = (getFlameOutMach(flameOutAltitude: flameOutAltitudeScroll, flameOutTemperature: flameOutTemperatureScroll))
//        print(flameOutAltitudeScroll)
//    case 3:
//        flameOutTemperatureScroll = Input_Array[component][row]
//        Temp_Label.text = flameOutTemperatureScroll
//        flameOutMach = (getFlameOutMach(flameOutAltitude: flameOutAltitudeScroll, flameOutTemperature: flameOutTemperatureScroll))
//        print(flameOutTemperatureScroll)
//    default:break
//    }
//
//}
//
//
//
//
//
//var divertClimbScheduleBEO: Dictionary<String, Array<Double>> = ["SL":[0.75,496],"5K":[0.76,466],"10K":[0.78,435],"15K":[0.79,406],"20K":[0.81,377],"25K":[0.83,349],"30K":[0.84,322],"35K":[0.86,295],"40K":[0.87,264],"45K":[0.87,236]]
//
//var divertClimbScheduleSEO: Dictionary<String, Array<Double>> = ["SL":[0.43,281],"5K":[0.46,278],"10K":[0.49,271],"15K":[0.52,264],"20K":[0.56,256],"25K":[0.59,246]]
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//



public extension Double {
    //http://www.kylesconverter.com
    var radiansToDegrees: Double { return self * 180 / Double.pi }
    var degreesToRadians: Double { return self * Double.pi / 180 }
    var metersToFeet: Double { return self * 3.2808399 }
    var feetToMeters: Double { return self * 0.3048 }
    var metersToNauticalMiles: Double { return self * 0.0005396118248380001 }
    var nauticalMilesToMeters: Double { return self * 1852 }
    
    public func lat_DDdddd_To_DDMMdd() -> String {
        let lat = self
        let degPart = floor(abs(lat))
        let decimalPart = abs(lat).truncatingRemainder(dividingBy: 1)
        let MMdd = decimalPart * 60
        var MMddProper = ""
        if MMdd < 10 {
            MMddProper = "0\(String(format: "%.2f", MMdd))"
        } else {
            MMddProper = String(format: "%.2f", MMdd)
        }
        var northOrSouth = ""
        if lat < 0 {
            northOrSouth = "S"
        } else {
            northOrSouth = "N"
        }
        let coordReturn = "\(Int(degPart))°\(MMddProper) \(northOrSouth)"
        return coordReturn
    }
    
    public func long_DDdddd_To_DDMMdd() -> String {
        let long = self
        let degPart = floor(abs(long))
        let decimalPart = abs(long).truncatingRemainder(dividingBy: 1)
        let MMdd = decimalPart * 60
        var MMddProper = ""
        if MMdd < 10 {
            MMddProper = "0\(String(format: "%.2f", MMdd))"
        } else {
            MMddProper = String(format: "%.2f", MMdd)
        }
        var eastOrWest = ""
        if long < 0 {
            eastOrWest = "W"
        } else {
            eastOrWest = "E"
        }
        let coordReturn = "\(Int(degPart))°\(MMddProper) \(eastOrWest)"
        return coordReturn
    }
}

public extension UIColor {
    //use the following in conjunction with defining colors in the .assets
    static let matrixGreen = UIColor(named: "matrixGreen")
    static let HUDred = UIColor(named: "HUDred")
    static let vibrantGreen = UIColor(named: "vibrantGreen")
    static let foreFlightBlue = UIColor(named: "foreFlightBlue")
}




public extension String {
    // MARK: Coordinate Translator
    func coordinateTranslate() -> [Double] {
        let coordInput = self
        let coords = coordInput.capitalized
        var coordsArray = coords.components(separatedBy: "/")
        var lattitude: Double = 0.0
        var longitude = 0.0
        if coordsArray[0].range(of: "N") != nil {
            let lattitudeString = String(coordsArray[0].dropLast())
            lattitude = Double(lattitudeString)!
        } else {
            let lattitudeString = String(coordsArray[0].dropLast())
            lattitude = -1 * Double(lattitudeString)!
        }
        if coordsArray[1].range(of: "W") != nil {
            let longitudeString = String(coordsArray[1].dropLast())
            longitude = -1 * Double(longitudeString)!
        } else {
            let longitudeString = String(coordsArray[1].dropLast())
            longitude = Double(longitudeString)!
        }
        let coordCalculatedArray: Array = [lattitude,longitude]
        return coordCalculatedArray
    }
    // MARK: A Better Coordinate Translator
    /*
     It can handle all of the following formats and returns an Array of Doubles
     [latitude, longitude]
     // MARK: DD°MM.dd
     "S3743.15/W12123.15"
     "s3743.15/w12123.15"
     "3743.15N/12123.15W"
     "3743.15n/12123.15w"
     "3743.15/-12123.15"
     "N3743.15 W12123.15"
     "n3743.15 w12123.15"
     "3743.15N 12123.15W"
     "3743.15n 12123.15w"
     "-3743.15 -12123.15"
     
     // MARK: DD.dddd
     "N37.4315/e121.2315"
     "s37.4315/w121.2315"
     "37.4315N/121.2315W"
     "37.4315n/121.2315w"
     "37.4315/-121.2315"
     "N37.4315 W121.2315"
     "n37.4315 w121.2315"
     "37.4315N 121.2315W"
     "37.4315n 121.2315w"
     "-37.4315 -121.2315"
     
     
     The following formats are acceptable:
     NDD°MM.dd/WDDD°MM.dd
     DD°MM.ddN/DDD°MM.ddW
     nDD°MM.dd/wDDD°MM.dd
     DD°MM.ddn/DDD°MM.ddw
     -DD°MM.dd/-DDD°MM.dd
     
     NDD°MM.dd WDDD°MM.dd
     DD°MM.ddN DDD°MM.ddW
     nDD°MM.dd wDDD°MM.dd
     DD°MM.ddn DDD°MM.ddw
     -DD°MM.dd -DDD°MM.dd
     
     NDD.dddd/WDDD.dddd
     DD.ddddN/DDD.ddddW
     nDD.dddd/wDDD.dddd
     DD.ddddn/DDD.ddddw
     -DD.dddd/-DDD.dddd
     
     NDD.dddd WDDD.dddd
     DD.ddddN DDD.ddddW
     nDD.dddd wDDD.dddd
     DD.ddddn DDD.ddddw
     -DD.dddd -DDD.dddd
     */
    public func coordTranslate() -> [Double] {
        let coords = self
        let latDouble: Double
        let longDouble: Double
        var coordArray = [Double]()
        func coordLatConvert(coord: Double) -> Double {
            var result = 0.0
            if coord < 0.0 {
                if abs(coord) > 90.0 {
                    let degrees = floor(abs(coord/100))
                    let decimalDegrees = coord.truncatingRemainder(dividingBy: 100.0)/60.0 * -1
                    result = (degrees + decimalDegrees) * -1
                } else {
                    result = coord
                }
            } else {
                if abs(coord) > 90.0 {
                    let degrees = floor(coord/100)
                    let decimalDegrees = coord.truncatingRemainder(dividingBy: 100.0)/60.0
                    result = degrees + decimalDegrees
                } else {
                    result = coord
                }
            }
            return result
        }
        func coordLongConvert(coord: Double) -> Double {
            var result = 0.0
            if coord < 0.0 {
                if abs(coord) > 180.0 {
                    let degrees = floor(abs(coord)/100)
                    let decimalDegrees = coord.truncatingRemainder(dividingBy: 100.0)/60.0 * -1
                    result = (degrees + decimalDegrees) * -1
                } else {
                    result = coord
                }
            } else {
                if abs(coord) > 180.0 {
                    let degrees = floor(abs(coord)/100)
                    let decimalDegrees = coord.truncatingRemainder(dividingBy: 100.0)/60.0
                    result = degrees + decimalDegrees
                } else {
                    result = coord
                }
            }
            return result
        }
        if coords.contains("/") {
            let latString = coords.split(separator: "/")[0].uppercased()
            if latString.contains("N") {
                latDouble = Double(latString.replacingOccurrences(of: "N", with: ""))!
                coordArray.append(coordLatConvert(coord: latDouble))
            } else if latString.contains("S") {
                latDouble = Double(latString.replacingOccurrences(of: "S", with: ""))!
                coordArray.append(coordLatConvert(coord: latDouble) * (-1))
            } else {
                latDouble = Double(String(latString))!
                coordArray.append(coordLatConvert(coord: latDouble))
            }
            
            let longString = coords.split(separator: "/")[1].uppercased()
            if longString.contains("E") {
                longDouble = Double(longString.replacingOccurrences(of: "E", with: ""))!
                coordArray.append(coordLongConvert(coord: longDouble))
            } else if longString.contains("W") {
                longDouble = Double(longString.replacingOccurrences(of: "W", with: ""))!
                coordArray.append(coordLongConvert(coord: longDouble) * (-1))
            } else {
                longDouble = Double(String(longString))!
                coordArray.append(coordLongConvert(coord: longDouble))
            }
        } else if coords.contains(" ") {
            let latString = coords.split(separator: " ")[0].uppercased()
            if latString.contains("N") {
                latDouble = Double(latString.replacingOccurrences(of: "N", with: ""))!
                coordArray.append(coordLatConvert(coord: latDouble))
            } else if latString.contains("S") {
                latDouble = Double(latString.replacingOccurrences(of: "S", with: ""))!
                coordArray.append(coordLatConvert(coord: latDouble) * (-1))
            } else {
                latDouble = Double(String(latString))!
                coordArray.append(coordLatConvert(coord: latDouble))
            }
            
            let longString = coords.split(separator: " ")[1].uppercased()
            if longString.contains("E") {
                longDouble = Double(longString.replacingOccurrences(of: "E", with: ""))!
                coordArray.append(coordLongConvert(coord: longDouble))
            } else if longString.contains("W") {
                longDouble = Double(longString.replacingOccurrences(of: "W", with: ""))!
                coordArray.append(coordLongConvert(coord: longDouble) * (-1))
            } else {
                longDouble = Double(String(longString))!
                coordArray.append(coordLongConvert(coord: longDouble))
            }
        } else {
            //Insert Alert Here for improper format
            print("nope")
        }
        print(coordArray)
        return coordArray
    }
    
    public func jsonCoordProcessing() -> String {
        let coordInput = self
        var coords = ""
        var coordPartArray = coordInput.components(separatedBy: "-")
        let DD = Double(coordPartArray[0])
        let MM = Double(coordPartArray[1])!/60
        let SS = Double(coordPartArray[2].dropLast())!/60/100
        let NSEW = coordPartArray[2].removeLast()
        let DDmmss = "\(NSEW)\(String(DD! + MM + SS))"
        coords = "\(DDmmss)"
        print(coords)
        return coords
    }
    
    public func importFlightPlanFromForeflight() -> [String:String] {
        let clipBaord = "Clip Board"
        var importAll = [String:String]()
        let foreflightFlightPlan = self
        var latLong = foreflightFlightPlan.split(separator: " ")
        let positionOfFFAltitudeString = latLong.count - 1
        latLong.remove(at: positionOfFFAltitudeString)
        var coordString = ""
        for latlongs in latLong {
            let x = String(latlongs)
            let lat = x.coordTranslate()[0]
            let long = x.coordTranslate()[1]
            coordString += "\(long),\(lat),500\r"
        }
        importAll[clipBaord] = coordString
        return importAll
    }
}





var x = 60.0.degreesToRadians

sin(x)































































