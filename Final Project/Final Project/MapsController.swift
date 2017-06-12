//
//  MapsController.swift
//  Final Project
//
//  Created by Andrew Chen on 2017-06-06.
//  Copyright © 2017 Andrew Chen. All rights reserved.
//

import UIKit
import GoogleMaps

class MapsController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var mapView:GMSMapView = GMSMapView()
    var locationManager = CLLocationManager()
    var path:GMSMutablePath?
    var didShowMyLocation:Bool = false
    var lastLatitude:Double = 0
    var lastLongitude:Double = 0
    var currentLatitude:CLLocationDegrees!
    var currentLongitude:CLLocationDegrees!
    var totalDistent:Double = 0
    var startMoving:Bool = false
    var myPath:GMSPolyline?
    
    override func viewDidLoad() {
        let camera = GMSCameraPosition.camera(withLatitude:123 ,
                                              longitude: 151.2086,
                                              zoom: 14)
        self.mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        self.mapView.isMyLocationEnabled = true
        self.mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        view = mapView
    }
    var camera: GMSCameraPosition?
    
    func moveToCurrentLocation(){
        mapView.animate(toLocation: (mapView.myLocation?.coordinate)!)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLatitude = mapView.myLocation?.coordinate.latitude
        currentLongitude = mapView.myLocation?.coordinate.longitude
        if(!didShowMyLocation){
            camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 19)
            self.mapView.animate(to: camera!)
            moveToCurrentLocation()
            didShowMyLocation = true
        }
        if(startMoving){
            func  drawLine() {
                path?.add((mapView.myLocation?.coordinate)!)
                myPath = GMSPolyline(path: path)
                myPath?.strokeColor = UIColor.red
                myPath?.strokeWidth = 5.0
                myPath?.map = mapView
            }
            if(lastLatitude != 0 && lastLongitude != 0)
            {
                let latitude = abs(lastLatitude - currentLatitude)
                let longitude = abs(lastLongitude - currentLongitude)
                
                totalDistent += latitude+longitude
                if totalDistent >= 0.00005{
                   drawLine()
                }
            }else{
                lastLatitude = currentLatitude
                lastLongitude = currentLongitude
                drawLine()
            }
        }
    }
}
