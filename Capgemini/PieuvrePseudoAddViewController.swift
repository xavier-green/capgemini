//
//  PieuvrePseudoAddViewController.swift
//  Capgemini
//
//  Created by xavier green on 13/03/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class PieuvrePseudoAddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let testUsernames = [String]()
    
    @IBOutlet var usernamesView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        usernamesView.delegate=self
        usernamesView.dataSource=self
    }
    
    //MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testUsernames.count
    }
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let Name = self.testUsernames[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "pseudoCell",
                                                 for: indexPath) as! PieuvrePseudoCell
        cell.username?.text = Name
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

class PieuvrePseudoCell: UITableViewCell {
    @IBOutlet var username: UILabel!
}
