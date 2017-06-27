//
//  CheckGPSViewController.swift
//  Final Project
//
//  Created by Andrew Chen on 2017-06-27.
//  Copyright © 2017 Andrew Chen. All rights reserved.
//

import UIKit
import CoreLocation
class CheckGPSViewController: UIViewController {
    var locationManager = CLLocationManager()
    var timer = Timer()
    let locationObserver = NotificationCenter.default
    override func viewDidLoad() {
        super.viewDidLoad()
        locationObserver.addObserver(forName: NSNotification.Name(rawValue: "ListenForGps"), object: nil, queue: nil){
            notication in
            print("notified")
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
                print("I changed")
                self.changeController()
                self.locationObserver.removeObserver(self, name: NSNotification.Name(rawValue: "ListenForGps"), object: nil)
                self.timer.invalidate()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        startlisten()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enableGPS(_ sender: Any) {
        let alertController = UIAlertController(title: NSLocalizedString("We Need your location", comment: ""), message: NSLocalizedString("In order to track your bike activity you need to turn on location.", comment: ""), preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        var settingsAction:UIAlertAction
        
        if CLLocationManager.locationServicesEnabled(){
             settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            }
        }else{
           settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
                UIApplication.shared.open(URL(string: "App-Prefs:root=Privacy&path=LOCATION")!, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)

    }
    func changeController() {
        self.dismiss(animated: true, completion: nil)
    }
    func startlisten() {
        if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(CheckGPSViewController.isEnable)), userInfo: nil, repeats: true)
        }
    }
    func isEnable() {
        print("notify")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ListenForGps"), object: nil)
    }

}
