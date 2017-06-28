//
//  util.swift
//  Final Project
//
//  Created by Andrew Chen on 2017-06-26.
//  Copyright © 2017 Andrew Chen. All rights reserved.
//

import Foundation

class Util{
    
    func calculateAvegeSpeed(distance:Double, second:Double) ->String {
        let averageSpeed = distance / (second/60)
        print(averageSpeed)
        if(averageSpeed < 0.01) {
            return String(format: "%.2f m/h", averageSpeed*1000)
        }else{
            return String(format: "%.2f km/h", averageSpeed)
        }
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
    
    func timeStringForStore(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func durationToSecond(duration:String) {
        
    }
    
    func isFileExist(fileExtension:String) {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            let gpxFiles = directoryContents.filter{ $0.pathExtension == fileExtension }
            print("gpx urls:",gpxFiles)
            let gpxFileNames = gpxFiles.map{ $0.deletingPathExtension().lastPathComponent }
            print("gpx list:", gpxFileNames)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
