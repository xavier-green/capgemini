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
    func isValidName(testStr:String) -> Bool {
        let nameRegEx = "[A-Za-z0-9]+"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: testStr)
    }
    @IBOutlet weak var nextBut: UIButton!
    
    //MARK: View Funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goBack), name: NSNotification.Name(rawValue: "RETOUR"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goForw), name: NSNotification.Name(rawValue: "TERMINER"), object: nil)

        // Do any additional setup after loading the view.
        nickText.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        assignbackground()
        nextBut.layer.borderWidth=1
        nextBut.layer.borderColor=UIColor.lightGray.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goForw() {
        if !isValidName(testStr: nickText.text!) {
            print("nope")
            validation.isHidden=false
        } else {
            GlobalVariables.usernames.append(nickText.text!)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! UINavigationController
            self.present(controller, animated: true, completion: nil)
        }
    }
    func goBack() {
        performSegue(withIdentifier: "backtoDate", sender: self)
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
        goForw()
    }

}
