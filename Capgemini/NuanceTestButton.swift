//
//  NuanceButtonClass.swift
//  Capgemini
//
//  Created by xavier green on 27/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit
import Speech

class NuanceTestButton: UIButton {
    
    var recoVocale: ReconnaissanceVocaleController!
    let micOffImage = UIImage(named: "micOff")
    let micOnImage = UIImage(named: "micOn")
    
    func recordTapped() {
        if recoVocale.isRecording() {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "NUANCE_PROCESSING"), object: self)
            self.setBackgroundImage(micOnImage, for: .normal)
            recoVocale.finishRecording(success: true)
            self.verify(username1: GlobalVariables.speaker1, username2: GlobalVariables.speaker2)
        } else {
            self.setBackgroundImage(micOffImage, for: .normal)
            recoVocale.startRecording()
        }
    }
    
    func verify(username1: String, username2: String) {
        DispatchQueue.global(qos: .background).async {
            let verified1 = self.recoVocale.getScore(username: username1)
            let verified2 = self.recoVocale.getScore(username: username2)
            DispatchQueue.main.async {
                print(username1,"  :  ",verified1)
                print(username2,"  :  ",verified2)
            }
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
                self.addTarget(self, action: #selector(self.recordTapped), for: .touchDown)
                self.addTarget(self, action: #selector(self.recordTapped), for: .touchUpInside)
                self.addTarget(self, action: #selector(self.recordTapped), for: .touchDragExit)
                
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
