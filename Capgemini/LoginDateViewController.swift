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
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func verifyUser() {
        DispatchQueue.global(qos: .background).async {
            print("Running nuance fetch in background thread")
            let verified = CotoBackMethods().verifyUser(speakerId: GlobalVariables.username, memDate: self.secretDate)
            DispatchQueue.main.async {
                print("back to main")
                if verified==true {
                    self.performSegue(withIdentifier: "checkDate", sender: self)
                } else {
                    let alert = UIAlertController(title: "Date Erronée", message: "La date que vous avez rentré n'est pas la bonne", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.topMostController().present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.addTarget(self, action: #selector(self.datePickerChanged), for: UIControlEvents.valueChanged)
        assignbackground()
        secretDate = setDateFormat().string(from: self.datePicker.date)
        print("sending okay login notif")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LOGIN_SUCCESS"), object: self)
    }
    
    @IBAction func nextButton(_ sender: CustomButtons) {
        verifyUser()
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
        let gbDateFormat = DateFormatter.dateFormat(fromTemplate: "MMddyyyy", options: 0, locale: NSLocale(localeIdentifier: "en-GB") as Locale)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = gbDateFormat
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
