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
    var isBiking:Bool = false
   override init() {
        super.init()
        self.locationManager.delegate = self
        startLocation = nil
    }
    
    func start(){
        locationManager.startUpdatingLocation()
    }
    
    func stop(){
        locationManager.stopUpdatingHeading()
    }
    
    func getSpeed() ->Double {
        return speed
    }
    
    func getDistance() ->String {
        return String(format: "%.2f", distance/1000)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if(isBiking){
            let latestLocation: AnyObject = locations[locations.count - 1]
            speed = locationManager.location!.speed
            if startLocation == nil {
                startLocation = latestLocation as! CLLocation
            }
            
            let distanceBetween: CLLocationDistance =
                latestLocation.distance(from: startLocation)
            
            distance += distanceBetween
            startLocation = latestLocation as! CLLocation
            NotificationCenter.default.post(name: REFRESH_VALUE, object: nil)
        }
    }
}
