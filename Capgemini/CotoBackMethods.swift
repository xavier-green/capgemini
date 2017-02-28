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
    
    @objc func getUserListDone(notification: NSNotification) {
        let dataString = notification.object as! String
        print("got users:")
        print(dataString)
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
    }
    
}
