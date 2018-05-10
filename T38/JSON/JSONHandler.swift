//
//  JSONHandler.swift
//  T38
//
//  Created by elmo on 5/8/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import Foundation


struct JSONHandler {
    
   
    
    private let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! //as URL?)!
    
    // MARK: DAFIF
    func downloadAllStates(baseUrl url: String) {
        for state in StateCode.allValues {
            print(state.rawValue)
            downloadData("\(url)\(state.rawValue)", fileNamewithExtension: "\(state.rawValue).json")
        }}
    
   
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
        print(fileName)
        let fileAndPath = self.documentsUrl.appendingPathComponent(fileName)
        let fullUrl = "\(baseUrl)\(icao)"
        if FileManager.default.fileExists(atPath: fileAndPath.path) {
            removeFile(fileNamewithExtension: fileName)
            downloadData(fullUrl, fileNamewithExtension: fileName)
        } else {
            downloadData(fullUrl, fileNamewithExtension: fileName)
        }}
    
    func currentWeather(icao: String) -> Weather? {
        var currentWeather: Weather?
//        let documentsURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let weatherUrl = self.documentsUrl.appendingPathComponent("\(icao).json")
//        let weatherUrl = documentsURL.appendingPathComponent(icao).appendingPathExtension("json")
        let decoder = JSONDecoder()
        do {
            currentWeather = try decoder.decode(Weather.self, from: Data(contentsOf: weatherUrl))
        } catch {
            print(error)
        }
        return currentWeather
    }

}

































