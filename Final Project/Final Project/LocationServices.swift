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
    
    override init() {
        self.locationManager.delegate = self
    }
    
    func start(){
        locationManager.startUpdatingLocation()
    }
    
    func stop(){
        locationManager.stopUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        <#code#>
    }
}
