//
//  RecordButtonClass.swift
//  Capgemini
//
//  Created by xavier green on 24/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class RecordButtonClass: UIButton {
    
    //var recoVocale: ReconnaissanceVocaleController!
    var micToText = SpeechToText()
    let micOffImage = UIImage(named: "micOff")
    let micOnImage = UIImage(named: "micOn")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setStyle()
        start()
    }
    
    func setStyle() {
        self.setBackgroundImage(micOnImage, for: .normal)
        self.setTitle("", for: .normal)
    }
    
    func start() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.fireDone), name: NSNotification.Name(rawValue: "DONE_SPEECH_TO_TEXT"), object: nil)
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            switch authStatus {
            case .authorized:
                self.isHidden = false
                self.addTarget(self, action: #selector(self.recordTapped), for: .touchUpInside)
                print("all okay")
                
            case .denied:
                self.isHidden = true
                print("User denied access to speech recognition")
                
            case .restricted:
                self.isHidden = true
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                self.isHidden = true
                print("Speech recognition not yet authorized")
            }
        }
    }
    
    @objc func fireDone() {
        let resultat = micToText.getResult()
        print("resultat du speechtotext: ",resultat)
        if (resultat == "Authentification") {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "AUTHENTIFICATION"), object: self)
        }
    }
    
    
    func recordTapped() {
        if micToText.isRecording() {
            NSLog("Stopping recording")
            micToText.stop()
            //recoVocale.finishRecording(success: true)
            self.setBackgroundImage(micOnImage, for: .normal)
        } else {
            NSLog("Starting recording")
            self.setBackgroundImage(micOffImage, for: .normal)
            micToText.startRecording()
        }
    }

}
