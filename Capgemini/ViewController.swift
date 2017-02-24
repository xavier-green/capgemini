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
    @IBOutlet var AccountLabel: UITextView!
    
    @IBAction func NoButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Enrolment", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EnrolmentViewController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
    var speechToText: TextToSpeech!
    
    func nexView() {
        print("Moving to next storyboard")
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") 
        self.present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        print("started main app")
        NotificationCenter.default.addObserver(self, selector: #selector(self.nexView), name: NSNotification.Name(rawValue: "AUTHENTIFICATION"), object: nil)
        super.viewDidLoad()
        speechToText = TextToSpeech()
        
        NoBut.layer.borderWidth = 1
        NoBut.layer.borderColor = UIColor.lightGray.cgColor
        YesBut.layer.borderWidth = 1
        YesBut.layer.borderColor = UIColor.lightGray.cgColor
        YesBut.addTarget(self, action: #selector(self.nexView), for: .touchUpInside)
        
        assignbackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

