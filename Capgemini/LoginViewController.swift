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
    
    @IBOutlet var userLabel: UILabel!
    private var attempts: Int = 3
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    func reduceAttempts() {
        attempts -= 1
        if attempts==0 {
            attemptsError()
        }
    }
    
    func logFail(email: String) {
        CotoBackMethods().failedToLogin(email: email)
        DispatchQueue.main.async {
            self.goBack()
        }
    }
    
    func loginFail() {
        let alert = UIAlertController(title: "Erreur", message: "Nous allons essayer de comprendre d'où vient l'erreur. Nous vous recontactons dès que possible avec une solution ! Entrez votre email pour recevoir une réponse", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {
            (textField) in
            textField.text = ""
        })
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            [weak alert] (_) in
            let email = alert?.textFields![0].text
            self.logFail(email: email!)
        }))
        alert.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default, handler: {
            action in self.goBack()
        }))
        topMostController().present(alert, animated: true, completion: nil)
    }
    
    func hackPrevented() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "HACK_ATTEMPT"), object: self)
        let alert = UIAlertController(title: "Prévention", message: "Nous avons intercepté votre tentative d'intrusion :) Veuillez maintenant réessayer avec votre propre pseudo !", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            action in self.goBack()
        }))
        topMostController().present(alert, animated: true, completion: nil)
    }
    
    func attemptsError() {
        
        let alertController = UIAlertController(title: "Erreur", message: "Vous avez raté 3 fois votre enregistrement. Essayer vous de vous authentifier à la place de quelqu'un d'autre ?", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Oui", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.hackPrevented()
        }
        let cancelAction = UIAlertAction(title: "Non", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            self.loginFail()
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        topMostController().present(alertController, animated: true, completion: nil)
    }
    
    func successRecording() {
        _ = CotoBackMethods().logAttempt();
        
        // create the alert
        let alert = UIAlertController(title: "Authentification réussie", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            action in self.goForw();
        }))
        
        // show the alert
        topMostController().present(alert, animated: true, completion: nil)
        
    }
    func failureRecording() {
        
        _ = CotoBackMethods().logAttempt();
        
        let alert = UIAlertController(title: "Authentification échouée", message: "Recommencez si vous êtes vraiment qui vous prétendez être", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            action in self.reduceAttempts();
            self.stopRec();
        }))
        
        // show the alert
        topMostController().present(alert, animated: true, completion: nil)
        
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.success.addTarget(self, action: #selector(self.goForw), for: .touchDown)
        self.spinner.isHidden = true
        assignbackground()
        NotificationCenter.default.addObserver(self, selector: #selector(self.goBack), name: NSNotification.Name(rawValue: "RETOUR"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.successRecording), name: NSNotification.Name(rawValue: "REC_SUCCESS"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.failureRecording), name: NSNotification.Name(rawValue: "REC_FAIL"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.startRecording), name: NSNotification.Name(rawValue: "NUANCE_PROCESSING"), object: nil)
        self.userLabel.text = "Utilisateur : "+GlobalVariables.username
        
    }
    
    func goBack() {
        dismiss(animated: true, completion: nil)
    }
    func goForw() {
        performSegue(withIdentifier: "loginCheckSegue", sender: self)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
