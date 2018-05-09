//
//  AirfieldCD+CoreDataProperties.swift
//  T38
//
//  Created by elmo on 5/9/18.
//  Copyright © 2018 elmo. All rights reserved.
//
//

import Foundation
import CoreData


extension AirfieldCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirfieldCD> {
        return NSFetchRequest<AirfieldCD>(entityName: "AirfieldCD")
    }

    @NSManaged public var communications_CD: [CommunicationCD]?
    @NSManaged public var country_CD: String?
    @NSManaged public var elevation_CD: Double
    @NSManaged public var faa_CD: String?
    @NSManaged public var icao_CD: String?
    @NSManaged public var id_CD: Int32
    @NSManaged public var latitude_CD: Double
    @NSManaged public var longitude_CD: Double
    @NSManaged public var mgrs_CD: String?
    @NSManaged public var name_CD: String?
    @NSManaged public var navaids_CD: [NavaidCD]?
    @NSManaged public var runways_CD: [RunwayCD]?
    @NSManaged public var state_CD: String?
    @NSManaged public var timeConversion_CD: String?
    @NSManaged public var communications_R_CD: NSSet?
    @NSManaged public var navaids_R_CD: NSSet?
    @NSManaged public var runways_R_CD: NSSet?

}

// MARK: Generated accessors for communications_R_CD
extension AirfieldCD {

    @objc(addCommunications_R_CDObject:)
    @NSManaged public func addToCommunications_R_CD(_ value: CommunicationCD)

    @objc(removeCommunications_R_CDObject:)
    @NSManaged public func removeFromCommunications_R_CD(_ value: CommunicationCD)

    @objc(addCommunications_R_CD:)
    @NSManaged public func addToCommunications_R_CD(_ values: NSSet)

    @objc(removeCommunications_R_CD:)
    @NSManaged public func removeFromCommunications_R_CD(_ values: NSSet)

}

// MARK: Generated accessors for navaids_R_CD
extension AirfieldCD {

    @objc(addNavaids_R_CDObject:)
    @NSManaged public func addToNavaids_R_CD(_ value: NavaidCD)

    @objc(removeNavaids_R_CDObject:)
    @NSManaged public func removeFromNavaids_R_CD(_ value: NavaidCD)

    @objc(addNavaids_R_CD:)
    @NSManaged public func addToNavaids_R_CD(_ values: NSSet)

    @objc(removeNavaids_R_CD:)
    @NSManaged public func removeFromNavaids_R_CD(_ values: NSSet)

}

// MARK: Generated accessors for runways_R_CD
extension AirfieldCD {

    @objc(addRunways_R_CDObject:)
    @NSManaged public func addToRunways_R_CD(_ value: RunwayCD)

    @objc(removeRunways_R_CDObject:)
    @NSManaged public func removeFromRunways_R_CD(_ value: RunwayCD)

    @objc(addRunways_R_CD:)
    @NSManaged public func addToRunways_R_CD(_ values: NSSet)

    @objc(removeRunways_R_CD:)
    @NSManaged public func removeFromRunways_R_CD(_ values: NSSet)

}
