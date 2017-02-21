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

    @IBOutlet weak var YesBut: UIButton!
    @IBOutlet weak var HelloLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var AccountLabel: UILabel!
    
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
        self.present(controller, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        print("started main app")
        super.viewDidLoad()
        recoVocale = ReconnaissanceVocaleController()
        speechToText = TextToSpeech()
        
        let labelArray: [String] = [self.HelloLabel.text!, self.AccountLabel.text!]
        speechToText.speak(sentences: labelArray)
        let okRecord = recoVocale.initAndCheck()
        
        if okRecord {
            self.recordButton.isHidden = false
            self.recordButton.addTarget(self, action: #selector(self.recordTapped), for: .touchUpInside)
            self.YesBut.addTarget(self, action: #selector(self.nexView), for: .touchUpInside)
        } else {
            self.recordButton.isHidden = true
        }
    }
    
    func recordTapped() {
        if recoVocale.isRecording() {
            NSLog("Stopping recording")
            //self.recordButton.setTitle("Re-record", for: .normal)
            recoVocale.finishRecording(success: true)
            self.recordButton.setBackgroundImage(micOnImage, for: .normal)
            recoVocale.playRecording()
        } else {
            NSLog("Starting recording")
            //self.recordButton.setTitle("STOP", for: .normal)
            self.recordButton.setBackgroundImage(micOffImage, for: .normal)
            recoVocale.startRecording()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

