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
        return array
    }
    
    func parseJson(jsonString: String) -> [String:Any]  {
        let data: Data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        let dictionary = json as! [String:Any]
        return dictionary
    }
    
//    func getUserList() -> String {
//        Server.getUserList()
//    }
    
    func getUsersNames() -> [AnyObject] {
        let usernamesJSON = Server.getUsersNames()
        let data: Data = usernamesJSON.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [AnyObject]
        var usernames = [String]()
        var usernamesAuths = [Int]()
        for object in json! {
            let name = object["username"]!
            if !usernames.contains(name as! String) {
                usernames.append(name as! String)
                usernamesAuths.append(object["authNumber"] as! Int)
            }
        }
        let sendObject = [usernames,usernamesAuths] as [Any]
        return sendObject as [AnyObject]
    }
    
    func getUser(speakerId: String) {
        let user = Server.getUser(speakerId: speakerId)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "GOT_USER"), object: user)
    }
    
    func verifyUser(speakerId: String,memDate: String) -> Bool {
        let verificationJSON = Server.verifyUser(speakerId: speakerId,memDate: memDate)
        let verification = parseJson(jsonString: verificationJSON)["authorized"] as! Bool
        return verification
    }
    
    func addUser(speakerId: String,memDate: String) -> String {
        let userAdded = Server.addUser(speakerId: speakerId, memDate: memDate)
        print("Added User:")
        return userAdded
    }
    
    func addImage(base64image: String) {
        _ = Server.addImage(base64image: base64image, username: GlobalVariables.username)
        print("Added image !")
    }
    
    func getImages() -> [[AnyObject]] {
        let images = Server.getImages()
        let result = parseJsonArray(jsonString: images)
        var imageData: [String] = []
        var idData: [Int] = []
        var drawerData : [String] = []
        for image in result {
            imageData.append(image["imageData"] as! String)
            idData.append(image["_id"] as! Int)
            drawerData.append(image["username"] as! String)
        }
        let sendObject: [[AnyObject]] = [imageData as Array<AnyObject>,idData as Array<AnyObject>, drawerData as Array<AnyObject>]
        print("sending FINISHED_IM")
        return sendObject as [[AnyObject]]
    }
    
    func voteForImage() {
        _ = Server.voteForImage(imageId: GlobalVariables.voteImageId)
        print("done voting for image !")
    }
    
    func getLeadersPost() -> [[AnyObject]] {
        let leaders = Server.getLeaderboard()
        let result = parseJsonArray(jsonString: leaders)
        var imageData: [String] = []
        var userData: [String] = []
        var votesData: [Int] = []
        for image in result {
            imageData.append(image["imageData"] as! String)
            userData.append(image["username"] as! String)
            votesData.append(image["votes"] as! Int)
        }
        let sendObject: [[AnyObject]] = [imageData as Array<AnyObject>,userData as Array<AnyObject>,votesData as Array<AnyObject>]
        return sendObject as [[AnyObject]]
    }
    
    func getUserFreq(speakerId: String) {
        let frequency = Server.getFrequency(speakerId: speakerId)
        let dictionary = parseJson(jsonString: frequency) as [String:Any]
        print("Got user freq")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "GOT_USER_FREQ"), object: dictionary)
    }
    
    func sendUserFreq(speakerId: String, frequency: Any) {
        _ = Server.addFrequency(speakerId: speakerId, frequency: frequency)
    }
    
    func logAttempt() {
        print("log attempt")
        _ = Server.loggingAttempt()
    }
    func enrAttempt() {
        print("enrol attempt")
        _ = Server.enrolAttempt()
    }
    
    init() {
        Server = ConnectiontoBackServer()
//        NotificationCenter.default.addObserver(self, selector: #selector(self.getUserListDone), name: NSNotification.Name(rawValue: "GET_USERS"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.addUserDone), name: NSNotification.Name(rawValue: "ADD_USER"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.getUsersNamesDone), name: NSNotification.Name(rawValue: "GET_USERS_NAMES"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.verifyUserDone), name: NSNotification.Name(rawValue: "VERIFY_USER"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.getUserDone), name: NSNotification.Name(rawValue: "GET_USER"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.addImageDone), name: NSNotification.Name(rawValue: "POST_IMAGE"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.appendImages), name: NSNotification.Name(rawValue: "GET_IMAGES"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.voteForImageDone), name: NSNotification.Name(rawValue: "VOTE_DONE"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.getLeaderboardDone), name: NSNotification.Name(rawValue: "LEADER_DONE"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.getLeaderboard), name: NSNotification.Name(rawValue: "GET_LEADERS"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.getUserFreqDone), name: NSNotification.Name(rawValue: "GET_USER_FREQ"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.sendUserFreqDone), name: NSNotification.Name(rawValue: "SEND_USER_FREQ"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.logAttempt), name: NSNotification.Name(rawValue: "ADD_LOG_ATT"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.enrAttempt), name: NSNotification.Name(rawValue: "ADD_ENR_ATT"), object: nil)
    }
}
