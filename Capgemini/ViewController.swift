//
//  ViewController.swift
//  Capgemini
//
//  Created by xavier green on 17/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController {
    
    //MARK: IBActions
    @IBAction func EnrolmentButton(_ sender: CustomButtons) {
        gotoEnrolment()
    }
    @IBAction func LoginButton(_ sender: CustomButtons) {
        gotoLogin()
    }
    
    //MARK: Variables
    var speechToText: TextToSpeech!
    
    //MARK: Change Storyboard
    func gotoEnrolment() {
        let storyboard = UIStoryboard(name: "Enrolment", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EnrolmentViewController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
    func gotoLogin() {
        print("Moving to next storyboard")
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: View
    override func viewDidLoad() {
        
        print("started main app")
        NotificationCenter.default.addObserver(self, selector: #selector(self.gotoLogin), name: NSNotification.Name(rawValue: "AUTHENTIFICATION"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.gotoEnrolment), name: NSNotification.Name(rawValue: "ENROLLEMENT"), object: nil)
        super.viewDidLoad()
        
        speechToText = TextToSpeech()
        
        assignbackground()
        testInternetConnection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

