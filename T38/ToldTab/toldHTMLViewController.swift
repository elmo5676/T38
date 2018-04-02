//
//  toldHTMLViewController.swift
//  T38
//
//  Created by elmo on 2/4/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import WebKit

extension toldHTMLViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 didFailProvisionalNavigation navigation: WKNavigation!,
                 withError error: Error) {
        let complaint = "Could not load \(indexURL). At least AF Comm doesn't have to get involved"
        let alert = UIAlertController(title: "No Luck", message: complaint, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "I'll Try Again Later", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

class toldHTMLViewController: UIViewController {    
    
    let tc = UIScreen.main.traitCollection
    
    
    var webView: WKWebView!
    @IBOutlet weak var noteButtonOutlet: UIButton!
    @IBAction func noteButton(_ sender: UIButton) {
    }
    
    let url = Bundle.main.path(forResource: "index", ofType: "html")
    var indexURL = URL(string: "http://localhost:5000")!
    var request: URLRequest
    
    required init?(coder aDecoder: NSCoder) {
        request = URLRequest(url: indexURL)
        super.init(coder: aDecoder)
    }
    
    func loadInternalHTML() -> URLRequest {
        let url = Bundle.main.path(forResource: "index", ofType: "html")
        indexURL = URL(fileURLWithPath: url!)
        request = URLRequest(url: indexURL)
        return request
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.title") { (result, error) -> Void in
            let pageTitle = result as? String ?? "Catalog"
            print("\(pageTitle)")
        }
    }
    
    //TODO: For Tomorrow
    //Get local weather and have it auto fill:
    //Temperature in Celcius
    //Pressure Altitude
    //Wind Direction
    //Wind Velocity
    
    
    
    //MARK: Input Variable
    var aeroBraking = true
    //Temp: -20 to 122
    var temperature = "0"
    var tempScale = "F"
    //Pressure Alt: 0 to 6000
    var pressureAlt = "200"
    //Runway Length: 7000 to 15000
    var runwayLength = "12000"
    //Runway Heading: 0 to 359
    var runwayHDG = "150"
    //WindDirectio: 0 to 359
    var windDir = "150"
    //Wind Velocity: 0 to 40
    var windVelocity = "10"
    //Runway Slope: -6 to 6
    var runwaySlope = "0"
    //RCR: 5 to 23
    var rcr = "23"
    //Aircraft Gross Weight: 11000 to 14000
    var aircraftGrossWeight = "12700"
    //Pod Weight: 0 to 140
    var podCargoWeight = "0"
    var podMounted = false
    //Weight used for told: Max = 14000
    var weightUsedForTOLD = "12700"
    //Given Engine Failure: No restrictions
    var givenEngFailure = "0"
    func aerobreaking(trueOrFalse : Bool) -> String {
        var aeroBreaking = "false"
        if trueOrFalse == true {
            aeroBreaking = "true"
        } else {
            aeroBreaking = "false"
        }
        return aeroBreaking
    }
    func tempScale(cOrF: String) -> String {
        var cOrFAnswer = "false"
        if cOrF == "C" {
            cOrFAnswer = "false"
        } else {
            cOrFAnswer = "true"
        }
        return cOrFAnswer
    }
    func thereIsAPod(_ trueOrFalse: Bool) -> String {
        var pod = "false"
        if trueOrFalse == true {
            pod = "true"
        } else {
            pod = "false"
        }
        return pod
    }
    
    //MARK: JavaScript Code
    func javaScriptForInsertingValuesIntoTOLD() -> String {
        let submitFormJavaScript = """
                                    document.getElementById('aeroBrakingYes').checked = \(aerobreaking(trueOrFalse: aeroBraking));
                                    document.getElementById('temperature').value = '\(temperature)';
                                    document.getElementById('temperatureScaleF').checked = \(tempScale(cOrF: tempScale));
                                    document.getElementById('pressureAlt').value = '\(pressureAlt)';
                                    document.getElementById('runwayLength').value = '\(runwayLength)';
                                    document.getElementById('runwayHeading').value = '\(runwayHDG)';
                                    document.getElementById('windDirection').value = '\(windDir)';
                                    document.getElementById('windVelocity').value = '\(windVelocity)';
                                    document.getElementById('runwaySlope').value = '\(runwaySlope)';
                                    document.getElementById('rcr').value = '\(rcr)';
                                    document.getElementById('acGrossWt').value = '\(aircraftGrossWeight)';
                                    document.getElementById('podCargoWt').value = '\(podCargoWeight)';
                                    document.getElementById('podMountedYes').checked = \(thereIsAPod(podMounted));
                                    document.getElementById('wtUsedForTOLD').value = '\(weightUsedForTOLD)';
                                    document.getElementById('givenEngFailAt').value = '\(givenEngFailure)';
                                    document.getElementsByClassName('btn btn-xs btn-success')[0].click();
                                    """
        
//        document.getElementById('resetFormButton').value = '\()';
        return submitFormJavaScript
    }
    
    //MARK: Bring To Front
    func bringToFront() {
        view.bringSubview(toFront: noteButtonOutlet)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteButtonOutlet.layer.cornerRadius = 20
        noteButtonOutlet.layer.borderWidth = 3
        noteButtonOutlet.layer.borderColor = #colorLiteral(red: 0.2771260142, green: 0.3437626958, blue: 0.4359292388, alpha: 1).cgColor
        
        //Set the content controller
        let userContentController = WKUserContentController()
        let source = javaScriptForInsertingValuesIntoTOLD()
        
        //Call the JavaScript and enter the variables and hit submit
        let userScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        userContentController.addUserScript(userScript)

        let configuration = WKWebViewConfiguration()
        configuration.preferences.javaScriptEnabled = true
        configuration.userContentController = userContentController
        webView = WKWebView(frame: view.frame, configuration: configuration)
        webView.autoresizingMask = [ .flexibleHeight, .flexibleWidth]
        view.addSubview(webView)
        webView.load(loadInternalHTML())
        webView.navigationDelegate = self
        bringToFront()
        }
}




















