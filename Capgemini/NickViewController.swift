//
//  NickViewController.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 21/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class NickViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nickName: UITextField!
    @IBOutlet var usernamePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernamePicker.delegate = self
        self.usernamePicker.dataSource = self
        nickName.delegate=self
        
        //hide keyboard when background is pressed
        self.hideKeyboardWhenTappedAround()
        assignbackground()
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
        GlobalVariables.username = GlobalVariables.usernames[row]
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
        GlobalVariables.username = textField.text!
    }
    
    @IBAction func gotoHome(_ sender: Any) {
        print("Moving to home storyboard")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }

}
