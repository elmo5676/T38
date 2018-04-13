//
//  RunwayCD+CoreDataProperties.swift
//  T38
//
//  Created by elmo on 4/12/18.
//  Copyright © 2018 elmo. All rights reserved.
//
//

import Foundation
import CoreData


extension RunwayCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RunwayCD> {
        return NSFetchRequest<RunwayCD>(entityName: "RunwayCD")
    }

    @NSManaged public var airportID_CD: String?
    @NSManaged public var akHigh_CD: Int32
    @NSManaged public var akLow_CD: Int32
    @NSManaged public var designator_CD: String?
    @NSManaged public var dimUom_CD: String?
    @NSManaged public var geometryCoordinates_CD: NSObject?
    @NSManaged public var globalID_CD: String?
    @NSManaged public var length_CD: Int32
    @NSManaged public var lightAct_CD: Int32
    @NSManaged public var lightInt_CD: NSObject?
    @NSManaged public var objectID_CD: Int32
    @NSManaged public var pacific_CD: Int32
    @NSManaged public var shapeArea_CD: Double
    @NSManaged public var shapeLength_CD: Double
    @NSManaged public var usArea_CD: Int32
    @NSManaged public var usHigh_CD: Int32
    @NSManaged public var usLow_CD: Int32
    @NSManaged public var width_CD: Int32
    @NSManaged public var airport: AirportCD?

}
