//
//  LoginCheckViewController.swift
//  Capgemini
//
//  Created by xavier green on 20/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class LoginCheckViewController: UIViewController {
    
    @IBAction func GotoLogin(_ sender: Any) {
        performSegue(withIdentifier: "BackToLogin", sender: nil)
    }
    @IBAction func GotoDate(_ sender: Any) {
        performSegue(withIdentifier: "LoginDate", sender: nil)
    }
    
    @IBOutlet var YesButton: UIButton!
    @IBOutlet var NoButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        YesButton.layer.cornerRadius = 10
        NoButton.layer.cornerRadius = 10
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
