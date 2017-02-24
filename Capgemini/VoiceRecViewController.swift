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
        goForw()
    }
    @IBOutlet weak var enregistrement: UILabel!
    @IBOutlet weak var nextBut: UIButton!
    @IBAction func launchRecord(_ sender: Any) {
        changeText()
    }
    
    func changeText() {
        isRecording = !isRecording
        if isRecording {
            enregistrement.text="Réappuyez pour arrêter l'enregistrement"
        } else {
            enregistrement.text="Appuyez pour commencer l'enregistrement"
        }
    }
    
    func checkPassword() {
        recAttempts-=1
        repeatTimes.text="Plus que \(String(recAttempts)) fois"
        if recAttempts==0 {
            nextBut.isHidden=false
            repeatTimes.isHidden=true
            enregistrement.isHidden=true
        }
    }
    
    func goBack() {
        performSegue(withIdentifier: "goBackToStartSegue", sender: self)
    }
    func goForw() {
        if recAttempts==0{
            self.performSegue(withIdentifier: "recDone", sender: nil)
        }
    }
    
    
    //MARK: View funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
        nextBut.layer.borderWidth=1
        nextBut.layer.borderColor=UIColor.lightGray.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goBack), name: NSNotification.Name(rawValue: "RETOUR"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goForw), name: NSNotification.Name(rawValue: "SUIVANT"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkPassword), name: NSNotification.Name(rawValue: "VOICE_AUTH"), object: nil)
        enregistrement.adjustsFontSizeToFitWidth=true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
