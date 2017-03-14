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
    static var username: String = "" //Contains the user's chosen username through the enrolment / Authentication Phase
    static var allowedCommands: [String] = ["Authentification","Enrôlements","Suivant","Retour","Terminer","Chez Cételem ma voix et mon mot de passe","Chez Cételem ma voix est mon mot de passe","Oui","Non"] //Voice Commands
    static var base64image: String = "" //64image passed through app storyboard
    static var voteImageId: Int = 0 //ImageID for sent to server
    static var drawColor = UIColor.black //Color chosen at color screen in App Storyboard
    static var lineSpeedMultiplier: Int = 1 //Line speed multiplier used in Draw Components to increase speed
}
