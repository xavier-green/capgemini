//
//  LoginViewController.swift
//  Capgemini
//
//  Created by xavier green on 20/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var NextBut: UIButton!
    
    func nexView() {
        print("Moving to next storyboard")
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "LoginCheckViewController") as UIViewController!
        self.present(nextViewController!, animated:true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.NextBut.addTarget(self, action: #selector(self.nexView), for: .touchUpInside)
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
