//
//  ServerFunctions.swift
//  Capgemini
//
//  Created by xavier green on 27/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//
import Foundation

class ServerFunctions {
    
    private var Server: ServerConnection!
    private var Parser: NuanceXMLParser!
    private var currentUsername: String = ""
    private var status: String = ""
    private var lastMissingSegments: Int = 3
    
    func getUserList(username: String, audio: String) {
        Server.getUserList()
    }
    
    @objc func getUserListDone(notification: NSNotification) {
        let xmlString = notification.object as! String
        print("got users:")
        print(xmlString)
    }
    
    func verify(username: String, audio: String) {
        Server.verify(speakerId: username, audio: audio)
    }
    
    @objc func verifyDone(notification: NSNotification) {
        let xmlString = notification.object as! String
        print("Verify done handler")
        //print(xmlString)
        let isMatched = Parser.extractMatch(xmlString: xmlString)
        print("user is logged in :",isMatched)
        if isMatched {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "REC_SUCCESS"), object: self)
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "REC_FAIL"), object: self)
        }
    }
    
    func enroll(username: String, audio: String) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NUANCE_PROCESSING"), object: self)
        self.currentUsername = username
        Server.enroll(speakerId: username, audio: audio)
    }
    
    @objc func enrollDone(notification: NSNotification) {
        let user = self.currentUsername
        let xmlString = notification.object as! String
        print(xmlString)
        status = Parser.extractUserStatus(xmlString: xmlString)
        print("enroll done : ",status)
        Server.getEnrollSegmentsStatus(speakerId: user)
    }
    
    @objc func enrollStatus(notification: NSNotification) {
        let xmlString = notification.object as! String
        //        print("Enrollment status handler")
        //        print(xmlString)
        let missingSegments = Parser.extractMissingSegments(xmlString: xmlString)
        print("status:",status," ; missingSegments:",missingSegments)
        if (self.status == "NotReady") {
            if (missingSegments >= self.lastMissingSegments) {
                print("Fail during audio recording")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "REC_FAIL"), object: self)
            } else {
                self.lastMissingSegments = missingSegments
                print("Success, please record your voice again")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "REC_SUCCESS"), object: self)
            }
        } else if (self.status == "Trained") {
            print("Successfully signed up !")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "SUCCESS"), object: self)
        }
    }
    
    init() {
        
        Server = ServerConnection()
        Parser = NuanceXMLParser()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getUserListDone), name: NSNotification.Name(rawValue: "USER_LIST"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.verifyDone), name: NSNotification.Name(rawValue: "VERIFY"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.enrollDone), name: NSNotification.Name(rawValue: "ENROLL"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.enrollStatus), name: NSNotification.Name(rawValue: "ENROLL_SEGMENT_STATUS"), object: nil)
        
}

