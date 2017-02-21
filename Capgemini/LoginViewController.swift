//
//  LoginViewController.swift
//  Capgemini
//
//  Created by xavier green on 20/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBAction func GotoLoginCheck(_ sender: Any) {
        performSegue(withIdentifier: "LoginCheckSegue", sender: nil)
    }
    @IBAction func GotoHome(_ sender: Any) {
        print("Moving to home storyboard")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
