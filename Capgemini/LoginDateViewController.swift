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
    private var authorized: AnyObject!

    @IBAction func test(_ sender: UIButton) {
        CotoBackMethods().verifyUser(speakerId: GlobalVariables.username, memDate: secretDate)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.addTarget(self, action: #selector(self.datePickerChanged), for: UIControlEvents.valueChanged)
        assignbackground()
        secretDate = setDateFormat().string(from: self.datePicker.date)
        NotificationCenter.default.addObserver(self, selector: #selector(self.verifyUser), name: NSNotification.Name(rawValue: "VERIFIED_USER"), object: nil)
    }
    
    @objc func verifyUser(notifcation: NSNotification) {
        self.authorized = notifcation.object as AnyObject
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
