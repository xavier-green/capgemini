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
            self.verify(namesArray: GlobalVariables.pieuvreUsernames)
            speechToText()
        } else {
            self.setBackgroundImage(micOffImage, for: .normal)
            recoVocale.startRecording()
        }
    }
    
    func speechToText() {
        DispatchQueue.global(qos: .background).async {
            self.recoVocale.recognizeFile()
        }
    }
    
    func verify(namesArray: [String]) {
        DispatchQueue.global(qos: .background).async {
            var results = [Int]()
            for name in namesArray {
                results.append(self.recoVocale.getScore(username: name))
            }
            let maxScore = results.max()
            let maxIndex = results.index(of: maxScore!)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "PIEUVRE_NAME"), object: namesArray[maxIndex!])
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
