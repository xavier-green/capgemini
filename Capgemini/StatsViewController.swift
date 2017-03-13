//
//  StatsViewController.swift
//  Capgemini
//
//  Created by xavier green on 13/03/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    
    private var independentUsers = [String]()
    private var usersCount = [Double]()
    private var totalCount: Double = 0
    
    @IBOutlet var statsView: UITextView!

    @IBAction func backToMain(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func processCounts() {
        print("wordcount: ",GlobalVariables.wordCount.count,",users: ",GlobalVariables.namesInOrder.count)
        if GlobalVariables.wordCount.count>0 {
            for i in 0...GlobalVariables.wordCount.count-1 {
                print("boucle ",i)
                let user = GlobalVariables.namesInOrder[i]
                let counts = Double(GlobalVariables.wordCount[i])
                print("user: ",user)
                if independentUsers.contains(user) {
                    let index = independentUsers.index(of: user)
                    usersCount[index!] += counts
                    print("done incrementing")
                } else {
                    print("adding use to independent user")
                    independentUsers.append(user)
                    usersCount.append(counts)
                }
                totalCount += counts
            }
            print(independentUsers)
            print(usersCount)
            self.statsView.text = ""
            print("total: ",totalCount)
            for i in 0...independentUsers.count-1 {
                let percentage = usersCount[i]/totalCount*100
                print("percentage: ",percentage)
                let str = independentUsers[i]+" : "+String(round(Double(percentage)))+"%\n"
                self.statsView.text = self.statsView.text! + str
            }
            print(GlobalVariables.words)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        processCounts()
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

}
