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
    var totalDistent:Double = 0
    var myPath:GMSPolyline?
    var locationManager: LocationServices?
    let record = LocationRecord()
    var dragging:Bool = false
    var moveCamera = false
    let locationObserver = NotificationCenter.default
    override func viewDidLoad() {
    
    }
    
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude:49.1232 ,
                                              longitude: 151.2086,
                                              zoom: 19)
        self.mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        self.mapView.isMyLocationEnabled = true
        self.mapView.delegate = self
        view = mapView
    }
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        if(!moveCamera) {
            moveToCurrentLocation()
            moveCamera = true
        }
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if(gesture){
            print("I moved camara")
            dragging = true
        }
    }
    
    func moveToCurrentLocation(){
        if(mapView.myLocation != nil){
            mapView.animate(toLocation: (mapView.myLocation?.coordinate)!)
        }
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
        locationObserver.addObserver(forName: REFRESH_VALUE, object: nil, queue: nil){
            notication in
            let currentLatitude = self.mapView.myLocation?.coordinate.latitude
            let currentLongitude = self.mapView.myLocation?.coordinate.longitude
            self.record.addWpt(latitude: currentLatitude!, longtitude: currentLongitude!, elevation: 1.0)
            if(!self.didShowMyLocation){
                let camera = GMSCameraPosition.camera(withLatitude: currentLatitude!, longitude: currentLongitude!, zoom: 19)
                self.mapView.animate(to: camera)
                self.moveToCurrentLocation()
                self.didShowMyLocation = true
            }
            
            if(self.lastLatitude != 0 && self.lastLongitude != 0)
            {
                let latitude = abs(self.lastLatitude - currentLatitude!)
                let longitude = abs(self.lastLongitude - currentLongitude!)
                
                self.totalDistent += latitude+longitude
                if self.totalDistent >= 0.00005{
                    self.drawLine()
                }
            }else{
                self.lastLatitude = currentLatitude!
                self.lastLongitude = currentLongitude!
                self.drawLine()
            }
            if(!self.dragging){
               self.moveToCurrentLocation()
            }
        }
    }
    
    func stopDrawing() {
        locationManager?.stop()
        locationObserver.removeObserver(self, name: REFRESH_VALUE, object: nil)
    }
}
