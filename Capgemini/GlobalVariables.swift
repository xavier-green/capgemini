//
//  GlobalVariables.swift
//  Capgemini
//
//  Created by xavier green on 22/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import Foundation
import UIKit

struct GlobalVariables {
    static var username: String = ""
    static var usernames: [String] = []
    static var nuanceUsernames: [String] = []
    static var usersAuthNumber: [Int] = []
    static var allowedCommands: [String] = ["Authentification","Enrôlements","Suivant","Retour","Terminer","Chez Cételem ma voix et mon mot de passe","Chez Cételem ma voix est mon mot de passe","Oui","Non"]
    static var base64image: String = ""
    static var voteImageId: Int = 0
    static var drawColor = UIColor.black
}
