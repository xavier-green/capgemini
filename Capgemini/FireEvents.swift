//
//  FireEvents.swift
//  Capgemini
//
//  Created by xavier green on 24/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import Foundation
import Speech

class FireEvents {
    
    @objc func fireDone(resultat: String) {
        
        print("resultat du speechtotext: ",resultat)
        
        switch resultat {
        case "Authentification":
            print("got voice authentication")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "AUTHENTIFICATION"), object: self)
        case "Enrôlements":
            print("got voice enrollment")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ENROLLEMENT"), object: self)
        case "Suivant":
            print("got voice suivant")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "SUIVANT"), object: self)
        case "Retour":
            print("got voice retour")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "RETOUR"), object: self)
        case "Terminer":
            print("got voice retour")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "TERMINER"), object: self)
        case "Chez Cételem ma voix et mon mot de passe":
            print("got voice retour")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "VOICE_AUTH"), object: self)
        case "Chez Cételem ma voix est mon mot de passe":
            print("got voice retour")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "VOICE_AUTH"), object: self)
        case "Oui":
            print("got voice retour")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "OUI"), object: self)
        case "Non":
            print("got voice retour")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "NON"), object: self)
        default:
            print("not an identified case")
        }
        
    }
    
}
