//
//  ViewController.swift
//  Calculator
//
//  Created by elmo on 3/24/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import CoreLocation

var corner = 0.0

class CalcViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var operatorLabel: UILabel!
    @IBOutlet var digitButtonCollection: [UIButton]!
    @IBOutlet var operationButtonCollection: [UIButton]!
    @IBOutlet weak var questionButtonOutlet: UIButton!
    
    @IBAction func calcDirectionsButton(_ sender: UIButton) {
//        performSegue(withIdentifier: "calcDirectionsSeque", sender: nil)
    }
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalcBrains()
    @IBAction func nearestButton(_ sender: UIButton) {
        popoverPresentationController?.sourceRect = sender.bounds
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "nearestPop"?:
            if let popoverPresentationController = segue.destination.popoverPresentationController, let sourceView = sender as? UIView {
                popoverPresentationController.sourceRect = sourceView.bounds
                popoverPresentationController.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
            }
        case "calcDirectionsSeque"?:
            if let popoverPresentationController = segue.destination.popoverPresentationController, let sourceView = sender as? UIView {
            popoverPresentationController.sourceRect = sourceView.bounds
            //popoverPresentationController.backgroundColor = #colorLiteral(red: 0.2771260142, green: 0.3437626958, blue: 0.4359292388, alpha: 1)
            
            }

        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        let operatorTitle = sender.currentTitle!
        if sender.currentTitle == "C" {
            brain.clearState()
            operatorLabel.text = " "
        } else {
            let accumValue = String(format: "%.2f", brain.accumulator)
            operatorLabel.text = "\(operatorTitle) \(accumValue)"
        }

        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
            operatorLabel.text = operatorTitle
            
        }
        if let mathmaticalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathmaticalSymbol)
        }
        displayValue = brain.result
    }
    
    
    var locManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        questionButtonOutlet.layer.borderColor = #colorLiteral(red: 0.5724972486, green: 0.5725823045, blue: 0.5724785328, alpha: 1)
        questionButtonOutlet.layer.borderWidth = 1
        questionButtonOutlet.layer.cornerRadius = CGFloat(15)
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        digitButtonCollection.colorScheme_Standard()
        operationButtonCollection.colorScheme_Dark()
        locManager.requestWhenInUseAuthorization()
        locManager.requestAlwaysAuthorization()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}



































