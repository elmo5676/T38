//
//  ToldInputsCD+CoreDataProperties.swift
//  T38
//
//  Created by elmo on 5/7/18.
//  Copyright © 2018 elmo. All rights reserved.
//
//

import Foundation
import CoreData


extension ToldInputsCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToldInputsCD> {
        return NSFetchRequest<ToldInputsCD>(entityName: "ToldInputsCD")
    }

    @NSManaged public var aeroBreakingCD: Int16
    @NSManaged public var aircraftGrossWeightCD: Double
    @NSManaged public var celciusOrFerenheightCD: String?
    @NSManaged public var givenEngFailureCD: Double
    @NSManaged public var podCalcTOLDCD: Bool
    @NSManaged public var podCalculateCD: Int16
    @NSManaged public var pressureAltCD: Double
    @NSManaged public var rcrCD: Double
    @NSManaged public var runwayHDGCD: Double
    @NSManaged public var runwayLengthCD: Double
    @NSManaged public var runwaySlopeCD: Double
    @NSManaged public var temperatureCD: Double
    @NSManaged public var uniqueID_CD: UUID?
    @NSManaged public var weightOfCargoInPODCD: Double
    @NSManaged public var weightUsedForTOLDCD: Double
    @NSManaged public var windDirectionCD: Double
    @NSManaged public var windVelocityCD: Double
    @NSManaged public var toldResult: ToldResults?

}
