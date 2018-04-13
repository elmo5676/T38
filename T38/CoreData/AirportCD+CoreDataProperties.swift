//
//  AirportCD+CoreDataProperties.swift
//  T38
//
//  Created by elmo on 4/12/18.
//  Copyright © 2018 elmo. All rights reserved.
//
//

import Foundation
import CoreData


extension AirportCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirportCD> {
        return NSFetchRequest<AirportCD>(entityName: "AirportCD")
    }

    @NSManaged public var airAnal_CD: String?
    @NSManaged public var akHigh_CD: Int32
    @NSManaged public var akLow_CD: Int32
    @NSManaged public var country_CD: String?
    @NSManaged public var dodHiFlip_CD: Int32
    @NSManaged public var elevation_CD: Double
    @NSManaged public var far91_CD: Int32
    @NSManaged public var far93_CD: Int32
    @NSManaged public var geometryCoordinates_CD: NSObject?
    @NSManaged public var globalID_CD: String?
    @NSManaged public var iapExists_CD: Int32
    @NSManaged public var icaoID_CD: String?
    @NSManaged public var ident_CD: String?
    @NSManaged public var latitude_CD: String?
    @NSManaged public var longitude_CD: String?
    @NSManaged public var milCode_CD: String?
    @NSManaged public var name_CD: String?
    @NSManaged public var objectID_CD: Int32
    @NSManaged public var operStatus_CD: String?
    @NSManaged public var pacific_CD: Int32
    @NSManaged public var privateUse_CD: Int32
    @NSManaged public var serviceCity_CD: String?
    @NSManaged public var state_CD: String?
    @NSManaged public var typeCode_CD: String?
    @NSManaged public var usArea_CD: Int32
    @NSManaged public var usHigh_CD: Int32
    @NSManaged public var usLow_CD: Int32
    @NSManaged public var runways: NSSet?

}

// MARK: Generated accessors for runways
extension AirportCD {

    @objc(addRunwaysObject:)
    @NSManaged public func addToRunways(_ value: RunwayCD)

    @objc(removeRunwaysObject:)
    @NSManaged public func removeFromRunways(_ value: RunwayCD)

    @objc(addRunways:)
    @NSManaged public func addToRunways(_ values: NSSet)

    @objc(removeRunways:)
    @NSManaged public func removeFromRunways(_ values: NSSet)

}
