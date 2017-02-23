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
    
    @IBOutlet var YesButton: UIView!
    @IBOutlet var helloCheckLabel: UILabel!

    @IBAction func GotoDate(_ sender: Any) {
        performSegue(withIdentifier: "LoginDate", sender: nil)
    }
    
    @IBOutlet var NoButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        YesButton.layer.borderWidth = 1
        YesButton.layer.borderColor = UIColor.lightGray.cgColor
        NoButton.layer.cornerRadius = 10
        helloCheckLabel.text = "Êtes vous bien "+nickName+" ?"
        assignbackground()
    }
    @IBAction func goBack(_ sender: Any) {
        performSegue(withIdentifier: "BackToLogin", sender: nil)
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
