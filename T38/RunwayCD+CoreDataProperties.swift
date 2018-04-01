//
//  RunwayCD+CoreDataProperties.swift
//  T38
//
//  Created by elmo on 3/31/18.
//  Copyright © 2018 elmo. All rights reserved.
//
//

import Foundation
import CoreData


extension RunwayCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RunwayCD> {
        return NSFetchRequest<RunwayCD>(entityName: "RunwayCD")
    }

    @NSManaged public var test: Int16

}
