//
//  ViewController.swift
//  Calculator
//
//  Created by elmo on 3/24/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit

var corner = 30.0

class CalcViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet var digitButtonCollection: [UIButton]!
    @IBOutlet var operationButtonCollection: [UIButton]!
    
    
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
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathmaticalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathmaticalSymbol)
        }
        displayValue = brain.result
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        display.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        display.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        display.layer.cornerRadius = CGFloat(corner)
        self.view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        digitButtonCollection.colorScheme_Standard()
        operationButtonCollection.colorScheme_Dark()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}



































