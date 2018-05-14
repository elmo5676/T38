//
//  Extensions.swift
//  Calculator
//
//  Created by elmo on 3/24/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import Foundation
import UIKit




public extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

public extension String {
    func latitudeStringToDouble() -> Double {
        var lat = 0.0
        var a = self.split(separator: "-")
        let b = Double(a[0])!
        let c = Double(a[1])!/60.0
        let d = a[2]
        if d.contains("N") {
            let e = d.replacingOccurrences(of: "N", with: "")
            let f = Double(e)!/3600
            lat = b + c + f
        } else if d.contains("S") {
            let e = d.replacingOccurrences(of: "S", with: "")
            let f = Double(e)!/3600
            lat = -1 * (b + c + f)
        }
        return lat
    }
    func longitudeStringToDouble() -> Double {
        var long = 0.0
        var a = self.split(separator: "-")
        let b = Double(a[0])!
        let c = Double(a[1])!/60.0
        let d = a[2]
        if d.contains("E") {
            let e = d.replacingOccurrences(of: "E", with: "")
            let f = Double(e)!/3600
            long = b + c + f
        } else if d.contains("W") {
            let e = d.replacingOccurrences(of: "W", with: "")
            let f = Double(e)!/3600
            long = -1 * (b + c + f)
        }
        return long
    }
}


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



public extension Array where Element: UIButton {
    func colorScheme_Standard() {
        for element in self {
            element.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            element.titleLabel?.textColor = #colorLiteral(red: 0.2771260142, green: 0.3437626958, blue: 0.4359292388, alpha: 1)
            element.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            //element.layer.borderWidth = 0.0
            element.layer.cornerRadius = CGFloat(corner)
        }
    }
    func colorScheme_Dark() {
        for element in self {
            element.backgroundColor = #colorLiteral(red: 0.2771260142, green: 0.3437626958, blue: 0.4359292388, alpha: 1)
            element.titleLabel?.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            element.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            //element.layer.borderWidth = 0.0
            element.layer.cornerRadius = CGFloat(corner)
        }
    }
}

@IBDesignable class customButton: UIButton {
    @IBInspectable
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
//    @IBInspectable
//    public var borderColor: CGColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1) {
//        didSet {
//            self.layer.borderColor = self.borderColor
//        }
//    }
//    @IBInspectable
//    public var borderWidth: CGFloat = 2.0 {
//        didSet {
//            self.layer.borderWidth = self.borderWidth
//        }
//    }
}
