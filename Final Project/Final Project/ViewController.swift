//
//  ViewController.swift
//  Final Project
//
//  Created by Andrew Chen on 2017-06-06.
//  Copyright © 2017 Andrew Chen. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController , CLLocationManagerDelegate{
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var StartBtn: UIButton!
    @IBOutlet weak var speedLable: UILabel!
    
    var speed = CLLocationSpeed()
    var mapsViewController:MapsController?
    var locationManager = CLLocationManager()
    
    var containerViewController: MapsController?
    let containerSegueName = "mapsSegue"
    @IBAction func startAction(_ sender: Any) {
        containerViewController?.startMoving = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        StartBtn.backgroundColor = UIColor.green
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
        speedLable.text = String(format: "%.0fkm/h", speed*3.6)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == containerSegueName {
            containerViewController = segue.destination as? MapsController
        }
    }
}

