//
//  LeaderBoardViewController.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 22/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class LeaderBoardViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var imageData: [String] = []
    var userData: [String] = []
    var votesData: [Int] = []

    @IBAction func backbutton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate=self
        tableView.dataSource=self
        
        getTopLeaders()
        
        assignbackground()
    }
    
    func getTopLeaders() {
        getLeader(position: 0)
    }
    
    func getLeader(position: Int){
        var gotPosition = position
        DispatchQueue.global(qos: .background).async {
            print("getting leader ",position)
            let receivedObject = CotoBackMethods().getTopLeadersPost(position: position)
            DispatchQueue.main.async {
                print("adding to table")
                self.tableView.beginUpdates()
                self.imageData.append(receivedObject[0][0] as! String)
                self.userData.append(receivedObject[1][0] as! String)
                self.votesData.append(receivedObject[2][0] as! Int)
                self.tableView.insertRows(at: [IndexPath(row: self.imageData.count-1, section: 0)], with: .automatic)
                self.tableView.endUpdates()
                gotPosition += 1
                if (gotPosition<25) {
                    self.getLeader(position: gotPosition)
                }
            }
        }
    }
    
    func showLeaders(notification: NSNotification) {
        print("front getting leaderboard")
        let receivedObject = notification.object as! [AnyObject]
        self.imageData = receivedObject[0] as! [String]
        self.userData = receivedObject[1] as! [String]
        self.votesData = receivedObject[2] as! [Int]
        self.tableView.reloadData()
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
        return self.imageData.count
    }
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let Name = self.userData[row]
        let Score = self.votesData[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath) as! leaderBoardCell
        cell.userName?.text = Name
        cell.userRank?.text = String(Score)
        
        let dataDecoded = NSData(base64Encoded: self.imageData[row].replacingOccurrences(of: " ", with: "+"), options: NSData.Base64DecodingOptions.init(rawValue: 0))
        
        if (dataDecoded != nil) {
            let cellImage = UIImage(data: dataDecoded as! Data)
            cell.imageV.image = cellImage
            cell.imageV.layer.borderWidth = 1
            cell.imageV.layer.borderColor = UIColor.darkGray.cgColor
        }
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class leaderBoardCell: UITableViewCell {
    @IBOutlet weak var userRank: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imageV: UIImageView!
}
