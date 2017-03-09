//
//  LoginCheckViewController.swift
//  Capgemini
//
//  Created by xavier green on 20/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class LoginCheckViewController: UIViewController {
    
    var nickName: String = GlobalVariables.username
    
    @IBOutlet var helloCheckLabel: UITextView!
    @IBOutlet var YesButton: UIButton!
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func GotoDate(_ sender: Any) {
        gotodate()
    }
    
    func gotodate() {
        performSegue(withIdentifier: "LoginDate", sender: nil)
    }
    
    func gotoError() {
        print("going to error segue")
        performSegue(withIdentifier: "gotoErrorSegue", sender: self)
    }
    
    @IBOutlet var NoButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        YesButton.layer.borderWidth = 1
        YesButton.layer.borderColor = UIColor.lightGray.cgColor
        NoButton.layer.borderWidth = 0
        self.NoButton.addTarget(self, action: #selector(self.gotoError), for: .touchUpInside)
        NoButton.titleLabel?.adjustsFontSizeToFitWidth=true
        helloCheckLabel.text = "Êtes vous bien "+nickName+" ?"
        assignbackground()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goback), name: NSNotification.Name(rawValue: "RETOUR"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.gotodate), name: NSNotification.Name(rawValue: "OUI"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goHack), name: NSNotification.Name(rawValue: "NON"), object: nil)
    }
    @IBAction func goBack(_ sender: Any) {
        goback()
    }
    func goback() {
        dismiss(animated: true, completion: nil)
    }
    func goHack() {
        performSegue(withIdentifier: "gotoHackSegue", sender: self)
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
