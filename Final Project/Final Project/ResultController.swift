//
//  ResultController.swift
//  Final Project
//
//  Created by Andrew Chen on 2017-06-06.
//  Copyright © 2017 Andrew Chen. All rights reserved.
//

import UIKit
import CoreLocation
import AEXML
import GoogleMaps

class ResultController: UIViewController {

    @IBOutlet weak var fileName: UITextField!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var averageSpeedLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    
    var resultMap:ResultMapViewController?
    static var duration:String?
    static var distance:Double?
    static var second:Int?
    static var xml:AEXMLDocument?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ResultController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        for att in (ResultController.xml?.root["wpt"].all!)!{
            let lat:CLLocationDegrees = Double(att.attributes["lat"]!)!
            let lon:CLLocationDegrees = Double(att.attributes["lon"]!)!
            resultMap?.prepareLine(latitude: lat, longitude: lon)
        }
        resultMap?.drawLine()
        durationLbl.text = ResultController.duration
        distanceLbl.text = "\(ResultController.distance ?? 0.00) km"
        averageSpeedLbl.text = Util().calculateAvegeSpeed(distance: ResultController.distance!, second: Double(ResultController.second!))
        
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        ResultController.duration = nil
        ResultController.distance = nil
        durationLbl.text = "00:00"
        averageSpeedLbl.text = "0.00 km/h"
        distanceLbl.text = "0.00 km"
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveFile(_ sender: Any) {
        LocationRecord.saveFile(name: fileName.text!, second: ResultController.second!,distance: ResultController.distance!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func discard(_ sender: Any) {
        let message = "Do you want to discard your workout? This cannot be undone."
        let alert = UIAlertController(title: "Discard your workout", message: message, preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive, handler: {
            (action) -> Void in
            LocationRecord.reset()
            self.resultMap?.reset()
            self.dismiss(animated: true, completion: nil)
        })
        let no = UIAlertAction(title: "No", style: .cancel, handler: {(action) -> Void in})
        alert.addAction(yes)
        alert.addAction(no)
        present(alert, animated: true, completion: nil)
        
        

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == resultMapSegueName {
            resultMap =  segue.destination as? ResultMapViewController
        }
    }
}
