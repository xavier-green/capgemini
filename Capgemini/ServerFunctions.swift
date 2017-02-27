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
    
    init() {
        
        Server = ServerConnection()
        Parser = NuanceXMLParser()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getUserListDone), name: NSNotification.Name(rawValue: "USER_LIST"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.verifyDone), name: NSNotification.Name(rawValue: "VERIFY"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.enrollDone), name: NSNotification.Name(rawValue: "ENROLL"), object: nil)
        
    }
    
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
    }
    
    func enroll(username: String, audio: String) {
        Server.verify(speakerId: username, audio: audio)
    }
    
    @objc func enrollDone(notification: NSNotification) {
        let xmlString = notification.object as! String
        print("enroll done ?")
        print(xmlString)
    }
    
}
