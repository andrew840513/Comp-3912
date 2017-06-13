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
    let bikeRoute = AEXMLDocument()
    let attributes = ["xmlns": "http://www.topografix.com/GPX/1/1", "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance","xsi:schemaLocation":"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd"]
    let StringFromDate = ISO8601DateFormatter()
    var gpx:AEXMLElement?
    var metadata:AEXMLElement?
    var lastTime:String! = nil
    init(routeName: String) {
        gpx = bikeRoute.addChild(name: "gpx", attributes: attributes)
        metadata = gpx?.addChild(name: "metadata")
        createMetadata(routeName: routeName)
    }
    
    func createMetadata(routeName:String){
        metadata?.addChild(name: "name")
    }
    
    func addWpt(latitude: CLLocationDegrees, longtitude: CLLocationDegrees, elevation:CLLocationDistance) {
        let currentTime =  StringFromDate.string(from: Date())
        if (lastTime == nil || (lastTime != currentTime)){
            let wptAttributes = ["lat": "\(latitude)", "lon": "\(longtitude)"]
            let wpt = gpx?.addChild(name: "wpt", attributes: wptAttributes)
            let ele = wpt?.addChild(name: "ele")
            let time = wpt?.addChild(name: "time")
            ele?.value = "\(elevation)"
            time?.value = currentTime
        }
        lastTime = currentTime
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
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            let mp3Files = directoryContents.filter{ $0.pathExtension == "gpx" }
            print("mp3 urls:",mp3Files)
            let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
            print("mp3 list:", mp3FileNames)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
