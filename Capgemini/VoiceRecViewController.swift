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
    var isRecording: Bool = false
    

    
    //MARK: Outlets
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var repeatTimes: UILabel!
    @IBAction func doneBut(_ sender: UIButton) {
        if recAttempts==0{
            self.performSegue(withIdentifier: "recDone", sender: nil)
        }
    }
    @IBOutlet weak var enregistrement: UILabel!
    @IBOutlet weak var nextBut: UIButton!
    @IBAction func recBut(_ sender: RecordButtonClass) {
        isRecording = !isRecording
        if isRecording {
            enregistrement.text="Réappuyez pour arrêter l'enregistrement"
        }
        if !isRecording {
            enregistrement.text="Appuyez pour commencer l'enregistrement"
            recAttempts-=1
            repeatTimes.text="Plus que \(String(recAttempts)) fois"
            if recAttempts==0 {
                nextBut.isHidden=false
                repeatTimes.isHidden=true
                enregistrement.isHidden=true
            }
        }
    }
    
    
    //MARK: View funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
        enregistrement.adjustsFontSizeToFitWidth=true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
