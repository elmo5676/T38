//
//  Extensions.swift
//  Calculator
//
//  Created by elmo on 3/24/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import Foundation
import UIKit

public extension Array where Element: UIButton {
    func colorScheme_Standard() {
        for element in self {
            element.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            element.titleLabel?.textColor = #colorLiteral(red: 0.2771260142, green: 0.3437626958, blue: 0.4359292388, alpha: 1)
            element.layer.borderColor = #colorLiteral(red: 0.2771260142, green: 0.3437626958, blue: 0.4359292388, alpha: 1)
            element.layer.borderWidth = 1
            element.layer.cornerRadius = CGFloat(corner)
        }
    }
    func colorScheme_Dark() {
        for element in self {
            element.backgroundColor = #colorLiteral(red: 0.2771260142, green: 0.3437626958, blue: 0.4359292388, alpha: 1)
            element.titleLabel?.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            element.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            element.layer.borderWidth = 1
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
    @IBInspectable
    public var borderColor: CGColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) {
        didSet {
            self.layer.borderColor = self.borderColor
        }
    }
    @IBInspectable
    public var borderWidth: CGFloat = 1.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
}
