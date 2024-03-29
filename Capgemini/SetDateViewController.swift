//
//  SetDateViewController.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 20/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class SetDateViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    private var secretDate: String!
    @IBAction func finishButton(_ sender: CustomButtons) {
        goForw()
    }
    @IBOutlet weak var nextBut: UIButton!
    @IBOutlet weak var noticeText: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.spinner.isHidden=true
        
        self.datePicker.addTarget(self, action: #selector(self.datePickerChanged), for: UIControlEvents.valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goForw), name: NSNotification.Name(rawValue: "TERMINER"), object: nil)

        // Do any additional setup after loading the view.
        assignbackground()
        noticeText.adjustsFontForContentSizeCategory=true
        secretDate = setDateFormat().string(from: self.datePicker.date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Called when got a "TERMINER" notification from SpeechRecognition, finished login and goes back to home screen (initial one)
    func success() {
        let alert = UIAlertController(title: "Enrôlement terminé", message: "Veuillez procéder à l'authentification.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in self.gotoHome()}))
        topMostController().present(alert, animated: true, completion: nil)
    }

    //Asynchronous adding of user to the database before moving to success function
    func goForw() {
        DispatchQueue.global(qos: .background).async {
            self.spinner.startSpinner()
            _ = CotoBackMethods().addUser(speakerId: GlobalVariables.username, memDate: self.secretDate)
            DispatchQueue.main.async {
                print("back to main")
                self.success()
                self.spinner.stopSpinner()
            }
        }
    }
    func gotoHome() {
        bottomMostController().dismiss(animated: true, completion: nil)
    }
    
    func datePickerChanged() {
        secretDate = setDateFormat().string(from: self.datePicker.date)
    }
    
    func setDateFormat() -> DateFormatter {
        let gbDateFormat = DateFormatter.dateFormat(fromTemplate: "MMddyyyy", options: 0, locale: NSLocale(localeIdentifier: "en-GB") as Locale)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = gbDateFormat
        return dateFormatter
    }

}
