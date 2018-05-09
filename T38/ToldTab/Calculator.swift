//
//  Calculator.swift
//  JavaScriptCoreApp
//
//  Created by Jorge Dalmendray on 4/25/18.
//  Copyright © 2018 mine. All rights reserved.
//

import Foundation
import JavaScriptCore

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

class Calculator: NSObject {
    
    let errorsKey = "errors"
    
    private let scriptContext = JSContext()!
    
    override init() {
        super.init()
    }
    
    /// aerobrake:   YES = 1, NO = 2
    /// podMounted:  YES = 1, NO = 0
    func calculate(aerobrake: Int, temperature: Double, temperatureScale: String, pressureAlt: Double,
                   runwayLength: Double, runwayHeading: Double, windDirection: Double, windVelocity: Double,
                   runwaySlope: Double, rcr: Double, acGrossWt: Double, givenEngFailAt: Double, podMounted: Int,
                   callback: @escaping (_ results: Results) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background thread")
            
            self.setupScripts()
            
            // Look up the function in the context
            let function = self.scriptContext.objectForKeyedSubscript("execute")
            
            // Call the function
            let result = function?.call(withArguments: [aerobrake, temperature, temperatureScale, pressureAlt,
                                                        runwayLength, runwayHeading, windDirection, windVelocity,
                                                        runwaySlope, rcr, acGrossWt, givenEngFailAt, podMounted])
            
            // Converting JavaScript JSON to Swift dictionary
            let dict: [String:Any]? = self.convertToDictionary(text: (result?.toString())!)
            
//            print(dict?.description)
            
            // Getting usable results
            let results = self.getResultsFrom(dict: dict!)
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                callback(results)
            }
        }
    }
    
    private func getResultsFrom(dict: [String: Any?]) -> Results {
        var doubleDict = [String: Double?]()
        var stringsDict = [String: String]()
        let errorStrings = dict[errorsKey] as! [String]
        
        for key in dict.keys {
            let value = dict[key]
            if let doubleValue = value as? Double {
                print("It is a Double")
                doubleDict[key] = doubleValue
                stringsDict[key] = String(doubleValue)
            } else if let intValue = value as? Int {
                print("It is an Int")
                doubleDict[key] = Double(intValue)
                stringsDict[key] = String(intValue)
            } else if let stringValue = value as? String {
                print("It is a String")
                stringsDict[key] = stringValue
                
                let stringValueNoSpaces = stringValue.removingWhitespaces()
                
                var doubleValue = Double(stringValueNoSpaces)
                if (key == Results.SAEORKey && stringValueNoSpaces == ">200") {
                    doubleValue = 201.0
                }//EFSAEORKey
                if (key == Results.EFSAEORKey && stringValueNoSpaces == ">200") {
                    doubleValue = 201.0
                }
                
                doubleDict[key] = doubleValue
            } else {
                print("Unrecognized value: \(String(describing: value ?? "Unknown"))")
                doubleDict[key] = nil
                stringsDict[key] = String(describing: value)
            }
        }
        
        return Results(doublesDict: doubleDict, stringsDict: stringsDict, errorsArray: errorStrings)
    }
    
    private func setupScripts() {
        guard
            let scriptPath = Bundle.main.url(forResource: "main_script", withExtension: "js"),
            let javaScriptContent = try? String(contentsOf: scriptPath, encoding: .utf8)
            else {
                print("setupScripts failed")
                return
        }
        self.scriptContext.evaluateScript(javaScriptContent)
    }
    
    private func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func calcTOLDWt(podMounted: Bool, acGrossWt: Double, wtOfCargoInPod: Double) -> Double {
        var tWt = acGrossWt;
        let pcw = wtOfCargoInPod;
        if (podMounted) {
            tWt = (tWt * 1) + (pcw * 1) + (110 * 1);
        }
        
        return tWt;
    }
}
