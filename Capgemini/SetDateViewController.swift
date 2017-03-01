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
        
        self.nextBut.addTarget(self, action: #selector(self.goForw), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goBack), name: NSNotification.Name(rawValue: "RETOUR"), object: nil)
        
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
        // create the alert
        let alert = UIAlertController(title: "Enrôlement terminé", message: "Veuillez procéder à l'authentification.", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in self.gotoHome()}))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    func goForw() {
        CotoBackMethods().addUser(speakerId: GlobalVariables.username, memDate: secretDate)
        success()
    }
    func gotoHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! UINavigationController
        self.present(controller, animated: false, completion: nil)
    }
    
    func goBack() {
        performSegue(withIdentifier: "goBackToVoiceRecordSegue", sender: self)
    }
<<<<<<< HEAD
    
    func datePickerChanged() {
        secretDate = setDateFormat().string(from: self.datePicker.date)
    }
    
    func setDateFormat() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        return dateFormatter
    }
    

    //MARK: Segue
    @IBAction func setDate(_ sender: UIButton) {
        performSegue(withIdentifier: "choseDate", sender: nil)
    }
=======
>>>>>>> 12f99e8e8f5c930a4cb0e0f08fa38c453ab076c1
}
