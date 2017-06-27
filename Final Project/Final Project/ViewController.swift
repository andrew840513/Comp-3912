//
//  ViewController.swift
//  Final Project
//
//  Created by Andrew Chen on 2017-06-06.
//  Copyright © 2017 Andrew Chen. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class ViewController: UIViewController , CLLocationManagerDelegate{
    let locationManager = LocationServices()
    
    var mapViewController: MapsController?
    var statsViewController: StatsController?
    var startMoving:Bool = false
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var StartBtn: UIButton!
    
    
    @IBAction func startAction(_ sender: Any) {        
        statsViewController?.locationManager = locationManager
        if (!startMoving) {
            self.tabBarController?.tabBar.isHidden = true
            StartBtn.setTitle(WORKOUT_STOP, for: .normal)
            mapViewController?.path = GMSMutablePath()
            startMoving = true
            mapViewController?.startDrawing()
            statsViewController?.runTimer()
            statsViewController?.runDistance()
        }else{
            locationManager.stop()
            ResultController.duration =  Util().timeStringForStore(time: TimeInterval((statsViewController?.seconds)!))
            ResultController.distance = Double((statsViewController?.distanceLabel.text)!)
            ResultController.second = statsViewController?.seconds
            ResultController.xml = LocationRecord.loadFile()
            statsViewController?.stopTimer()
            statsViewController?.stopDistance()
            mapViewController?.stopDrawing()
            startMoving = false
            mapViewController?.mapView.clear()
            performSegue(withIdentifier: RESULT_SEGUE_NAME, sender: self)
        }
        
    }
    @IBAction func backToMyLocation(_ sender: Any) {
        mapViewController?.moveToCurrentLocation()
        mapViewController?.dragging = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.locationManager.requestWhenInUseAuthorization()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        StartBtn.setTitle(WORKOUT_START, for: .normal)
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse){
            mapViewController?.moveToCurrentLocation()
        }else{
            performSegue(withIdentifier: "checkGPSSegue", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == mapSegueName {
            print("have data1")
            mapViewController = segue.destination as? MapsController
        }
        if segue.identifier == statsSegueName {
            print("have data2")
            statsViewController = segue.destination as? StatsController
        }
    }
}

