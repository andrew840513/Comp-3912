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
            StartBtn.setTitle(WORKOUT_STOP, for: .normal)
            mapViewController?.path = GMSMutablePath()
            startMoving = true
            mapViewController?.startDrawing()
            statsViewController?.runTimer()
            statsViewController?.runDistance()
        }else{
            locationManager.stop()
            StartBtn.setTitle(WORKOUT_START, for: .normal)
            mapViewController?.stopDrawing()
            startMoving = false
            mapViewController?.mapView.clear()
            statsViewController?.stopTimer()
            statsViewController?.stopDistance()
            performSegue(withIdentifier: RESULT_SEGUE_NAME, sender: self)
        }
        
    }
    @IBAction func backToMyLocation(_ sender: Any) {
        mapViewController?.moveToCurrentLocation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == mapSegueName {
            mapViewController = segue.destination as? MapsController
        }
        if(segue.identifier == statsSegueName) {
            statsViewController = segue.destination as? StatsController
        }
    }
}

