//
//  JSONHandler.swift
//  T38
//
//  Created by elmo on 5/8/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import Foundation
import UIKit


struct JSONHandler  {
    
   
    
    private let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! //as URL?)!
  
    
    
    
    // MARK: DAFIF
    func downloadAllStates(baseUrl url: String) {
        for state in StateCode.allValues {
            print(state.rawValue)
            downloadData("\(url)\(state.rawValue)", fileNamewithExtension: "\(state.rawValue).json")
        }}
    
    func downlaodMissingStates(_ ms: [String], from url: String){
        for state in ms {
            downloadData("\(url)\(state)", fileNamewithExtension: "\(state).json")
        }
    }
    
    func verifyIfStatesDownloadedfrom(_ url: String) {
        var yesNo = false
        var allStates: [String] = []
        var missingStates: [String] = []
        for state in StateCode.allValues {
            allStates.append(state.rawValue)
            let fileName = "\(state.rawValue).json"
            let fileAndPath = self.documentsUrl.appendingPathComponent(fileName)
            if FileManager.default.fileExists(atPath: fileAndPath.path) {
                yesNo = true
                print("\(state.rawValue): \(yesNo)")
            } else {
                missingStates.append(state.rawValue)
                yesNo = false
                print("\(state.rawValue): \(yesNo)")
            }
        }
        if missingStates.count > 0 {
            downlaodMissingStates(missingStates, from: url)
        }
        print("*****************************************************************************")
        print("Total Number of States: \(allStates.count)")
        print("*****************************************************************************")
        print("Number of States Missing: \(missingStates.count)")
        print("*****************************************************************************")
    }
    
    
    
   
    // MARK: General FileHandling
    func downloadData(_ sourceFile: String, fileNamewithExtension fileName: String) {
        // Create destination URL
        let destinationFileUrl = self.documentsUrl.appendingPathComponent(fileName)
        //Create URL to the source file you want to download
        let fileURL = URL(string: sourceFile)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:fileURL!)
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription as Any);
            }}; task.resume() }
    

    func removeFile(fileNamewithExtension fileName: String) {
        let fileToRemove = self.documentsUrl.appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: fileToRemove)
        } catch {
            print(error)
        }}
    
    func removeAllFiles() {
        do {
            let folderContents = try FileManager.default.contentsOfDirectory(at: self.documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for file in folderContents {
                try FileManager.default.removeItem(at: file)
            }
        } catch {
            print(error)
        }}
    
    func printAvailableDownloads(){
        do {
            try print(FileManager.default.contentsOfDirectory(at: self.documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles))
        } catch {
            print(error)
        }}
    
    // MARK: Weather
    func downloadWeather(baseUrl: String, icao: String) {
        let fileName = "\(icao).json"
        let fileAndPath = self.documentsUrl.appendingPathComponent(fileName)
        print(fileAndPath)
        let fullUrl = "\(baseUrl)\(icao)"
        if FileManager.default.fileExists(atPath: fileAndPath.path) {
            removeFile(fileNamewithExtension: fileName)
            downloadData(fullUrl, fileNamewithExtension: fileName)
            print("\(icao) weather downlaoded")
        } else {
            downloadData(fullUrl, fileNamewithExtension: fileName)
            print("\(icao) weather downlaoded")
        }}
    
    func currentWeather(icao: String) -> Weather? {
        var currentWeather: Weather?
        let weatherUrl = self.documentsUrl.appendingPathComponent("\(icao).json")
        let decoder = JSONDecoder()
        do {
            currentWeather = try decoder.decode(Weather.self, from: Data(contentsOf: weatherUrl))
        } catch {
            print(error)
        }
        print(currentWeather)
        return currentWeather
    }

}

































