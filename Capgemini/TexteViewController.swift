//
//  TexteViewController.swift
//  Capgemini
//
//  Created by xavier green on 13/03/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class TexteViewController: UIViewController {

    @IBOutlet var texteView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("total elements: ",GlobalVariables.phrasesInOrder.count)
        self.texteView.text = ""
        for i in 0...GlobalVariables.phrasesInOrder.count-1 {
            print("getting element i=",i)
            self.texteView.text = self.texteView.text! + GlobalVariables.namesInOrder[i]+" :\n"+GlobalVariables.phrasesInOrder[i]+"\n\n"
        }
    }
    
    @IBAction func backToRecording(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
