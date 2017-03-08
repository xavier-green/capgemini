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

    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    //MARK: Outlets
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var repeatTimes: UILabel!
    @IBOutlet var recordButton: NuanceButtonClass!
    
//    func showAlert() {
//        
//        // create the alert
//        let alert = UIAlertController(title: "Erreur d'enregistrement", message: "L'enregistrement n'est pas assez clair. Recommencez s'il-vous plaît.", preferredStyle: UIAlertControllerStyle.alert)
//        
//        // add an action (button)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//        
//        // show the alert
//        self.present(alert, animated: true, completion: nil)
//    }
    
//    func changeText() {
//        isRecording = !isRecording
//        if isRecording {
//            enregistrement.text="Relachez pour arrêter l'enregistrement"
//        } else {
//            enregistrement.text="Maintenez pour enregistrer"
//        }
//    }
    
    func reduceTimes() {
        self.stopRec()
        self.recAttempts -= 1
        self.repeatTimes.text="Plus que \(String(recAttempts)) fois"
    }
    
    func successEnrolment() {
        self.recordButton.isHidden=true
        repeatTimes.text=""
        // create the alert
        let alert = UIAlertController(title: "Enrollement vocal réussi", message: "Passez à l'étape suivante", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            action in self.goForw()
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    func successRecording() {
        
        // create the alert
        let alert = UIAlertController(title: "Enregistrement vocal réussi", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            action in self.reduceTimes();
            CotoBackMethods().enrAttempt();
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    func failureRecording() {
        let alert = UIAlertController(title: "Enregistrement échoué", message: "Veuillez recommencer", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            action in self.stopRec();
            CotoBackMethods().enrAttempt();
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func goBack() {
        performSegue(withIdentifier: "goBackToStartSegue", sender: self)
    }
    func goForw() {
        self.stopRec()
        self.performSegue(withIdentifier: "recDone", sender: nil)
    }
    
    func startRecording() {
        print("start recording, showing spinner")
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    func stopRec() {
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
    }
    
    
    //MARK: View funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
        
        self.spinner.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goBack), name: NSNotification.Name(rawValue: "RETOUR"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goForw), name: NSNotification.Name(rawValue: "SUIVANT"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.checkPassword), name: NSNotification.Name(rawValue: "VOICE_AUTH"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.showAlert), name: NSNotification.Name(rawValue: "DEFAULT"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.successEnrolment), name: NSNotification.Name(rawValue: "SUCCESS"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.successRecording), name: NSNotification.Name(rawValue: "REC_SUCCESS"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.failureRecording), name: NSNotification.Name(rawValue: "REC_FAIL"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.startRecording), name: NSNotification.Name(rawValue: "NUANCE_PROCESSING"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.failureRecording), name: NSNotification.Name(rawValue: "ENROLL_ERROR"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
