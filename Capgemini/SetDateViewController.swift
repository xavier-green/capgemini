//
//  SetDateViewController.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 20/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class SetDateViewController: UIViewController {
    
    @IBAction func finishButton(_ sender: CustomButtons) {
        goForw()
    }
    @IBOutlet weak var nextBut: UIButton!
    @IBOutlet weak var noticeText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goBack), name: NSNotification.Name(rawValue: "RETOUR"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goForw), name: NSNotification.Name(rawValue: "SUIVANT"), object: nil)

        // Do any additional setup after loading the view.
        assignbackground()
        noticeText.adjustsFontForContentSizeCategory=true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goForw() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! UINavigationController
        self.present(controller, animated: false, completion: nil)
    }
    func goBack() {
        performSegue(withIdentifier: "goBackToVoiceRecordSegue", sender: self)
    }
    

    //MARK: Segue
    @IBAction func setDate(_ sender: UIButton) {
        performSegue(withIdentifier: "choseDate", sender: nil)
    }
}
