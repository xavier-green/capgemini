//
//  ServerFunctions.swift
//  Capgemini
//
//  Created by younes Belkouchi on 27/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//
import Foundation

class CotoBackMethods {
    
    private var Server: ConnectiontoBackServer!
    private var currentUsername: String = ""
    
    func getUserList() {
        Server.getUserList()
    }
    
    func getUsersNames() {
        Server.getUsersNames()
    }
    
    func verifyUser(speakerId: String,memDate: String) {
        Server.verifyUser(speakerId: speakerId,memDate: memDate)
    }
    @objc func verifyUserDone(notification: NSNotification) {
        var authorized: Any!
        let dataString = notification.object as! String
        let data: Data = dataString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        let dictionary = json as! [String:Any]
        authorized = dictionary["authorized"]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "VERIFIED_USER"), object: authorized)
    }
    
    @objc func getUserListDone(notification: NSNotification) {
        let dataString = notification.object as! String
        print("got users:")
        print(dataString)
    }
    
    @objc func getUsersNamesDone(notification: NSNotification)  {
        var name : Any!
        let dataString = notification.object as! String
        let data: Data = dataString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        let array = json as! [AnyObject]
        for object in array {
            name = object["username"]!
            if !GlobalVariables.usernames.contains(name as! String) {
                GlobalVariables.usernames.append(name as! String)
            }
        }
    }
    
    func addUser(speakerId: String,memDate: String) {
        Server.addUser(speakerId: speakerId, memDate: memDate)
    }
        
    @objc func addUserDone(notification: NSNotification) {
        let dataString = notification.object as! String
        print("Added User:")
        print(dataString)
    }
    
    init() {
        Server = ConnectiontoBackServer()
        NotificationCenter.default.addObserver(self, selector: #selector(self.getUserListDone), name: NSNotification.Name(rawValue: "GET_USERS"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.addUserDone), name: NSNotification.Name(rawValue: "ADD_USER"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getUsersNamesDone), name: NSNotification.Name(rawValue: "GET_USERS_NAMES"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.verifyUserDone), name: NSNotification.Name(rawValue: "VERIFY_USER"), object: nil)
    }
}
