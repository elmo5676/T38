//
//  Wind.swift
//  T38_TOLD_CLI
//
//  Created by John Ayers on 5/11/18.
//  Copyright © 2018 Blacksmith Developers. All rights reserved.
//

import Foundation

struct Wind {
    let runwayHeading: Heading
    let windHeading: Heading
    let windSpeed: Double
    
    init(windHeading: Heading, windSpeed: Double, runwayHeading: Heading) {
        self.runwayHeading = runwayHeading
        self.windHeading = windHeading
        self.windSpeed = windSpeed
    }
    
    private var windAngle: Double {
        get {
            return Double((runwayHeading - windHeading).direction)
        }
    }
    
    var headWind: Double {
        get{
            return windSpeed * cos(windAngle * Double.pi / 180)
        }
    }
    
    var crossWind: Double {
        get{
            return abs(Double(windSpeed * sin(windAngle * Double.pi / 180)))
        }
    }
}
