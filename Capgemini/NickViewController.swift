//
//  NickViewController.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 21/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class NickViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var YesBut: UIButton!
    @IBOutlet weak var nickName: UITextField!
    @IBOutlet var usernamePicker: UIPickerView!
    @IBOutlet var validation: UILabel!
    
    var nickname: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernamePicker.delegate = self
        self.usernamePicker.dataSource = self
        nickName.delegate=self
        
        YesBut.addTarget(self, action: #selector(self.goForw), for: .touchUpInside)
        
        nickName.layer.borderWidth = 1
        nickName.layer.borderColor = UIColor.lightGray.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.gotoHome), name: NSNotification.Name(rawValue: "RETOUR"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goForw), name: NSNotification.Name(rawValue: "SUIVANT"), object: nil)
        
        //hide keyboard when background is pressed
        self.hideKeyboardWhenTappedAround()
        assignbackground()
        if GlobalVariables.usernames.count>0 {
            nickname = GlobalVariables.usernames[0]
        } else {
            nickname = "empty nickname"
        }
        CotoBackMethods().getUsersNames()

    }
    
//    func gotoAuthentication() {
//        if isValidUsername(username: nickname!) {
//            performSegue(withIdentifier: "authenticationSegue", sender: self)
//        }
//    }
    
    func goForw() {
        if (!isValidName(testStr: nickname!) || (!isValidUsername(username: nickname!))) {
            print("nope")
            validation.isHidden=false
        } else {
            print("setting global username to : ",nickname)
            GlobalVariables.username = nickname!
            performSegue(withIdentifier: "authenticationSegue", sender: self)
        }
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GlobalVariables.usernames.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        nickname = GlobalVariables.usernames[row]
        return GlobalVariables.usernames[row]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        nickname = textField.text!
        if !isValidName(testStr: nickname!) {
            validation.isHidden=false
            validation.text = "Lettres et chiffres uniquement"
        } else {
            if !isValidUsername(username: nickname!) {
                validation.isHidden=false
                validation.text = "Le pseudo n'existe pas"
            } else {
                validation.isHidden=true
            }
        }
        print("new nickname: ",nickname)
    }
    
    func gotohome() {
        print("Moving to home storyboard")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func gotoHome(_ sender: Any) {
        gotohome()
    }

}
