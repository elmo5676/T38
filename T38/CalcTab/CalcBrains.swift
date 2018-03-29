//
//  CalcBrains.swift
//  Calculator
//
//  Created by elmo on 3/24/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import Foundation

class CalcBrains {
    var accumulator = 0.0
    var crossWindtracker = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    func calcXWComp(_ runwayHDG: Double, _ windHDG: Double) -> Double {
        let xw = abs(sin(abs((runwayHDG-windHDG).degreesToRadians)))
        crossWindtracker += 1
        accumulator = xw
        return xw
    }
    
    func calcXW(_ xwComp: @escaping ((Double, Double) -> Double), _ windVelocity: Double) -> Double {
        _ = xwComp
        let crossWind = windVelocity*accumulator
        crossWindtracker = 0
        return crossWind
    }
    
    func clearState(){
        accumulator = 0.0
        pending = nil
        crossWindtracker = 0.0
    }
   
    
    private var operations: Dictionary<String,Operation> = [
        "𝝅"      : Operation.Constant(Double.pi),
        "e"      : Operation.Constant(M_E),
        "±"      : Operation.UnaryOperation({-$0}),
        "√"      : Operation.UnaryOperation(sqrt),
        "cos"    : Operation.UnaryOperation(cos),
        "C"      : Operation.Constant(0.0),
        
        "×"      : Operation.BinaryOperation({$0 * $1}),
        "÷"      : Operation.BinaryOperation({$0 / $1}),
        "+"      : Operation.BinaryOperation({$0 + $1}),
        "−"      : Operation.BinaryOperation({$0 - $1}),
        "G"      : Operation.BinaryOperation({($0/60) * $1}),
        "."      : Operation.BinaryOperation({$0 + $1}),
        
        // TODO: Wind Function
        // Display XW and HW/TW components
        //$0 = wind dir, $1 = runway HDG, $3 = wind Speed
        //"W"    : Operation.BinaryOperation($0...$1...$3),
        
        "W"     :  Operation.BinaryOperation({sin($0.degreesToRadians) * $1}),
        
        "="     : Operation.Equals
    ]
    
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
}





