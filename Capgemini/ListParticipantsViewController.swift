//
//  ListParticipantsViewController.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 22/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class UserTableCell:UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userDrawings: UILabel!
    
}

class ListParticipantsViewController: UITableViewController {
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return GlobalVariables.usernames.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let Name = GlobalVariables.usernames[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell",
                                                 for: indexPath) as! UserTableCell
        cell.userName?.text = Name
        cell.userDrawings?.text = "5"
        //cell.userImage.image = UIImage(named: "question")
        return cell
    }
}
