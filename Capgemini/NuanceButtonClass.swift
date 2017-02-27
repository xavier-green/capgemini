//
//  NuanceButtonClass.swift
//  Capgemini
//
//  Created by xavier green on 27/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit
import Speech

class NuanceButtonClass: UIButton {
    
    var recoVocale: ReconnaissanceVocaleController!
    let micOffImage = UIImage(named: "micOff")
    let micOnImage = UIImage(named: "micOn")
    
    func recordTapped() {
        if recoVocale.isRecording() {
            self.setBackgroundImage(micOnImage, for: .normal)
            recoVocale.finishRecording(success: true)
            if self.restorationIdentifier=="Login" {
                recoVocale.verify(username: "Xavier")
            } else if self.restorationIdentifier=="Register"{
                recoVocale.enroll(username: "Xavier")
            } else {
                print("this button has no callback function")
            }
        } else {
            self.setBackgroundImage(micOffImage, for: .normal)
            recoVocale.startRecording()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        recoVocale = ReconnaissanceVocaleController()
        setStyle()
        start()
    }
    
    func setStyle() {
        self.setBackgroundImage(micOnImage, for: .normal)
        self.setTitle("", for: .normal)
    }
    
    func start() {
        
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

}
