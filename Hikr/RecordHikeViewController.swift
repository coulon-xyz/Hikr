//
//  RecordHikeViewController.swift
//  Hikr
//
//  Created by Julien Coulon on 08/12/2016.
//  Copyright © 2016 CoulonXYZ. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import CoreData

class RecordHikeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var displayBlock1: UILabel!
    @IBOutlet weak var displayBlock2: UILabel!
    @IBOutlet weak var displayBlock3: UILabel!
    
    var locationManagerIsReady = false
    var locationsDetails : [LocationDetails] = []
    var distance : Double = 0
    let startTime : Date = Date()
    
    var previousPosition = CLLocationCoordinate2D()
    
    // temporary
    let user = "test_user"
    let id = String(NSDate().timeIntervalSince1970)
    
    // Setting appDelegate for coreData
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOADING VIEW")

        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 0)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 1)!
        mapView.showsBuildings = false
        mapView.isRotateEnabled = false
        
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
    
        //getPositionDetails()
    }


    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
   

        guard let location = locations.last else {
            return
        }
        
        // check if locationManager is ready
        // First run may find ol CLLocation in memory, so making sure to start logging on second run
        if locationManagerIsReady == true && location.timestamp.timeIntervalSinceNow > -1  {
        

            // create a new Position Object called currentPosition, store it in CoreData and append to
            let currentLocation = LocationDetails()
            currentLocation.initFromLocation(hikeId: id, user: user, location: location)
            locationsDetails.append(currentLocation)
            // saving in core data
            if currentLocation.storeInCoreData() {
                print("stored in core data")
            } else {
                print("error saving in core data")
            }
            
            if locationsDetails.count > 3 {
                // creating a previousPosition as it seems to be needed (and straightforward) to workaround the polyline bug
                if let lat = locationsDetails[(locationsDetails.count - 2)].latitude, let lon = locationsDetails[(locationsDetails.count - 2)].longitude {
                    previousPosition = CLLocationCoordinate2DMake(lat,lon)
                    addPolylineToView(points: [previousPosition, location.coordinate])
                    updateUI()
                }
            }
        } else {
            locationManagerIsReady = true
        }

    }

    // MARK: - POLYLINE
    
    // receive an array of coordinates, and draw a line between the points.
    // It seems that there is a bug in this XCODE version (8.2 beta).  I could not make it work using positions array...
    // Not sure if it works if the array.count is > 2
    func addPolylineToView(points: [CLLocationCoordinate2D]) {
        if locationsDetails.count > 3 {
        let polyline = MKPolyline(coordinates: points, count: points.count)
            DispatchQueue.main.async {
                self.mapView.add(polyline)
            }
        }
    }
    
    // Method to render the polyline
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer! {
        
        if overlay is MKPolyline {
                    let pr = MKPolylineRenderer(overlay: overlay)
                    pr.strokeColor = UIColor.blue
                    pr.lineWidth = 5
                    return pr
                }
        return nil
    }
    
    // MARK: - HELPERS TO DISPLAY ON THE UI
    
    func updateUI() {
        // distance var is a class level var
        updateDistanceVar()
        let duration: Double = updateDurationVar()
        let avgSpeed = calculateAvgSpeed(distance: distance, duration: duration)
        
       // print("actual speed:", positions.last?.speed)
        
        updateDisplay(duration: duration, avgSpeed: avgSpeed)
    }
    
    func updateDisplay(duration: Double, avgSpeed: CLLocationSpeed) {
        displayBlock1.text = "Started at: \(startTime)"
        
        displayBlock2.text = "Avg Speed: \(formatSpeed(speed: avgSpeed, unit: "kms")) \n"
        if let actualSpeed = locationsDetails.last?.speed {
            displayBlock2.text =  displayBlock2.text! + "Actual Speed: \(formatSpeed(speed: actualSpeed, unit: "kms")) \n"
        }
        
        displayBlock3.text = "Distance : \(formatDistance(distance: distance))\nDuration : \(formatDuration(duration: duration))"
    }
    
    
    // DISTANCE
    // update variable distance
    func updateDistanceVar() {
         if locationsDetails.count > 2 {
            let previousCoord = locationsDetails[locationsDetails.count - 2].getCLLocation()
            let currentCoord = locationsDetails[locationsDetails.count - 1].getCLLocation()
            self.distance = self.distance + previousCoord.distance(from: currentCoord)
        }
    }

    // format distance using formatter. (CLLocationDistance is a typealias of Double)
    func formatDistance(distance : CLLocationDistance) -> String {
        let distanceFormatter = MKDistanceFormatter()
        distanceFormatter.units = .metric
        distanceFormatter.unitStyle = .full
        return distanceFormatter.string(fromDistance: distance)
    }
    
    // DURATION
    // update duration var
    func updateDurationVar() -> Double {
        return Date().timeIntervalSince(startTime)
    }
    
    // format duration
    func formatDuration(duration: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]
        return formatter.string(from: duration)!
    }
    
    // AVERAGE SPEED
    
    // get distance in meters and duration in s and return Speed in m/s
    func calculateAvgSpeed(distance: CLLocationDistance, duration: Double) -> CLLocationSpeed {
        return distance / duration
    }
    
    func formatSpeed(speed: CLLocationSpeed, unit: String) -> String {
        // disregard unit for the moment, only return km/s
        let formattedSpeed = String(format: "%.0f km/h", speed * 3.6)
        return formattedSpeed
    }
    
    
    
    // MARK: - CORE DATA FUNCTIONS
    
    
    // Return context
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
    }
    
    
    // This action will stop recording the Hike
    // and will dismiss the view
    @IBAction func stopRecordingHike(_ sender: Any) {
        
        // stop recording in core data
        
        dismiss(animated: true, completion: nil)
    }


}
