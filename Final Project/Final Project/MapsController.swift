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
    let path = GMSMutablePath()
    var didShowMyLocation:Bool = false
    var lastLatitude:Double = 0
    var lastLongitude:Double = 0
    var totalDistent:Double = 0
    var startMoving:Bool = false
    
    override func viewDidLoad() {
        let camera = GMSCameraPosition.camera(withLatitude:123 ,
                                              longitude: 151.2086,
                                              zoom: 14)
        self.mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        view = mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let currentLatitude = location?.coordinate.latitude
        let currentLongitude = location?.coordinate.longitude
        
        if(!didShowMyLocation){
            let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(currentLatitude!), longitude: CLLocationDegrees(currentLongitude!), zoom: 15)
            self.mapView.animate(to: camera)
            didShowMyLocation = true
        }
        print(startMoving)
        if(startMoving){
            func  drawLine() {
                path.addLatitude(CLLocationDegrees(currentLatitude!), longitude: CLLocationDegrees(currentLongitude!))
                let myPath = GMSPolyline(path: path)
                myPath.strokeColor = UIColor.red
                myPath.strokeWidth = 5.0
                myPath.map = mapView
            }
            if(lastLatitude != 0 && lastLongitude != 0)
            {
                let latitude = lastLatitude - CLLocationDegrees(currentLatitude!)
                let longitude = lastLongitude - CLLocationDegrees(currentLongitude!)
                
                totalDistent += latitude+longitude
                if totalDistent >= 0.0005{
                   drawLine()
                }
            }else{
                lastLatitude = currentLatitude!
                lastLongitude = currentLongitude!
                drawLine()
            }
        }
    }
}
