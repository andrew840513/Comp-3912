//
//  StatsController.swift
//  Final Project
//
//  Created by Andrew Chen on 2017-06-09.
//  Copyright © 2017 Andrew Chen. All rights reserved.
//

import UIKit

class StatsController: UIViewController {

    var timer = Timer()
    var locationManager: LocationServices?
    var seconds = 0
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    let locationObserver = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenWidth = self.view.frame.size.width
        
        switch screenWidth {
        case 320,375: // iPhone 4 and iPhone 5
            distanceLabel.font = UIFont(name: "Avenir-Book", size: 42)
            durationLabel.font = UIFont(name: "Avenir-Book", size: 42)
        case 414, 768: // iPhone 6 Plus
            distanceLabel.font = UIFont(name: "Avenir-Book", size: 52)
            durationLabel.font = UIFont(name: "Avenir-Book", size: 52)
        default: // iPad Pro
            distanceLabel.font = UIFont(name: "Avenir-Book", size: 42)
            durationLabel.font = UIFont(name: "Avenir-Book", size: 42)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //TIME
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(StatsController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
        seconds = 0
        durationLabel.text = Util().timeString(time: TimeInterval(seconds))
    }
    
    func updateTimer() {
        seconds += 1
        durationLabel.text = Util().timeString(time: TimeInterval(seconds))
    }
    //DISTANCE
    
    func runDistance() {
        locationManager?.start()
        locationObserver.addObserver(forName: REFRESH_VALUE, object: nil, queue: nil){
            notication in
            self.distanceLabel.text = self.locationManager?.getDistance()
        }
    }
    
    func stopDistance() {
        locationManager?.stop()
        locationObserver.removeObserver(self, name: REFRESH_VALUE, object: nil)
        self.distanceLabel.text = "0.0"
        self.locationManager?.distance = 0.0
    }
}
