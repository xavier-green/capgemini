//
//  LoginViewController.swift
//  Capgemini
//
//  Created by xavier green on 20/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var suivant: UIButton!
    
    @IBOutlet var success: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
        NotificationCenter.default.addObserver(self, selector: #selector(self.goBack), name: NSNotification.Name(rawValue: "RETOUR"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goForw), name: NSNotification.Name(rawValue: "SUIVANT"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.successFunc), name: NSNotification.Name(rawValue: "VOICE_AUTH"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.failFunc), name: NSNotification.Name(rawValue: "DEFAULT"), object: nil)
    }
    
    func goBack() {
        performSegue(withIdentifier: "backToNicknameSegue", sender: self)
    }
    func goForw() {
        performSegue(withIdentifier: "loginCheckSegue", sender: self)
    }
    func successFunc() {
        // create the alert
        let alert = UIAlertController(title: "Authentification Réussie", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        success.isHidden=false
        
    }
    func failFunc() {
        // create the alert
        let alert = UIAlertController(title: "Authentification Echouée", message: "Recommencez si vous êtes vraiment qui vous prétendez être", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
