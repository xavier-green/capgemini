//
//  ErrorViewController.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 23/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController, UITextFieldDelegate {
    
    var nickName: String = GlobalVariables.username
    private var okay: Bool = false
    @IBOutlet var validation: UILabel!

    @IBAction func finishAction(_ sender: Any) {
        if okay==true {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ADD_HACK"), object: nickText.text)
            performSegue(withIdentifier: "backTologin", sender: self)
        }
    }
    
    @IBOutlet var descField: UITextView!
    @IBOutlet weak var nickText: UITextField!
    
    var allUsernames = [String]()
    
    override func viewDidLoad() {
        print("loading error view")
        super.viewDidLoad()
        nickText.delegate=self
        descField.text = "Vous êtes arrivés à hacker "+nickName+". Rentrez votre vrai pseudo :"
        // Do any additional setup after loading the view.
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        nickText.text = textField.text!
        if !isValidName(testStr: nickText.text!) {
            validation.isHidden=false
            validation.text = "Lettres et chiffres uniquement"
        } else {
            if !isValidUsername(username: nickText.text!, allUsernames: self.allUsernames) {
                validation.isHidden=false
                validation.text = "Le pseudo n'existe pas"
            } else {
                validation.isHidden=true
                self.okay = true
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
