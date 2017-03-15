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
    
    @IBOutlet var scrollLabel: UILabel!
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items: [String] = [""]
    var imagesIds: [Int] = [0]
    var imageDrawer: [String] = ["Chargement..."]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ImageCollectionViewCell
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        if (items[indexPath.item] != "") {
            let dataDecoded = NSData(base64Encoded: items[indexPath.item], options: NSData.Base64DecodingOptions.init(rawValue: 0))
            
            //print(dataDecoded ?? "no data")
            
            if (dataDecoded != nil) {
                let cellImage = UIImage(data: dataDecoded as! Data)
                cell.image.image = cellImage
            }
        }
        
        cell.nickName.text = imageDrawer[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("selected ",indexPath.item)
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        continuerButton.isHidden = false
        scrollLabel.isHidden = true
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
        
        getTopImage()
    }
    
    func convertToBase64(receivedImages: [String]) -> [String] {
        var finalImagesCleaned: [String] = []
        for image in receivedImages {
            finalImagesCleaned.append(image.replacingOccurrences(of: " ", with: "+"))
        }
        return finalImagesCleaned
    }
    
    func getTopImage() {
        self.getImage(position: 0)
    }
    
    func getImage(position: Int){
        DispatchQueue.global(qos: .background).async {
            let receivedImagesObject = CotoBackMethods().getTopImage(position: position)
            DispatchQueue.main.async {
                self.updateList(position: position, receivedImagesObject: receivedImagesObject as [AnyObject])
            }
        }
    }
    
    func updateList(position: Int, receivedImagesObject: [AnyObject]) {
        var gotPosition = position
        let receivedImages = receivedImagesObject[0] as! [String]
        let receivedIds = receivedImagesObject[1] as! [Int]
        let receivedUsers = receivedImagesObject[2] as! [String]
        let finalImagesCleaned = self.convertToBase64(receivedImages: receivedImages)
        if (receivedImages.count>0) {
            if position==0 {
                self.items = [finalImagesCleaned[0]]
                self.imagesIds = [receivedIds[0]]
                self.imageDrawer = [receivedUsers[0]]
                self.imagesView.reloadData()
            } else {
                self.items.append(finalImagesCleaned[0])
                self.imagesIds.append(receivedIds[0])
                self.imageDrawer.append(receivedUsers[0])
                self.imagesView.insertItems(at: [IndexPath(row: self.items.count-1, section: 0)])
            }
            gotPosition += 1
            self.getImage(position: gotPosition)
        } else {
            self.items.remove(at: 0)
            self.imagesIds.remove(at: 0)
            self.imageDrawer.remove(at: 0)
            self.imagesView.reloadData()
        }
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
