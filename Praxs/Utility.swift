//
//  Utility.swift
//  prouks
//
//  Created by Arnaud on 2017-05-07.
//  Copyright © 2017 arnaud. All rights reserved.
//

import Foundation

enum utilityError: Error {
    case brokenPath(msg:String)
}
//Convenience object to fetch paths & query data

struct Utility{
    var storedTask: Dictionary<String, Any>{                //testing json for storing task
        get{
            do{
            return try self.getData()!
            }catch{
                print(error.localizedDescription)
            }
            return [:]
        }
    }
    func getPathToUserDoc() throws ->(str:String,url:NSURL) {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                          .userDomainMask,
                                                          true)[0] as String
        let url = NSURL(fileURLWithPath: docPath.appending("data.json"))
        do{
            if docPath.isEmpty != true {
                let str = docPath
                return (str,url)
                }
            else{throw utilityError.brokenPath(msg: "cant find app document directory")}
        }catch utilityError.brokenPath(let msg){
            print("Error: \(msg)")
        }
        return ("",url)
    }
    func getData() throws -> Dictionary<String, Any>?{
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: (try getPathToUserDoc().str)) {
            let data = try Data(contentsOf: try getPathToUserDoc().url as URL)
            let dict = try JSONSerialization.jsonObject(with: data,
                                                        options: [])
                                                        as? Dictionary<String, Any>
            if let dataDict = dict{
                return dataDict
            }
        }
        return nil
    }
//    func write(inDataDict:Dictionary<String, Any>) throws {
//        if let localData = try self.getData() {
//        }
//        else{
//        }        
//    }
    func buildJSON(from:[String]) throws {
        if JSONSerialization.isValidJSONObject(from) {
            try JSONSerialization.data(withJSONObject:
                from, options: [])
        }
    }    
}
