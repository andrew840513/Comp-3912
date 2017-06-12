//
//  MapsController.swift
//  Final Project
//
//  Created by Andrew Chen on 2017-06-06.
//  Copyright © 2017 Andrew Chen. All rights reserved.
//

import UIKit
import GoogleMaps

class MapsController: UIViewController, GMSMapViewDelegate {
    
    var mapView:GMSMapView = GMSMapView()
    var path:GMSMutablePath?
    var didShowMyLocation:Bool = false
    var lastLatitude:Double = 0
    var lastLongitude:Double = 0
    var currentLatitude:CLLocationDegrees!
    var currentLongitude:CLLocationDegrees!
    var totalDistent:Double = 0
    var startMoving:Bool = false
    var myPath:GMSPolyline?
    var locationManager: LocationServices?
    let record = LocationRecord(routeName: "Test")
    
    
    let locationObserver = NotificationCenter.default
    override func viewDidLoad() {
        let camera = GMSCameraPosition.camera(withLatitude:123 ,
                                              longitude: 151.2086,
                                              zoom: 14)
        self.mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        self.mapView.isMyLocationEnabled = true
        self.mapView.delegate = self
        
        view = mapView
    }
    var camera: GMSCameraPosition?
    
    func moveToCurrentLocation(){
        mapView.animate(toLocation: (mapView.myLocation?.coordinate)!)
    }
    
    func  drawLine() {
        self.path?.add((self.mapView.myLocation?.coordinate)!)
        self.myPath = GMSPolyline(path: self.path)
        self.myPath?.strokeColor = UIColor.red
        self.myPath?.strokeWidth = 5.0
        self.myPath?.map = self.mapView
    }
    
    func startDrawing() {
        locationManager?.start()
        record.isFileExist()
        locationObserver.addObserver(forName: REFRESH_VALUE, object: nil, queue: nil){
            notication in
            self.currentLatitude = self.mapView.myLocation?.coordinate.latitude
            self.currentLongitude = self.mapView.myLocation?.coordinate.longitude
            self.record.addWpt(latitude: self.currentLatitude, longtitude: self.currentLongitude, elevation: 1.0)
            if(!self.didShowMyLocation){
                self.camera = GMSCameraPosition.camera(withLatitude: self.currentLatitude, longitude: self.currentLongitude, zoom: 19)
                self.mapView.animate(to: self.camera!)
                self.moveToCurrentLocation()
                self.didShowMyLocation = true
            }
            
            if(self.lastLatitude != 0 && self.lastLongitude != 0)
            {
                let latitude = abs(self.lastLatitude - self.currentLatitude)
                let longitude = abs(self.lastLongitude - self.currentLongitude)
                
                self.totalDistent += latitude+longitude
                if self.totalDistent >= 0.00005{
                    self.drawLine()
                }
            }else{
                self.lastLatitude = self.currentLatitude
                self.lastLongitude = self.currentLongitude
                self.drawLine()
            }
        }
    }
    
    func stopDrawing() {
        locationManager?.stop()
        locationObserver.removeObserver(self, name: REFRESH_VALUE, object: nil)
        record.printXML()
        record.isFileExist()
    }
}
