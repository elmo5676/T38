//
//  CalcBrains.swift
//  Calculator
//
//  Created by elmo on 3/24/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import Foundation


class CalcBrains {
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String,Operation> = [
        "𝝅"      : Operation.Constant(Double.pi),
        "e"      : Operation.Constant(M_E),
        "±"      : Operation.UnaryOperation({-$0}),
        "√"      : Operation.UnaryOperation(sqrt),
        "cos"    : Operation.UnaryOperation(cos),
        "c"      : Operation.Constant(0.0),
        
        "×"      : Operation.BinaryOperation({$0 * $1}),
        "÷"      : Operation.BinaryOperation({$0 / $1}),
        "+"      : Operation.BinaryOperation({$0 + $1}),
        "−"      : Operation.BinaryOperation({$0 - $1}),
        "g"      : Operation.BinaryOperation({($0/60) * $1}),
        "."      : Operation.BinaryOperation({$0 + $1}),
        
        "="      : Operation.Equals
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





