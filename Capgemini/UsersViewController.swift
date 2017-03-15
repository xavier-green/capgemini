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
    
    var userNames: [String] = ["Chargement"]
    var userAuths: [Int] = [-1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        assignbackground()
        
        getAllUsers()
        
//        DispatchQueue.global(qos: .background).async {
//            print("Running nuance fetch in background thread")
//            let capUsers = CotoBackMethods().getUsersNames()
//            DispatchQueue.main.async {
//                print("back to main")
//                self.userNames = (capUsers[0] as! [String])
//                self.userAuths = (capUsers[1] as! [Int])
//                self.tableView.reloadData()
//            }
//        }
        
    }
    
    func getAllUsers() {
        getUser(position: 0)
    }
    
    func getUser(position: Int){
        DispatchQueue.global(qos: .background).async {
            print("getting user ",position)
            let capUsers = CotoBackMethods().getTopUsersName(position: position)
            print(capUsers[0])
            print(capUsers[1])
            DispatchQueue.main.async {
                if (capUsers[0].count>0) {
                    print("adding data to table")
                    let usernames = capUsers[0] as! [String]
                    let userauths = capUsers[1] as! [Int]
                    self.updateList(position: position, usernames: usernames, userauths: userauths)
                } else {
                    self.tableView.beginUpdates()
                    self.userNames.remove(at: 0)
                    self.userAuths.remove(at: 0)
                    self.tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    self.tableView.endUpdates()
                }
            }
        }
    }
    
    func updateList(position: Int, usernames: [String], userauths: [Int]) {
        var gotPosition = position
        print("now just appending to the end")
        self.tableView.beginUpdates()
        self.userNames.append(usernames[0])
        self.userAuths.append(userauths[0])
        self.tableView.insertRows(at: [IndexPath(row: self.userNames.count-1, section: 0)], with: .automatic)
        self.tableView.endUpdates()
        gotPosition += 1
        self.getUser(position: gotPosition)
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
        if (row == 0 && userAuths[0]==(-1)) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell",
                                                     for: indexPath)
            return cell
        } else {
            let Name = userNames[row]
            let Score = userAuths[row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell",
                                                     for: indexPath) as! UserTableCell
            cell.userName?.text = Name
            if (Score != (-1)) {
                cell.userDrawings?.text = String(Score)
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0 && userAuths[0]==(-1)) {
            return 40
        }
        return 94
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
