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
    
    @IBOutlet var success: UIImageView!
    
    let okImage = UIImage(named: "valid")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
        NotificationCenter.default.addObserver(self, selector: #selector(self.goBack), name: NSNotification.Name(rawValue: "RETOUR"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goForw), name: NSNotification.Name(rawValue: "SUIVANT"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.successFunc), name: NSNotification.Name(rawValue: "VOICE_AUTH"), object: nil)
    }
    
    func goBack() {
        performSegue(withIdentifier: "backToNicknameSegue", sender: self)
    }
    func goForw() {
        performSegue(withIdentifier: "loginCheckSegue", sender: self)
    }
    func successFunc() {
        self.success.image = okImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
