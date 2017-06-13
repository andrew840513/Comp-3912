//
//  LocationServices.swift
//  Final Project
//
//  Created by Andrew Chen on 2017-06-09.
//  Copyright © 2017 Andrew Chen. All rights reserved.
//
import CoreLocation
import GoogleMaps

class LocationServices:NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var speed = CLLocationSpeed()
    var distance :CLLocationDistance = 0.0
    var startLocation: CLLocation!
    var latitude: CLLocationDegrees!
    var longtitude: CLLocationDegrees!
    
   override init() {
        super.init()
        self.locationManager.delegate = self
        startLocation = nil
    }
    
    func start(){
        locationManager.startUpdatingLocation()
    }
    
    func stop(){
        locationManager.stopUpdatingLocation()
    }
    
    func getSpeed() ->Double {
        return speed
    }
    
    func getDistance() ->String {
        return String(format: "%.2f", distance/1000)
    }
    
    func getLatitude()->CLLocationDegrees {
        return latitude
    }
    
    func getLongtitude() ->CLLocationDegrees {
        return longtitude
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
            let latestLocation: AnyObject = locations[locations.count - 1]
            latitude = locations.last?.coordinate.latitude
            longtitude = locations.last?.coordinate.longitude
            speed = locationManager.location!.speed
            if startLocation == nil {
                startLocation = latestLocation as! CLLocation
            }
            let distanceBetween: CLLocationDistance = latestLocation.distance(from: startLocation)
            distance += distanceBetween
            startLocation = latestLocation as! CLLocation
            NotificationCenter.default.post(name: REFRESH_VALUE, object: nil)
    }
}
