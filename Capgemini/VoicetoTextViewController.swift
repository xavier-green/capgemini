//
//  VoicetoTextViewController.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 13/03/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class VoicetoTextViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
        cell?.nameLabel.text = GlobalVariables.pieuvreUsernames[indexPath.row]
        return cell!
    }
    func processName(notification: NSNotification) {
        
        print("got name")
        recordedText.text = ""
        let result = notification.object as! String
        recordedText.text = result+" : "+recordedText.text
        
    }
    
    func processResult(notification: NSNotification) {
        
        print("got phrase")
        
        let result = notification.object as! String
        recordedText.text = ""
        recordedText.text = recordedText.text + result
        
    }
}

class nameCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}
