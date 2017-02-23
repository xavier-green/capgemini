//
//  ViewController.swift
//  Capgemini
//
//  Created by xavier green on 17/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var NoBut: UIButton!
    @IBOutlet var YesBut: UIButton!
    @IBOutlet var HelloLabel: UILabel!
    @IBOutlet var RecordButton: UIButton!
    @IBOutlet var AccountLabel: UITextView!
    
    
    let micOffImage = UIImage(named: "micOff")
    let micOnImage = UIImage(named: "micOn")
    
    @IBAction func NoButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Enrolment", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EnrolmentViewController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
    var recoVocale: ReconnaissanceVocaleController!
    var speechToText: TextToSpeech!
    
    func nexView() {
        print("Moving to next storyboard")
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") 
        self.present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        print("started main app")
        super.viewDidLoad()
        recoVocale = ReconnaissanceVocaleController()
        speechToText = TextToSpeech()
        
        NoBut.layer.borderWidth = 1
        NoBut.layer.borderColor = UIColor.lightGray.cgColor
        YesBut.layer.borderWidth = 1
        YesBut.layer.borderColor = UIColor.lightGray.cgColor
        
        let labelArray: [String] = [self.HelloLabel.text!, "Comment allez vous ?"]
        speechToText.speak(sentences: labelArray)
        let okRecord = recoVocale.initAndCheck()
        
        if okRecord {
            self.RecordButton.isHidden = false
            self.RecordButton.addTarget(self, action: #selector(self.recordTapped), for: .touchUpInside)
            self.YesBut.addTarget(self, action: #selector(self.nexView), for: .touchUpInside)
        } else {
            self.RecordButton.isHidden = true
        }
    }
    
    func recordTapped() {
        if recoVocale.isRecording() {
            NSLog("Stopping recording")
            //self.recordButton.setTitle("Re-record", for: .normal)
            recoVocale.finishRecording(success: true)
            self.RecordButton.setBackgroundImage(micOnImage, for: .normal)
            recoVocale.playRecording()
        } else {
            NSLog("Starting recording")
            //self.recordButton.setTitle("STOP", for: .normal)
            self.RecordButton.setBackgroundImage(micOffImage, for: .normal)
            recoVocale.startRecording()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

