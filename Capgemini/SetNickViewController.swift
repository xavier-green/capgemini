//
//  SetNickViewController.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 20/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class SetNickViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlet
    @IBOutlet weak var nickText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nickText.delegate = self
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        nickText.text = textField.text
    }
    
    @IBAction func backtoDate(_ sender: UIButton) {
        performSegue(withIdentifier: "backtoDate", sender: nil)
    }
    @IBAction func done(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! UINavigationController
        self.present(controller, animated: false, completion: nil)
    }

}
