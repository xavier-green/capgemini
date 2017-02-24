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
    
    var micToText = SpeechToText()
    
    init() {
        print("initialising observer")
        NotificationCenter.default.addObserver(self, selector: #selector(self.fireDone), name: NSNotification.Name(rawValue: "DONE_SPEECH_TO_TEXT"), object: nil)
    }
    
    @objc func fireDone() {
        let resultat = micToText.getResult()
        print("resultat du speechtotext: ",resultat)
        if (resultat == "Authentification") {
            print("got voice authentication")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "AUTHENTIFICATION"), object: self)
        } else if (resultat == "Enrôlements") {
            print("got voice enrollment")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ENROLLEMENT"), object: self)
        }
    }
    
}
