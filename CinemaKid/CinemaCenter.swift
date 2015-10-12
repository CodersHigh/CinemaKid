//
//  CinemaCenter.swift
//  CinemaKid
//
//  Created by Lingostar on 2015. 10. 12..
//  Copyright © 2015년 CodersHigh. All rights reserved.
//

import Foundation

typealias BlockUpdateUI = () -> Void

class CinemaCenter : NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    var result:[AnyObject] = []
    let dataCache:NSMutableData = NSMutableData()
    let sessionQueue:NSOperationQueue = NSOperationQueue()
    var updateUI:BlockUpdateUI? = nil
    
    func requestToServer(updateFunction:BlockUpdateUI)  {
        updateUI = updateFunction
        //Swift 2.0
        guard let listURL = NSURL(string: "http://125.209.197.227/cinemakid/movie/list/") else {
            return
        }
        //여기에 모든 코드
        let request = NSURLRequest(URL: listURL)
        NSURLConnection(request: request, delegate: self)
        
        //Swift 1.2
        if let listURL = NSURL(string: "http://125.209.197.227/cinemakid/movie/list/") {
            //이 안에 모든 코드
        }
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        dataCache.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        //JSON Parsing
        
        //Swift 1.2 : error 변수에 nil 넣어 호출
        do {
            let infoDict = try NSJSONSerialization.JSONObjectWithData(dataCache, options: NSJSONReadingOptions.AllowFragments) as! [String:AnyObject]
            result = infoDict["data"] as! [AnyObject]
        } catch {
            print("JSON Parsing Error")
        }
        
        updateUI?()
    }
    
}