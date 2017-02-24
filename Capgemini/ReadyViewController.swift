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
    @IBOutlet weak var nextBut: UIButton!
    //MARK: View Funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.backHome), name: NSNotification.Name(rawValue: "RETOUR"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.nextView), name: NSNotification.Name(rawValue: "SUIVANT"), object: nil)

        // Do any additional setup after loading the view.
        assignbackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextView() {
        performSegue(withIdentifier: "recordVoiceSegue", sender: self)
    }
    
    //MARK: Actions
    
    //Back button
    @IBAction func backHome(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! UINavigationController
        self.present(controller, animated: false, completion: nil)
    }
}
