//
//  LoginDateViewController.swift
//  Capgemini
//
//  Created by xavier green on 20/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class LoginDateViewController: UIViewController {
    
    @IBOutlet var datePicker: UIDatePicker!
    private var secretDate: String!
    private var authorized: Bool!

    func verifyUser() {
        CotoBackMethods().verifyUser(speakerId: GlobalVariables.username, memDate: secretDate)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.addTarget(self, action: #selector(self.datePickerChanged), for: UIControlEvents.valueChanged)
        assignbackground()
        secretDate = setDateFormat().string(from: self.datePicker.date)
        NotificationCenter.default.addObserver(self, selector: #selector(self.verifyUserDone), name: NSNotification.Name(rawValue: "VERIFIED_USER"), object: nil)
    }
    
    @objc func verifyUserDone(notifcation: NSNotification) {
        self.authorized = notifcation.object as! Bool!
    }
    @IBAction func nextButton(_ sender: CustomButtons) {
        verifyUser()
        if (self.authorized==true) {
            performSegue(withIdentifier: "checkDate", sender: self)
        } else {
            // create the alert
            let alert = UIAlertController(title: "Date Erronée", message: "La date que vous avez rentré n'est pas la bonne", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func goback() {
        performSegue(withIdentifier: "backToCheckSegue", sender: self)
    }
    
    func datePickerChanged() {
        secretDate = setDateFormat().string(from: self.datePicker.date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setDateFormat() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        return dateFormatter
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
