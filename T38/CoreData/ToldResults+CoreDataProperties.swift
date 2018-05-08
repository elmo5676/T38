//
//  ToldResults+CoreDataProperties.swift
//  T38
//
//  Created by elmo on 5/7/18.
//  Copyright © 2018 elmo. All rights reserved.
//
//

import Foundation
import CoreData


extension ToldResults {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToldResults> {
        return NSFetchRequest<ToldResults>(entityName: "ToldResults")
    }

    @NSManaged public var cefsKeyCD: String?
    @NSManaged public var cflKeyCD: String?
    @NSManaged public var crosswindKeyCD: String?
    @NSManaged public var dsKeyCD: String?
    @NSManaged public var efGearDNSECGKeyCD: String?
    @NSManaged public var efGearUPSECGKeyCD: String?
    @NSManaged public var efsaeorKeyCD: String?
    @NSManaged public var gearDNSECGKeyCD: String?
    @NSManaged public var gearUpSECGKeyCD: String?
    @NSManaged public var givenEngFailAKeyCD: String?
    @NSManaged public var headwindKeyCD: String?
    @NSManaged public var macsDistanceKeyCD: String?
    @NSManaged public var macsKeyKeyCD: String?
    @NSManaged public var nacsKeyCD: String?
    @NSManaged public var resultsErrorArray: [String]?
    @NSManaged public var rotationSpeedKeyCD: String?
    @NSManaged public var rsbeoKeyCD: String?
    @NSManaged public var rsefKeyCD: String?
    @NSManaged public var saeorKeyCD: String?
    @NSManaged public var setosKeyCD: String?
    @NSManaged public var takeOffDistanceKeyCD: String?
    @NSManaged public var takeOffSpeedKeyCD: String?
    @NSManaged public var uniqueID_CD: UUID?
    @NSManaged public var toldInput: ToldInputsCD?

}
