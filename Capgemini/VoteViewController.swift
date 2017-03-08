//
//  VoteViewController.swift
//  Capgemini
//
//  Created by xavier green on 22/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class VoteViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var continuerButton: UIButton!
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet var imagesView: UICollectionView!
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items: [String] = []
    var imagesIds: [Int] = []
    var imageDrawer = [String]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ImageCollectionViewCell
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        let dataDecoded = NSData(base64Encoded: items[indexPath.item], options: NSData.Base64DecodingOptions.init(rawValue: 0))
        
        //print(dataDecoded ?? "no data")
        
        if (dataDecoded != nil) {
            let cellImage = UIImage(data: dataDecoded as! Data)
            cell.image.image = cellImage
        }
        cell.nickName.text = imageDrawer[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("selected ",indexPath.item)
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        continuerButton.isHidden = false
        for i in 0...self.items.count {
            let index = IndexPath(item: i, section: 0)
            let cell = collectionView.cellForItem(at: index)
            cell?.layer.borderColor = UIColor.black.cgColor
        }
        let imageVoteIndex = indexPath.item
        GlobalVariables.base64image = self.items[imageVoteIndex]
        GlobalVariables.voteImageId = self.imagesIds[imageVoteIndex]
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.green.cgColor
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        print("unselected")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        continuerButton.isHidden = true
        continuerButton.layer.borderWidth = 1
        continuerButton.layer.borderColor = UIColor.lightGray.cgColor
        continuerButton.addTarget(self, action: #selector(self.finir), for: .touchUpInside)
        // Do any additional setup after loading the view.
        assignbackground()
        NotificationCenter.default.addObserver(self, selector: #selector(self.appendImages), name: NSNotification.Name(rawValue: "FINISHED_GETTING_IMAGES"), object: nil)
        CotoBackMethods().getImages()
    }
    
    func appendImages(notification: NSNotification) {
        print("front received images")
        let receivedImagesObject = notification.object as! [[AnyObject]]
        let receivedImages = receivedImagesObject[0] as! [String]
        var finalImagesCleaned: [String] = []
        for image in receivedImages {
            finalImagesCleaned.append(image.replacingOccurrences(of: " ", with: "+"))
        }
        self.items = finalImagesCleaned
        self.imagesIds = receivedImagesObject[1] as! [Int]
        self.imageDrawer = receivedImagesObject[2] as! [String]
        print("got ",self.items.count," images from back")
        print("got ",self.imagesIds.count," _id from back")
        self.imagesView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func finir() {
        performSegue(withIdentifier: "finishedVotingSegue", sender: self)
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
