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
        durationLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    func updateTimer() {
        seconds += 1
        durationLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        if(hours != 0){
            return String(format:"%02i:%02i", hours, minutes)
        }else{
            return String(format:"%02i:%02i", minutes, seconds)
        }
    }
    
    //DISTANCE
    
    func runDistance() {
        locationManager?.isBiking = true
        locationObserver.addObserver(forName: REFRESH_VALUE, object: nil, queue: nil){
            notication in
            self.distanceLabel.text = self.locationManager?.getDistance()
        }
    }
    
    func stopDistance() {
        locationManager?.isBiking = false
        self.distanceLabel.text = "0.0"
        self.locationManager?.distance = 0.0
    }
}
