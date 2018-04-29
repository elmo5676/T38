//
//  Results.swift
//  JavaScriptCoreApp
//
//  Created by Jorge Dalmendray on 4/25/18.
//  Copyright © 2018 mine. All rights reserved.
//

import Foundation

class Results: NSObject {
    
    // Keys for the dictionary returned from the JavaScript code
    static let HeadwindKey = "Headwind"
    static let CrosswindKey = "Crosswind"
    static let MACSKeyKey = "MACS"
    static let MACSDistanceKey = "MACSDistance"
    static let DSKey = "DS"
    static let RSEFKey = "RSEF"
    static let SETOSKey = "SETOS"
    static let SAEORKey = "SAEOR"
    static let GearDNSECGKey = "GearDNSECG"
    static let GearUPSECGKey = "GearUPSECG"
    static let CFLKey = "CFL"
    static let NACSKey = "NACS"
    static let RSBEOKey = "RSBEO"
    static let RotationSpeedKey = "RotationSpeed"
    static let TakeoffSpeedKey = "TakeoffSpeed"
    static let TakeoffDistanceKey = "TakeoffDistance"
    static let CEFSKey = "CEFS"
    static let EFSAEORKey = "EFSAEOR"
    static let EFGearDNSECGKey = "EFGearDNSECG"
    static let EFGearUPSECGKey = "EFGearUPSECG"
    static let givenEngFailAKey = "givenEngFailA"
    
    var doublesDict: [String: Double?]
    var stringsDict: [String: String]
    var errorsArray: [String]
    
    init(doublesDict: [String: Double?], stringsDict: [String: String], errorsArray: [String]) {
        self.doublesDict = doublesDict
        self.errorsArray = errorsArray
        self.stringsDict = stringsDict
        
        super.init()
    }
    
    convenience override init() {
        // calls above mentioned controller with default name
        self.init(doublesDict: [String: Double?](), stringsDict: [String: String](), errorsArray: [String]())
    }
    
    func getStringRepresentation() -> String{
        let dictStringRep = doublesDict.description
        let errorsStringRep = errorsArray.description
        let stringsStringRep = stringsDict.description
        
        return "DoublesDictionary: \(dictStringRep). \n\n StringsDictionary: \(stringsStringRep). \n\n ErrorsArray: \(errorsStringRep)."
    }
}
