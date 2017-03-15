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
    
    // Lorsque quelqu'un a reussi à s'authentifier à la place d'une autre personne
    @objc func addHack(hacker: String) {
        print("adding hack")
        let hacked = GlobalVariables.username
        _ = Server.addHack(hacker: hacker, hacked: hacked)
    }
    
    // Lorsque quelqu'un a raté sa tentative d'authentification à la place d'une autre personne
    @objc func hackAttempt() {
        let hacker = GlobalVariables.username
        print("adding hack attempt from ",hacker)
        _ = Server.hackAttempt()
    }
    
    // Lorsque quelqu'un reussi à s'authentifier
    func loginSuccess() {
        print("adding login success")
        _ = Server.loginSuccess()
    }
    
    // Lorsque quelqu'un rate son authentification
    @objc func loginFail(email: String) {
        let user = GlobalVariables.username
        print("adding login fail")
        _ = Server.loginFail(email: email, username: user)
    }
    
}
