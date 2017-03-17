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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var nickname: String = ""
    var pickerName: String!
    
    var capUsernames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernamePicker.delegate = self
        self.usernamePicker.dataSource = self
        nickName.delegate=self
        
        self.spinner.isHidden = true
        
        YesBut.addTarget(self, action: #selector(self.goForw), for: .touchUpInside)
        
        nickName.layer.borderWidth = 1
        nickName.layer.borderColor = UIColor.lightGray.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.gotoHome), name: NSNotification.Name(rawValue: "RETOUR"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goForw), name: NSNotification.Name(rawValue: "SUIVANT"), object: nil)
        
        DispatchQueue.global(qos: .background).async {
            print("Running nuance fetch in background thread")
            self.startSpinner()
            var capUsers = CotoBackMethods().getUsersNames()[0] as! [String]
            capUsers = capUsers.sorted{$0.localizedCompare($1) == .orderedAscending}
            DispatchQueue.main.async {
                print("back to main")
                self.capUsernames = capUsers
                self.usernamePicker.reloadAllComponents()
                if self.capUsernames.count>0 {
                    self.pickerName = self.capUsernames[0]
                } else {
                    self.pickerName = "empty nickname"
                }
                self.stopSpinner()
            }
        }
        
        //hide keyboard when background is pressed
        self.hideKeyboardWhenTappedAround()
        assignbackground()
        //CotoBackMethods().getUsersNames()

    }
    
//    func gotoAuthentication() {
//        if isValidUsername(username: nickname!) {
//            performSegue(withIdentifier: "authenticationSegue", sender: self)
//        }
//    }
    
    func goForw() {
        nickName.resignFirstResponder()
        if capUsernames.count>0 {
            if nickname=="" {
                GlobalVariables.username = pickerName!
                print("setting global username to : ",pickerName)
            } else {
                GlobalVariables.username = nickname
                print("setting global username to : ",nickname)
            }
            if !isValidUsername(username: GlobalVariables.username, allUsernames: self.capUsernames) {
                print("nope")
                validation.isHidden=false
            } else {
                performSegue(withIdentifier: "authenticationSegue", sender: self)
            }
        } else {print("nope")}
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return capUsernames.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerName = capUsernames[row]
        return pickerName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if capUsernames.count > 0 {
        pickerName = capUsernames[row]
        print("new picker name: ",pickerName)
        } else {
            pickerName = "None"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func startSpinner() {
        print("start recording, showing spinner")
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    func stopSpinner() {
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
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
        if !isValidName(testStr: nickname) {
            validation.isHidden=false
            validation.text = "Lettres et chiffres uniquement"
        } else {
            if !isValidUsername(username: nickname, allUsernames: self.capUsernames) {
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
