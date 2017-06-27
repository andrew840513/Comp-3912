//
//  LocationRecord.swift
//  Final Project
//
//  Created by Andrew Chen on 2017-06-11.
//  Copyright © 2017 Andrew Chen. All rights reserved.
//

import Foundation
import AEXML
import CoreLocation

class LocationRecord {
    static var bikeRoute = AEXMLDocument()
    static let attributes = ["xmlns": "http://www.topografix.com/GPX/1/1", "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance","xsi:schemaLocation":"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd"]
    let StringFromDate = ISO8601DateFormatter()
    static var gpx:AEXMLElement?
    static var metadata:AEXMLElement?
    
    init() {
        LocationRecord.reset()
    }
    static func reset() {
        LocationRecord.bikeRoute = AEXMLDocument()
        LocationRecord.gpx = LocationRecord.bikeRoute.addChild(name: "gpx", attributes: LocationRecord.attributes)
        LocationRecord.metadata = LocationRecord.gpx?.addChild(name: "metadata")
    }
    func createMetadata(routeName:String){
        LocationRecord.metadata?.addChild(name: "name")
    }
    
    func addWpt(latitude: CLLocationDegrees, longtitude: CLLocationDegrees, elevation:CLLocationDistance) {
        let currentTime =  StringFromDate.string(from: Date())
        let wptAttributes = ["lat": "\(latitude)", "lon": "\(longtitude)"]
        let wpt = LocationRecord.gpx?.addChild(name: "wpt", attributes: wptAttributes)
        let ele = wpt?.addChild(name: "ele")
        let time = wpt?.addChild(name: "time")
        ele?.value = "\(elevation)"
        time?.value = currentTime
    }
    
    static func saveFile(name:String, second:Int, distance:Double) {
        // get the documents folder url
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let currentTime = dateFormatter.string(from: Date())
        
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        // create the destination url for the text file to be saved
        let fileName = "\(name)_\(currentTime).gpx"
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        let text = LocationRecord.bikeRoute.xml
        do {
            // writing to disk
            try text.write(to: fileURL, atomically: false, encoding: .utf8)
            LocationRecord.saveToCoreData(fileName: fileName, name: name,second:  second,distance: distance, date: Date())
            LocationRecord.reset()
        } catch {
            print("error writing to url:", fileURL, error)
        }
    }
    static func saveToCoreData(fileName:String, name:String, second:Int, distance:Double, date:Date) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let route = Route(context: context)
        
        route.fileName = fileName
        route.name = name
        route.second = Int64(second)
        route.distance = distance
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        let time = dateFormatter.string(from: date)
        route.date = time
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    static func deleteFile(fileName:String) {
        let fileManager = FileManager()
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(fileName)
        print("\(documentDirectory)")
        do{
            try fileManager.removeItem(at: documentDirectory)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    static func loadFile()->AEXMLDocument {
        do {
            let xml = AEXMLDocument(root: LocationRecord.bikeRoute.root, options: AEXMLOptions())
            print(xml.xml)
            return xml
        }
    }
    
    static func loadFile(fileName:String)->AEXMLDocument {
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(fileName)
        print(documentDirectory)
        let data = try? Data(contentsOf: documentDirectory)
        do {
            let xml = try? AEXMLDocument(xml: data!, options: AEXMLOptions())
            return xml!
        }
    }
    static func printXML() {
        print(LocationRecord.bikeRoute.xml)
    }
}
