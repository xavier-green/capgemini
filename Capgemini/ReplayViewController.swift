//
//  ReplayViewController.swift
//  Capgemini
//
//  Created by xavier green on 23/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class ReplayViewController: UIViewController {

    @IBOutlet var selectedImageView: UIImageView!
    
    @IBAction func replay(_ sender: Any) {
        goBacktohomefromApp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CotoBackMethods().voteForImage()
        
        let selectedImage = GlobalVariables.base64image
        
        let dataDecoded = NSData(base64Encoded: selectedImage, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        
        let cellImage = UIImage(data: dataDecoded as! Data)
        self.selectedImageView.image = cellImage
        
        // Do any additional setup after loading the view.
        assignbackground()
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
