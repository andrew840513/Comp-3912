//
//  ResultMapViewController.swift
//  Final Project
//
//  Created by Andrew Chen on 2017-06-12.
//  Copyright © 2017 Andrew Chen. All rights reserved.
//

import UIKit
import GoogleMaps

class ResultMapViewController: UIViewController {
    var mapView:GMSMapView?
    var myPath:GMSPolyline?
    var path:GMSMutablePath?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 0,
                                              longitude: -165,
                                              zoom: 2)
        mapView = GMSMapView()
        mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        
        path = GMSMutablePath()
        view = mapView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareLine(latitude:CLLocationDegrees, longitude: CLLocationDegrees){
        path?.addLatitude(latitude, longitude: longitude)
        
    }
    
    func drawLine() {
        let myPath = GMSPolyline(path: path)
        myPath.strokeColor = .blue
        myPath.strokeWidth = 5.0
        myPath.map = mapView
        let bounds = GMSCoordinateBounds(path: path!)
        mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
    }
    
    func reset() {
        path = GMSMutablePath()
        mapView?.clear()
    }
}
