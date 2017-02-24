//
//  RecordButtonClass.swift
//  Capgemini
//
//  Created by xavier green on 24/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit
import AVFoundation

class RecordButtonClass: UIButton {
    
    var recoVocale: ReconnaissanceVocaleController!
    let micOffImage = UIImage(named: "micOff")
    let micOnImage = UIImage(named: "micOn")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setStyle()
        start()
    }
    
    func getCoordinates() -> [Int] {
        let buttonFrame: CGRect = self.frame
        return [Int(buttonFrame.origin.x),Int(buttonFrame.origin.y)]
    }
    
    func setStyle() {
//        let screenWidth = UIScreen.main.fixedCoordinateSpace.bounds.width
//        let center = Int(screenWidth/2-55/2)
        self.setBackgroundImage(micOnImage, for: .normal)
        self.setTitle("", for: .normal)
//        let currentPlace = getCoordinates()
//        let y = currentPlace[1]
//        self.frame = CGRect(x: center, y: y, width: 55, height: 55)
//        self.frame.size = CGSize(width: 55, height: 55)
    }
    
    func start() {
        recoVocale = ReconnaissanceVocaleController()
        
        let okRecord = recoVocale.initAndCheck()
        
        if okRecord {
            self.isHidden = false
            self.addTarget(self, action: #selector(self.recordTapped), for: .touchUpInside)
        } else {
            self.isHidden = true
        }

    }
    
    func recordTapped() {
        if recoVocale.isRecording() {
            NSLog("Stopping recording")
            //self.recordButton.setTitle("Re-record", for: .normal)
            recoVocale.finishRecording(success: true)
            self.setBackgroundImage(micOnImage, for: .normal)
            recoVocale.playRecording()
        } else {
            NSLog("Starting recording")
            //self.recordButton.setTitle("STOP", for: .normal)
            self.setBackgroundImage(micOffImage, for: .normal)
            recoVocale.startRecording()
        }
    }

}
