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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.addTarget(self, action: #selector(self.datePickerChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        secretDate = dateFormatter.string(from: self.datePicker.date)
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

}
