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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func success() {
        let alert = UIAlertController(title: "Enrôlement terminé", message: "Veuillez procéder à l'authentification.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in self.gotoHome()}))
        topMostController().present(alert, animated: true, completion: nil)
    }

    func goForw() {
        DispatchQueue.global(qos: .background).async {
            _ = CotoBackMethods().addUser(speakerId: GlobalVariables.username, memDate: self.secretDate)
            DispatchQueue.main.async {
                print("back to main")
                self.success()
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
