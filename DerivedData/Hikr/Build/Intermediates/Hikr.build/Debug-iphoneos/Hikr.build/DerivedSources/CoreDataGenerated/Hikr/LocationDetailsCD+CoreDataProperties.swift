//
//  LocationDetailsCD+CoreDataProperties.swift
//  
//
//  Created by Julien Coulon on 10/12/2016.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension LocationDetailsCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationDetailsCD> {
        return NSFetchRequest<LocationDetailsCD>(entityName: "LocationDetailsCD");
    }

    @NSManaged public var altitude: Double
    @NSManaged public var course: Double
    @NSManaged public var horizontalAccuracy: Double
    @NSManaged public var id: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var speed: Double
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var user: String?
    @NSManaged public var verticalAccuracy: Double

}
