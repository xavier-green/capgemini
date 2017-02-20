//
//  EnrolmentViewController.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 20/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class ReadyViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var ready: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func ready(_ sender: UIButton) {
        performSegue(withIdentifier: "VoiceRec", sender: nil)
    }
}
