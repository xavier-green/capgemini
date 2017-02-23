//
//  LoginViewController.swift
//  Capgemini
//
//  Created by xavier green on 20/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var suivant: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        suivant.layer.borderWidth = 1
        suivant.layer.borderColor = UIColor.lightGray.cgColor
        assignbackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
