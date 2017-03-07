//
//  ServerConnection.swift
//  Capgemini
//
//  Created by younes belkouchi on 27/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//
import Foundation
import UIKit

class ConnectiontoBackServer {
    
    init() {
        print("Initialising back server connection")
    }
    
    private let BASE_URL: String = "http://vps383005.ovh.net:3000/api"
    private let SERVER_USERNAME: String = "youyoun"
    private let SERVER_PASSWORD: String = "password"
    
    private var resultData: String = ""
    
    func connectToServer(url: String, params: [[String]], method: String, notificationString: String) {
        
        if method=="GET" {
            
            let connectionUrl = constructURL(base: BASE_URL, url: url, params: params)
            getRequest(connectionUrl: connectionUrl, notificationString: notificationString)
            
        } else if method=="POST" {
            
            postRequest(connectionUrl: BASE_URL+url, params: params, notificationString: notificationString)
            
        } else if method=="PUT" {
            
            let connectionUrl = constructURL(base: BASE_URL, url: url, params: params)
            putRequest(connectionUrl: connectionUrl, notificationString: notificationString)
            
        }
        
    }
    
    func putRequest(connectionUrl: String, notificationString: String) {
        
        print("Connecting to ",connectionUrl)
        
        let config = URLSessionConfiguration.default
        let authString = constructHeaders()
        config.httpAdditionalHeaders = ["Authorization" : authString]
        let session = URLSession(configuration: config)
        let url = URL(string: connectionUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        sendRequest(session: session, request: request, notificationString: notificationString)
        
    }
    
    func getRequest(connectionUrl: String, notificationString: String) {
        
        print("Connecting to ",connectionUrl)
        
        let config = URLSessionConfiguration.default
        let authString = constructHeaders()
        config.httpAdditionalHeaders = ["Authorization" : authString]
        let session = URLSession(configuration: config)
        let url = URL(string: connectionUrl)!
        let request = URLRequest(url: url)
        
        sendRequest(session: session, request: request, notificationString: notificationString)
        
    }
    
    func postRequest(connectionUrl: String, params: [[String]], notificationString: String) {
        
        print("Connecting to ",connectionUrl)
        
        let postParams = constructParams(params: params)
        let sendData = postParams.data(using: String.Encoding.utf8)!
        
        //print(postParams)
        
        let config = URLSessionConfiguration.default
        let authString = constructHeaders()
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
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "REQUEST_START"), object: self)
        
        var running: Bool = false
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            running = false
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                print("******** REQUEST ERROR")
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
                print(dataString)
                return
            }
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
            //print(dataString)
            
            print("Done, sending notification: ",notificationString)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: notificationString), object: dataString)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "REQUEST_END"), object: self)
            
        })
        
        running = true
        task.resume()
        
        while running {
            print("Getting data")
            sleep(1)
        }
        
    }
    
    func constructHeaders() -> String {
        
        let loginString = String(format: "%@:%@", SERVER_USERNAME, SERVER_PASSWORD)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        let authString = "Basic \(base64LoginString)"
        //print("authstring: ",authString)
        return authString
        
    }
    
    func constructURL(base: String, url: String, params: [[String]]) -> String {
        if params[0]==[] {
            let finalUrl = base + url
            return finalUrl
        } else { 
            var finalUrl = base + url + "?"
            for param in params {
                finalUrl += param[0]+"="+param[1]+"&"
            }
            return finalUrl
        }
    }
    
    func constructParams(params: [[String]]) -> String {
        
        var finalUrl = ""
        print("params length: ",params.count)
        if (params.count > 0) {
            for param in params {
                //print("param: ",param)
                finalUrl += param[0]+"="+param[1]+"&"
            }
        }
        return finalUrl
        
    }
    
    func getUserList() {
        
        let url: String = "/users"
        let params: [[String]] = [[]]
        
        connectToServer(url: url, params: params, method: "GET", notificationString: "GET_USERS")
        
    }
    
    func getUsersNames() {
        let url: String = "/users"
        let params: [[String]] = [[]]
        
        connectToServer(url: url, params: params, method: "GET", notificationString: "GET_USERS_NAMES")
    }
    
    func addUser(speakerId: String, memDate: String) {
        
        print("Adding user to back")
        
        let url: String = "/users"
        let params: [[String]] = [["username",speakerId],["memDate",memDate]]
        
        connectToServer(url: url, params: params, method: "POST", notificationString: "ADD_USER")
        
    }
    
    func verifyUser(speakerId: String, memDate: String) {
        print("Verifying user date")
        
        let url: String = "/users/verifyDate"
        let params: [[String]] = [["username",speakerId],["memDate",memDate]]
        
        connectToServer(url: url, params: params, method: "POST", notificationString: "VERIFY_USER")
    }
    
    func getUser(speakerId: String) {
        print("Getting user attribute")
        
        let url: String = "/users/\(speakerId)"
        let params: [[String]] = [[]]
        
        connectToServer(url: url, params: params, method: "GET", notificationString: "GET_USER")
    }
    
    func addImage(base64image: String, username: String) {
        
        print("saving image to server")
        let url: String = "/images"
        let params: [[String]] = [["imageData",base64image],["username",username]]
        
        connectToServer(url: url, params: params, method: "POST", notificationString: "POST_IMAGE")
        
    }
    
    func getImages() {
        
        print("getting images from db")
        let url: String = "/images"
        let params: [[String]] = [["username",GlobalVariables.username]]
        
        connectToServer(url: url, params: params, method: "GET", notificationString: "GET_IMAGES")
        
    }
    
    func voteForImage(imageId: Int) {
        
        print("voting for ",imageId)
        let url: String = "/images/"+String(imageId)
        let params: [[String]] = [[]]
        
        connectToServer(url: url, params: params, method: "PUT", notificationString: "VOTE_DONE")
        
    }
    
    func getLeaderboard() {
        
        print("getting leaderboard")
        let url: String = "/images/leader"
        let params: [[String]] = [[]]
        
        connectToServer(url: url, params: params, method: "GET", notificationString: "LEADER_DONE")

    }
    
    func addHack(hacker: String, hacked: String) {
        
        print("hacking of ",hacked," by ",hacker)
        let url: String = "/stats/addHack"
        let params: [[String]] = [["hacked",hacked],["hacker",hacker]]
        
        connectToServer(url: url, params: params, method: "POST", notificationString: "ADD_HACK_DONE")
        
    }
    
    func hackAttempt() {
        
        print("Prevented hack !")
        let url: String = "/stats/hackAttempt"
        let params = [[String]]()
        
        connectToServer(url: url, params: params, method: "POST", notificationString: "HACK_ATTEMPT_DONE")
        
    }
    
    func loginSuccess() {
        
        print("Login success !")
        let url: String = "/stats/loginSuccess"
        let params = [[String]]()
        
        connectToServer(url: url, params: params, method: "POST", notificationString: "LOGIN_SUCCESS_DONE")
        
    }
    
    func loginFail(email: String, username: String) {
        
        print("Login failed ! Reponse to: ",email)
        let url: String = "/stats/loginFail"
        let params: [[String]] = [["email",email],["username",username]]
        
        connectToServer(url: url, params: params, method: "POST", notificationString: "LOGIN_FAIL_DONE")
        
    }
    
    func getFrequency(speakerId: String) {
        print("Getting user frequency")
        
        let url: String = "/users/addFrequency"
        let params: [[String]] = [["username","\(speakerId)"]]
        
        connectToServer(url: url, params: params, method: "POST", notificationString: "GET_USER_FREQ")
    }
    
    func addFrequency(speakerId:String, frequency: Any) {
        print("Sending user frequency")
        
        let url: String = "/users/addFrequency"
        let params: [[String]] = [["username","\(speakerId)"],["frequency","\(frequency)"]]
        
        connectToServer(url: url, params: params, method: "POST", notificationString: "SEND_USER_FREQ")
    }
    
    func loggingAttempt() {
        print("Adding login attempt")
        let url: String = "/stats/loginAttempt"
        let params: [[String]] = []
        
        connectToServer(url: url, params: params, method: "POST", notificationString: "ADD_LOG")
    }
    
    func enrolAttempt() {
        print("Adding Enrol Attempt")
        
        let url: String = "/stats/enrolAttempt"
        let params: [[String]] = []
        
        connectToServer(url: url, params: params, method: "POST", notificationString: "ADD_ENR")
    }
    

}






