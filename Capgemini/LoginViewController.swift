//
//  LoginViewController.swift
//  Capgemini
//
//  Created by xavier green on 20/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var nickName: String = "Non renseigné"
    
    @IBAction func GotoLoginCheck(_ sender: Any) {
        performSegue(withIdentifier: "LoginCheckSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController=segue.destination as? LoginCheckViewController {
            viewController.nickName = nickName
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
