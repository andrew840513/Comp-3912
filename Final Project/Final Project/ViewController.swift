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
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var StartBtn: UIButton!
    
    var speed = CLLocationSpeed()
    var mapsViewController:MapsController?
    var locationManager = CLLocationManager()
    
    var mapViewController: MapsController?
    let mapSegueName = "mapsSegue"
    var statsViewController: StatsController?
    let statsSegueName = "statsSegue"
    
    
    @IBAction func startAction(_ sender: Any) {
        if !(mapViewController?.startMoving)! {
            StartBtn.setTitle("STOP WORKOUT", for: .normal)
            mapViewController?.path = GMSMutablePath()
            mapViewController?.startMoving = true
            statsViewController?.runTimer()
        }else{
            StartBtn.setTitle("START WORKOUT", for: .normal)
            mapViewController?.startMoving = false
            mapViewController?.mapView.clear()
            performSegue(withIdentifier: "ShowResult", sender: self)
            statsViewController?.stopTimer()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let location = locations.last
        speed = locationManager.location!.speed
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

