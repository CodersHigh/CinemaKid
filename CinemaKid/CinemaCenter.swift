//
//  CinemaCenter.swift
//  CinemaKid
//
//  Created by Lingostar on 2015. 10. 12..
//  Copyright © 2015년 CodersHigh. All rights reserved.
//

import Foundation

typealias BlockUpdateUI = () -> Void

class CinemaCenter : NSObject, NSURLSessionDataDelegate {
    var result:[AnyObject] = []
    
    func requestToServer(updateFunction:BlockUpdateUI)  {
        guard let listURL = NSURL(string: "http://125.209.197.227/cinemakid/movie/list/") else {
            return
        }
        let request = NSURLRequest(URL: listURL)
        
        let jsonSession = NSURLSession.sharedSession()
        let jsonTask = jsonSession.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            do {
                let infoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [String:AnyObject]
                self.result = infoDict["data"] as! [AnyObject]
                updateFunction()
            } catch {
                print("JSON Parsing Error")
            }
        })
        jsonTask.resume()

    }
}