//
//  ServerConnection.swift
//  Capgemini
//
//  Created by xavier green on 27/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import Foundation

class ServerConnection {
    
    init() {
        print("Initialising nuance server connection")
    }

    private var resultData: String = ""
    
    func connectToServer(BASE_URL: String,url: String, params: [[String]], method: String, notificationString: String,SERVER_USERNAME: String, SERVER_PASSWORD: String) {
        
        if method=="GET" {
            
            let connectionUrl = constructURL(base: BASE_URL, url: url, params: params)
            getRequest(connectionUrl: connectionUrl, notificationString: notificationString,SERVER_USERNAME, SERVER_PASSWORD)
            
        } else if method=="POST" {
            
            postRequest(connectionUrl: BASE_URL+url, params: params, notificationString: notificationString,SERVER_USERNAME,SERVER_PASSWORD)
            
        }
        
    }
    
    func getRequest(connectionUrl: String, notificationString: String,SERVER_USERNAME: String, SERVER_PASSWORD:String) {
        
        print("Connecting to ",connectionUrl)
        
        let config = URLSessionConfiguration.default
        let authString = constructHeaders(SERVER_USERNAME: SERVER_USERNAME, SERVER_PASSWORD: SERVER_PASSWORD)
        config.httpAdditionalHeaders = ["Authorization" : authString]
        let session = URLSession(configuration: config)
        let url = URL(string: connectionUrl)!
        let request = URLRequest(url: url)
        
        sendRequest(session: session, request: request, notificationString: notificationString)
        
    }
    
    func postRequest(connectionUrl: String, params: [[String]], notificationString: String,SERVER_USERNAME: String, SERVER_PASSWORD:String) {
        
        print("Connecting to ",connectionUrl)
        
        let postParams = constructParams(params: params)
        let sendData = postParams.data(using: String.Encoding.utf8)
        
        //print(postParams)
        
        let config = URLSessionConfiguration.default
        let authString = constructHeaders(SERVER_USERNAME: SERVER_USERNAME, SERVER_PASSWORD: SERVER_PASSWORD)
        config.httpAdditionalHeaders = ["Authorization" : authString]
        let session = URLSession(configuration: config)
        let url = URL(string: connectionUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = sendData
        
        sendRequest(session: session, request: request, notificationString: notificationString)
        
    }
    
    func sendRequest(session: URLSession, request: URLRequest, notificationString: String) {
        
        var running: Bool = false
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            running = false
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                return
            }
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
            //print(dataString)
            
            print("Done, sending notification: ",notificationString)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: notificationString), object: dataString)
            
        })
        
        running = true
        task.resume()
        
        while running {
            print("Getting data")
            sleep(1)
        }
        
    }
    
    func constructHeaders(SERVER_USERNAME: String, SERVER_PASSWORD:String) -> String {
        
        let loginString = String(format: "%@:%@", SERVER_USERNAME, SERVER_PASSWORD)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        let authString = "Basic \(base64LoginString)"
        return authString
        
    }
    
    func constructURL(base: String, url: String, params: [[String]]) -> String {
        
        var finalUrl = base + url + "?"
        for param in params {
            finalUrl += param[0]+"="+param[1]+"&"
        }
        return finalUrl
        
    }
    
    func constructParams(params: [[String]]) -> String {
        
        var finalUrl = ""
        for param in params {
            finalUrl += param[0]+"="+param[1]+"&"
        }
        return finalUrl
        
    }
}

















































