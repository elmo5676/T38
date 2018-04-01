//
//  AirportCD+CoreDataProperties.swift
//  T38
//
//  Created by elmo on 3/31/18.
//  Copyright © 2018 elmo. All rights reserved.
//
//

import Foundation
import CoreData


extension AirportCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirportCD> {
        return NSFetchRequest<AirportCD>(entityName: "AirportCD")
    }

    @NSManaged public var tre: Int32
    @NSManaged public var new: Int32

}
