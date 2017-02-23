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

    @IBOutlet var descField: UITextView!
    @IBOutlet weak var nickText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        nickText.delegate=self
        descField.text = "Vous êtes arrivés à hacker "+nickName+". Rentrez votre vrai pseudo :"
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        assignbackground()
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
