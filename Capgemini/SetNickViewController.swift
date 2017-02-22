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
    let nameRegEx = "[A-Z][0-9]"
    
    //MARK: View Funcs
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nickText.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Input Text
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        nickText.text = textField.text
    }
    
    //MARK: Change View
    
    //Return button
    @IBAction func backtoDate(_ sender: UIButton) {
        performSegue(withIdentifier: "backtoDate", sender: nil)
    }
    
    //End Button
    @IBAction func done(_ sender: UIButton) {
        
        GlobalVariables.usernames.append(nickText.text!)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }

}
