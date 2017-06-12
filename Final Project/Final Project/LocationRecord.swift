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

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

class LocationRecord {
    let bikeRoute = AEXMLDocument()
    let attributes = ["xmlns": "http://www.topografix.com/GPX/1/1", "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance","xsi:schemaLocation":"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd"]
    var gpx:AEXMLElement?
    var metadata:AEXMLElement?
    init(routeName: String) {
        gpx = bikeRoute.addChild(name: "gpx", attributes: attributes)
        metadata = gpx?.addChild(name: "metadata")
        createMetadata(routeName: routeName)
    }
    
    func createMetadata(routeName:String){
        metadata?.addChild(name: "name")
    }
    
    func addWpt(latitude: CLLocationDegrees, longtitude: CLLocationDegrees, elevation:CLLocationDistance) {
        let wptAttributes = ["lat": "\(latitude)", "lon": "\(longtitude)"]
        let wpt = gpx?.addChild(name: "wpt", attributes: wptAttributes)
        let ele = wpt?.addChild(name: "ele")
        let time = wpt?.addChild(name: "time")
        ele?.value = "\(elevation)"
        let StringFromDate = Date().iso8601
        time?.value = StringFromDate
    }
    
    func printXML() {
        // get the documents folder url
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        // create the destination url for the text file to be saved
        let fileURL = documentDirectory.appendingPathComponent("name.gpx")
        
        let text = bikeRoute.xml
        do {
            // writing to disk
            try text.write(to: fileURL, atomically: false, encoding: .utf8)
            
            // saving was successful. any code posterior code goes here
            // reading from disk
            do {
                let mytext = try String(contentsOf: fileURL)
                print(mytext)   // "some text\n"
            } catch {
                print("error loading contents of:", fileURL, error)
            }
        } catch {
            print("error writing to url:", fileURL, error)
        }
    }
    
    func isFileExist() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent("name.gpx")?.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath!) {
            print("FILE AVAILABLE")
        } else {
            print("FILE NOT AVAILABLE")
        }
    }
}
