//
//  GasStation+CoreDataProperties.swift
//  Gas Station Finder
//
//  Created by cuichen on 14/5/18.
//
//

import Foundation
import CoreData


extension GasStation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GasStation> {
        return NSFetchRequest<GasStation>(entityName: "GasStation")
    }

    @NSManaged public var name: String?
    @NSManaged public var logo: NSData?
    @NSManaged public var photos: NSObject?
    @NSManaged public var address: String?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var detail: String?

}
