//
//  VoiceRecViewController.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 20/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class VoiceRecViewController: UIViewController {
    //MARK: Properties
    let recordSniplets = [Any]() //Array to stor recorded samples
    var recAttempts: Int = 3 //Record Attemts
    let micOffImage = UIImage(named: "micOff")
    let micOnImage = UIImage(named: "micOn")
    var recoVocale: ReconnaissanceVocaleController!
    var speechToText: TextToSpeech!

    
    //MARK: Outlets
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var repeatTimes: UILabel!
    @IBAction func doneBut(_ sender: UIButton) {
        if recAttempts==0{
            self.performSegue(withIdentifier: "recDone", sender: nil)
        }
    }
    
    
    //MARK: View funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        recoVocale = ReconnaissanceVocaleController()
        speechToText = TextToSpeech()
        
        //See if it's ok to record
        let okRecord = recoVocale.initAndCheck()
        
        if okRecord {
            self.recordButton.isHidden = false
            self.recordButton.addTarget(self, action: #selector(self.recordTapped), for: .touchUpInside)
        } else {
            self.recordButton.isHidden = true
        }
        assignbackground()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Record Function
    func recordTapped() {
        if recAttempts>0 {
            if recoVocale.isRecording() {
                NSLog("Stopping recording")
                //self.recordButton.setTitle("Re-record", for: .normal)
                recoVocale.finishRecording(success: true)
                self.recordButton.setBackgroundImage(micOnImage, for: .normal)
                recAttempts-=1
                repeatTimes.text = "Plus que \(String(recAttempts)) fois"
                if recAttempts==0 {
                    doneButton.isHidden=false
                }
                recoVocale.playRecording()
            } else {
                NSLog("Starting recording")
                //self.recordButton.setTitle("STOP", for: .normal)
                self.recordButton.setBackgroundImage(micOffImage, for: .normal)
                recoVocale.startRecording()
            }
        }
    }
}
