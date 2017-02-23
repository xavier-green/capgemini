//
//  SetDateViewController.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 20/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class SetDateViewController: UIViewController {
    
    @IBOutlet weak var nextBut: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        assignbackground()
        nextBut.layer.borderWidth=1
        nextBut.layer.borderColor=UIColor.lightGray.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Segue
    @IBAction func setDate(_ sender: UIButton) {
        performSegue(withIdentifier: "choseDate", sender: nil)
    }
}
