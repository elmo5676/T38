//
//  Heading.swift
//  T38_TOLD_CLI
//
//  Created by John Ayers on 5/11/18.
//  Copyright © 2018 Blacksmith Developers. All rights reserved.
//

import Foundation

struct Heading: Equatable, CustomStringConvertible {
    var description: String {
        return "\(direction)"
    }
    
    static func ==(lhs: Heading, rhs: Heading) -> Bool {
        return lhs.direction == rhs.direction
    }
    
    static func +(lhs: Heading, rhs: Heading) -> Heading {
        var total = lhs.direction + rhs.direction
        total = total % 360
        if total < 0 {
            total = 360 - abs(total)
            total %= 360
        }
        return Heading(total)
    }
    
    static func -(lhs: Heading, rhs: Heading) -> Heading {
        var total = lhs.direction - rhs.direction
        total = total % 360
        if total < 0 {
            total = 360 - abs(total)
            total %= 360
        }
        return Heading(total)
    }
    
    var direction: Int {
        didSet(old) {
            if (direction < 0 || direction > 360){
                direction = direction % 360
            }
        }
    }
    
    init(_ hdg: Int) {
        let newDirection = abs(hdg) % 360
        direction = newDirection
    }
}
