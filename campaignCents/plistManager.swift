//
//  plistManager.swift
//  campaignCents
//
//  Created by Jasen Lew on 8/22/14.
//  Copyright (c) 2014 Jasen Lew. All rights reserved.
//

import Foundation

let SharedFileManager = FileManager()

class FileManager: NSObject {
    
    let fileManager = NSFileManager.defaultManager()
    
    // Existing plist file
    let kochPoliticiansPlistFileName = "kochPoliticians.plist"
    // New plist file that will be created, if not in existence
    let coordsPlistFileName = "coords.plist"
    
    let kochPoliticiansPlistPath:String?
    let coordsPlistPath:String?
    
    class var manager: FileManager {
        return SharedFileManager
    }
    
    override init () {
        
        let directorys : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        
        if let directories = directorys? {
            let directory = directories[0]; // documents directory
            
            self.kochPoliticiansPlistPath = directory.stringByAppendingPathComponent(self.kochPoliticiansPlistFileName)
            self.coordsPlistPath = directory.stringByAppendingPathComponent(self.coordsPlistFileName)
            
        }
        else {
            println("directory is empty")
        }
    }
    
    func saveToCache(newData:NSMutableArray) {
        newData.writeToFile(kochPoliticiansPlistPath, atomically: false)
        
    }
    
    func readFromCache() -> NSMutableArray {
        var resultsArray:NSMutableArray? = NSMutableArray(contentsOfFile: kochPoliticiansPlistPath)
        if let res = resultsArray? {
            return res
        } else {
            var res:NSMutableArray = []
            return res
        }
    }
    
    func saveToDestinationsList(newData:NSMutableArray ) {
        newData.writeToFile(self.coordsPlistPath, atomically: false)
        
    }
    
    func readFromDestinationsList() -> NSMutableArray {
        var resultsArray:NSMutableArray? = NSMutableArray(contentsOfFile: self.coordsPlistPath)
        if let res = resultsArray? {
            return res
        } else {
            var res:NSMutableArray = []
            return res
        }
        
    }
    
    
}