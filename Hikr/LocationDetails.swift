//
//  LocationDetails+CoreDataClass.swift
//  
//
//  Created by Julien Coulon on 09/12/2016.
//
//  This file was automatically generated and should not be edited.
//

import UIKit
import Foundation
import CoreData
import CoreLocation

public class LocationDetails: NSObject {
    
    var id: String?
    var user: String?
    // CLLocation Properties
    var latitude: Double?
    var longitude: Double?
    var altitude:Double?
    var timestamp: Date?
    var horizontalAccuracy: Double?
    var verticalAccuracy: Double?
    var speed: Double?
    var course: Double?
    
    func initFromLocation(hikeId: String, user: String, location: CLLocation) {
        self.id = hikeId
        self.user = user
        // CLLocation Properties
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.altitude = location.altitude
        self.timestamp = location.timestamp as Date
        self.horizontalAccuracy = location.horizontalAccuracy
        self.verticalAccuracy = location.verticalAccuracy
        self.speed = location.speed
        self.course = location.course
    }
    
    // receive context and store object in core data. return true if ok, false if not
    func storeInCoreData() -> Bool {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
    
        if let id = id,
        let user = user,
        let latitude = latitude,
        let longitude = longitude,
        let altitude = altitude,
        let horizontalAccuracy = horizontalAccuracy,
        let verticalAccuracy = verticalAccuracy,
        let course = course,
        let speed = speed,
        let timestamp = timestamp
        {
            let locationDetailsCD = LocationDetailsCD(context: context)
            locationDetailsCD.id = id
            locationDetailsCD.user = user
            locationDetailsCD.latitude = latitude
            locationDetailsCD.longitude = longitude
            locationDetailsCD.altitude = altitude
            locationDetailsCD.timestamp = timestamp as NSDate?
            locationDetailsCD.horizontalAccuracy = horizontalAccuracy
            locationDetailsCD.verticalAccuracy = verticalAccuracy
            locationDetailsCD.course = course
            locationDetailsCD.speed = speed
            // Save the data to core data
            appDel.saveContext()
            return true
        } else {
            return false
        }
    }
    
    func getCoordinates() -> CLLocationCoordinate2D {
        if let lat =  latitude, let lon = longitude {
            let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        return coord
        } else {
            return CLLocationCoordinate2D()
        }
    }
    
    func getCLLocation() -> CLLocation {
        if let altitude = altitude,
            let horizontalAccuracy = horizontalAccuracy,
            let verticalAccuracy = verticalAccuracy,
            let course = course,
            let speed = speed,
            let timestamp = timestamp
        {
            return CLLocation(coordinate: getCoordinates(), altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, course: course, speed: speed, timestamp: timestamp)
        } else {
            return CLLocation()
        }
        
    
    }
}
