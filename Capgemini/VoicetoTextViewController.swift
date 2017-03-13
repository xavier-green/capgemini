//
//  VoicetoTextViewController.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 13/03/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class VoicetoTextViewController: UIViewController {

    @IBOutlet weak var recordedText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? nameCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        cell.nameLabel.text = GlobalVariables.pieuvreUsernames[indexPath.row]
        return cell
    }

}

class nameCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}
