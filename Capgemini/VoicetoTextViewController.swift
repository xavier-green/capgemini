//
//  VoicetoTextViewController.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 13/03/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class VoicetoTextViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var speakingUsername = ""
    
    private var namesInOrder = [String]()
    private var phrasesInOrder = [String]()

    @IBOutlet weak var usernames: UITableView!
    @IBOutlet weak var recordedText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.processResult), name: NSNotification.Name(rawValue: "PIEUVRE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.processName), name: NSNotification.Name(rawValue: "PIEUVRE_NAME"), object: nil)
        // Do any additional setup after loading the view.
        usernames.delegate=self
        usernames.dataSource=self
        print(GlobalVariables.pieuvreUsernames)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalVariables.pieuvreUsernames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? nameCell
        let currentUsername = GlobalVariables.pieuvreUsernames[indexPath.row]
        cell?.nameLabel.text = currentUsername
        if (currentUsername == self.speakingUsername) {
            cell?.layer.borderWidth = 1
            cell?.layer.borderColor = UIColor.blue.cgColor
        } else {
            cell?.layer.borderWidth = 0
        }
        return cell!
    }
    func processName(notification: NSNotification) {
        
        print("got name")
        let result = notification.object as! String
        namesInOrder.append(result)
        self.speakingUsername = result
        recordedText.text = ""
        usernames.beginUpdates()
        let indexPosition = GlobalVariables.pieuvreUsernames.index(of: result)
        usernames.moveRow(at: NSIndexPath(row: indexPosition!, section: 0) as IndexPath, to: NSIndexPath(row: 0, section: 0) as IndexPath)
        GlobalVariables.pieuvreUsernames.insert(GlobalVariables.pieuvreUsernames.remove(at: indexPosition!), at: 0)
        usernames.endUpdates()
        usernames.reloadData()
    }
    
    func processResult(notification: NSNotification) {
        
        print("got phrase")
        
        let result = notification.object as! String
        phrasesInOrder.append(result)
        recordedText.text = recordedText.text + result
        
    }
    @IBAction func showResultingText(_ sender: Any) {
        GlobalVariables.namesInOrder = self.namesInOrder
        GlobalVariables.phrasesInOrder = self.phrasesInOrder
        print(namesInOrder)
        print("*******")
        print(phrasesInOrder)
        performSegue(withIdentifier: "showTexteSegue", sender: self)
    }
}

class nameCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}
