//
//  UsersViewController.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 22/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var userNames = [String]()
    var userAuths = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        assignbackground()
        
        DispatchQueue.global(qos: .background).async {
            print("Running nuance fetch in background thread")
            let capUsers = CotoBackMethods().getUsersNames()
            DispatchQueue.main.async {
                print("back to main")
                self.userNames = (capUsers[0] as! [String])
                self.userAuths = (capUsers[1] as! [Int])
                self.tableView.reloadData()
            }
        }
        
    }
    
    func getAllUsers() {
        getUser(position: 0)
    }
    
    func getUser(position: Int){
        var gotPosition = position
        DispatchQueue.global(qos: .background).async {
            print("getting user ",position)
            let capUsers = CotoBackMethods().getTopUsersName(position: position)
            DispatchQueue.main.async {
                print("adding to table")
                self.tableView.beginUpdates()
                let usernames = capUsers[0] as! [String]
                let userauths = capUsers[1] as! [Int]
                self.userNames.append(usernames[0])
                self.userAuths.append(userauths[0])
                self.tableView.insertRows(at: [IndexPath(row: self.userNames.count-1, section: 0)], with: .automatic)
                self.tableView.endUpdates()
                gotPosition += 1
                if (gotPosition<50) {
                    self.getUser(position: gotPosition)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let Name = userNames[row]
        let Score = userAuths[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell",
                                                 for: indexPath) as! UserTableCell
        cell.userName?.text = Name
        cell.userDrawings?.text = String(Score)
        //cell.userImage.image = UIImage(named: "question")
        return cell
    }

    @IBAction func goToGame(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "App", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DrawNavigationViewController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
}

// Cell Class

class UserTableCell:UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userDrawings: UILabel!
    
}
