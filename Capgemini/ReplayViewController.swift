//
//  ReplayViewController.swift
//  Capgemini
//
//  Created by xavier green on 23/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class ReplayViewController: UIViewController {

    @IBAction func replay(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        assignbackground()
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
