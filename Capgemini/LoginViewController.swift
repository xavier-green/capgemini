//
//  LoginViewController.swift
//  Capgemini
//
//  Created by xavier green on 20/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var success: CustomButtons!
    
    func successRecording() {
        
        // create the alert
        let alert = UIAlertController(title: "Authentification réussie", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            action in self.success.isHidden = false
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    func failureRecording() {
        let alert = UIAlertController(title: "Authentification échouée", message: "Recommencez si vous êtes vraiment qui vous prétendez être", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.success.addTarget(self, action: #selector(self.goForw), for: .touchDown)
        assignbackground()
        NotificationCenter.default.addObserver(self, selector: #selector(self.goBack), name: NSNotification.Name(rawValue: "RETOUR"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goForw), name: NSNotification.Name(rawValue: "SUIVANT"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.successFunc), name: NSNotification.Name(rawValue: "VOICE_AUTH"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.failFunc), name: NSNotification.Name(rawValue: "DEFAULT"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.successRecording), name: NSNotification.Name(rawValue: "REC_SUCCESS"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.failureRecording), name: NSNotification.Name(rawValue: "REC_FAIL"), object: nil)
    }
    
    func goBack() {
        performSegue(withIdentifier: "backToNicknameSegue", sender: self)
    }
    func goForw() {
        performSegue(withIdentifier: "loginCheckSegue", sender: self)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
