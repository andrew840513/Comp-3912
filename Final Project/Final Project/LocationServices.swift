//
//  LocationServices.swift
//  Final Project
//
//  Created by Andrew Chen on 2017-06-09.
//  Copyright © 2017 Andrew Chen. All rights reserved.
//
import UIKit
import CoreLocation
import GoogleMaps

class LocationServices:NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var speed = CLLocationSpeed()
    var distance :CLLocationDistance = 0.0
    var location: CLLocation?
   override init() {
        super.init()
        self.locationManager.delegate = self
    
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
    
    func getDistance() ->CLLocationDistance {
        return distance
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        location = locations.last
        speed = locationManager.location!.speed
        distance = CLLocation().distance(from: location!)
    }
}
