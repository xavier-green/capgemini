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
    
    func parseJsonArray(jsonString: String) -> [AnyObject]  {
        let data: Data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        let array = json as! [AnyObject]
        return array  as! [AnyObject]
    }
    
    func parseJson(jsonString: String) -> [String:Any]  {
        let data: Data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        let dictionary = json as! [String:Any]
        return dictionary
    }
    
    func getUserList() {
        Server.getUserList()
    }
    
    func getUsersNames() {
        Server.getUsersNames()
    }
    
    func getUser(speakerId: String) {
        Server.getUser(speakerId: speakerId)
    }
    
    func verifyUser(speakerId: String,memDate: String) {
        Server.verifyUser(speakerId: speakerId,memDate: memDate)
    }
    @objc func verifyUserDone(notification: NSNotification) {
        var authorized: Any!
        let dataString = notification.object as! String
        let dictionary = parseJson(jsonString: dataString)
        authorized = dictionary["authorized"] as! Bool
        NotificationCenter.default.post(name: Notification.Name(rawValue: "VERIFIED_USER"), object: authorized)
    }
    @objc func getUserDone(notification: NSNotification) {
        let dataString = notification.object as! String
        NotificationCenter.default.post(name: Notification.Name(rawValue: "GOT_USER"), object: dataString)
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
                GlobalVariables.usersAuthNumber.append(object["authNumber"] as! Int)
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
    
    func addImage(base64image: String) {
        Server.addImage(base64image: base64image, username: GlobalVariables.username)
    }
    
    @objc func addImageDone() {
        print("Added image !")
    }
    
    func getImages() {
        Server.getImages()
    }
    
    @objc func appendImages(notification: NSNotification) {
        let dataString = notification.object as! String
        let result = parseJsonArray(jsonString: dataString)
        var imageData: [String] = []
        for image in result {
            imageData.append(image["imageData"] as! String)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "FINISHED_GETTING_IMAGES"), object: imageData)
    }
    
    init() {
        Server = ConnectiontoBackServer()
        NotificationCenter.default.addObserver(self, selector: #selector(self.getUserListDone), name: NSNotification.Name(rawValue: "GET_USERS"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.addUserDone), name: NSNotification.Name(rawValue: "ADD_USER"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getUsersNamesDone), name: NSNotification.Name(rawValue: "GET_USERS_NAMES"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.verifyUserDone), name: NSNotification.Name(rawValue: "VERIFY_USER"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getUserDone), name: NSNotification.Name(rawValue: "GET_USER"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.addImageDone), name: NSNotification.Name(rawValue: "POST_IMAGE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appendImages), name: NSNotification.Name(rawValue: "GET_IMAGES"), object: nil)
    }
}
