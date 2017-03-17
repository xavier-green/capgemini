//
//  SetNickViewController.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 20/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class SetNickViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlet
    @IBOutlet weak var nickText: UITextField!
    @IBOutlet weak var validation: UILabel!
    
    @IBOutlet weak var nextBut: UIButton!
    
    var allUsernames = [String]()
    
    //MARK: View Funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goBack), name: NSNotification.Name(rawValue: "RETOUR"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goForw), name: NSNotification.Name(rawValue: "SUIVANT"), object: nil)

        // Do any additional setup after loading the view.
        nickText.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        assignbackground()
        
        DispatchQueue.global(qos: .background).async {
            print("Running nuance fetch in background thread")
            let capUsers = CotoBackMethods().getUsersNames()[0]
            DispatchQueue.main.async {
                print("back to main")
                self.allUsernames = (capUsers as! [String])
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goForw() {
        if allUsernames.count>0 {
        if (!isValidName(testStr: nickText.text!) || (!isAvailableUsername(username: nickText.text!, allUsernames: self.allUsernames))) {
            print("nope")
            validation.isHidden=false
        } else {
            GlobalVariables.username = nickText.text!
            performSegue(withIdentifier: "gotoVoiceSegue", sender: self)
        }
        } else {print("nope")}
    }
    func goBack() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! UINavigationController
        self.present(controller, animated: false, completion: nil)
    }
    

    //MARK: Input Text
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        nickText.text = textField.text
        if !isValidName(testStr: nickText.text!) {
            validation.isHidden=false
            validation.text = "Lettres et chiffres uniquement"
        } else {
            if !isAvailableUsername(username: nickText.text!, allUsernames: self.allUsernames) {
                validation.isHidden=false
                validation.text = "Le pseudo est déjà utilisé"
            } else {
                validation.isHidden=true
            }
        }
    }
    
    //MARK: Change View
    
    //Return button
    @IBAction func backtoDate(_ sender: UIButton) {
        goBack()
    }
    
    //End Button
    @IBAction func done(_ sender: UIButton) {
        goForw()
    }

}
