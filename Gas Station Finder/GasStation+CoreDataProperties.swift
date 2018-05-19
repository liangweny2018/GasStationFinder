//
//  GasStation+CoreDataProperties.swift
//  Gas Station Finder
//
//  Created by crow on 19/5/18.
//
//

import Foundation
import CoreData


extension GasStation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GasStation> {
        return NSFetchRequest<GasStation>(entityName: "GasStation")
    }

    @NSManaged public var address: String?
    @NSManaged public var detail: String?
    @NSManaged public var lat: Double
    @NSManaged public var logo: NSData?
    @NSManaged public var lon: Double
    @NSManaged public var name: String?
    @NSManaged public var photos: NSObject?
    @NSManaged public var visit: Int32

}
