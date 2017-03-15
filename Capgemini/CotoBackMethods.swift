//
//  ServerFunctions.swift
//  Capgemini
//
//  Created by younes Belkouchi on 27/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//
//  This Module Contains all Methods that are executed in the app.
//  It uses ConnectiontoBackServer.swift
//

import Foundation
import UIKit
class CotoBackMethods {
    
    private var Server: ConnectiontoBackServer!
    private var currentUsername: String = ""
    
    
    //MARK: JsonParser
    
    // Parse Json when it starts with []
    func parseJsonArray(jsonString: String) -> [AnyObject]  {
        let data: Data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        let array = json as! [AnyObject]
        return array
    }
    
    // Parse Json when it starts with {}
    func parseJson(jsonString: String) -> [String:Any]  {
        let data: Data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        let dictionary = json as! [String:Any]
        return dictionary
    }
    
    
    //MARK: Requests Executed
    
    /**
     Gets all users name in back database
     Parses Json from request
     - Returns: 
        - sendData : [usernames, usernamesAuths]
        - usernames: [String] of users names
        - usernamesAuths: [Int] of users authentication number
     */
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
    
    /**
     Gets user information
     - Parameter speakerID: Chosen user name
     */
    func getUser(speakerId: String) {
        let user = Server.getUser(speakerId: speakerId)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "GOT_USER"), object: user)
    }
    
    /**
     Verify user information
     - Parameters 
        - speakerID: Chosen user name
        - memDate: Memorable Date chosen by user
     - Returns: Boolean. true if date is correct for speakerId
     */
    func verifyUser(speakerId: String,memDate: String) -> Bool {
        let verificationJSON = Server.verifyUser(speakerId: speakerId,memDate: memDate)
        let verification = parseJson(jsonString: verificationJSON)["authorized"] as! Bool
        return verification
    }
    
    /**
     Add User To database in Enrolment Phase
     Post request containing request data
     - Parameters:
     - speakerID : String containing the name chosen by the user
     - memDate : Memorable Date chosen by user
     - Returns: JSON of the new added user
     */
    func addUser(speakerId: String,memDate: String) -> String {
        let userAdded = Server.addUser(speakerId: speakerId, memDate: memDate)
        print("Added User:")
        return userAdded
    }
    
    /**
     Add Image in base64 to the database in App Storyboard
     - Parameters:
     - username : String containing the name chosen by the user
     - base64Image : Image Drawn encoded in base64
     */
    func addImage(base64image: String) {
        _ = Server.addImage(base64image: base64image, username: GlobalVariables.username)
        print("Added image !")
    }
    
    /**
     Get Images in base64 from the database in App Storyboard
     Parse Json to get imagesId, image in base64 and drawer
     */
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
    
    func getTopImage(position: Int) -> [[AnyObject]] {
        let images = Server.getTopImage(position: position)
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
    
    /**
     Vote for an image from all the images
     Increments the vote attribute of image in database
     */
    func voteForImage() {
        _ = Server.voteForImage(imageId: GlobalVariables.voteImageId)
        print("done voting for image !")
    }
    
    /**
     Get images classed by votes
     Parse Json to get image, vote and drawer for each image
     */
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
    
    func getTopLeadersPost(position: Int) -> [[AnyObject]] {
        let leaders = Server.getTopLeaderboard(position: position)
        print("leader:")
        print(leaders)
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
    
    /**
     Get User frequency
     - Parameter speakerId: name chosen by user
     Sends Notification
     */
    func getUserFreq(speakerId: String) {
        let frequency = Server.getFrequency(speakerId: speakerId)
        let dictionary = parseJson(jsonString: frequency) as [String:Any]
        print("Got user freq")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "GOT_USER_FREQ"), object: dictionary)
    }
    
    func sendUserFreq(speakerId: String, frequency: Any) {
        _ = Server.addFrequency(speakerId: speakerId, frequency: frequency)
    }
    
    //MARK: Stats
    func failedToLogin(email: String) {
        let username = GlobalVariables.username
        _ = Server.loginFail(email: email, username: username)
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
    }
}
