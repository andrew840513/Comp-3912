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
    
    var resultMap:ResultMapViewController?
    static var duration:String?
    static var distance:Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ResultController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        let xml = AEXMLDocument(root: LocationRecord.bikeRoute.root, options: AEXMLOptions())
        for att in xml.root["wpt"].all!{
            let lat:CLLocationDegrees = Double(att.attributes["lat"]!)!
            let lon:CLLocationDegrees = Double(att.attributes["lon"]!)!
            resultMap?.prepareLine(latitude: lat, longitude: lon)
        }
        resultMap?.drawLine()
        print(ResultController.duration ?? "0.0")
        print(ResultController.distance ?? "nothing")
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        ResultController.duration = nil
        ResultController.distance = nil
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
        let resultData = LocationRecord()
        resultData.createMetadata(routeName: fileName.text!)
        resultData.saveFile(name: fileName.text!, duration: ResultController.duration!,distance: ResultController.distance!)
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
