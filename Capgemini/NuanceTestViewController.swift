//
//  NuanceTestViewController.swift
//  Capgemini
//
//  Created by xavier green on 10/03/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class NuanceTestViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var firstSpeaker: UITextField!

    @IBOutlet var secondSpeaker: UITextField!
    
    @IBOutlet var results: UITextView!
    
    var first: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        firstSpeaker.delegate = self
        secondSpeaker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if first==true {
            GlobalVariables.speaker1 = textField.text!
            first=false
            print("new nickname for speaker 1: ",GlobalVariables.speaker1)
        } else {
            GlobalVariables.speaker2 = textField.text!
            first=true
            print("new nickname for speaker 2: ",GlobalVariables.speaker2)
        }
    }

}
