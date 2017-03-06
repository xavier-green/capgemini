//
//  StatController.swift
//  Capgemini
//
//  Created by xavier green on 06/03/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import Foundation

class StatController {
    
    private var Server = ConnectiontoBackServer()
    
    @objc func addHack(hacker: String) {
        print("adding hack")
        let hacked = GlobalVariables.username
        Server.addHack(hacker: hacker, hacked: hacked)
    }
    
    @objc func hackAttempt() {
        let hacker = GlobalVariables.username
        print("adding hack attempt from ",hacker)
        Server.hackAttempt()
    }
    
    @objc func loginSuccess() {
        print("adding login success")
        Server.loginSuccess()
    }
    
    @objc func loginFail(email: String) {
        print("adding login fail")
        Server.loginFail(email: email)
    }
    
}
