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
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
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
        self.spinner.isHidden = true
        continuerButton.isHidden = true
        continuerButton.layer.borderWidth = 1
        continuerButton.layer.borderColor = UIColor.lightGray.cgColor
        continuerButton.addTarget(self, action: #selector(self.finir), for: .touchUpInside)
        // Do any additional setup after loading the view.
        assignbackground()
        
        getTopImage()
        
//        DispatchQueue.global(qos: .background).async {
//            print("Running nuance fetch in background thread")
//            let receivedImagesObject = CotoBackMethods().getImages()
//            DispatchQueue.main.async {
//                print("back to main")
//                let receivedImages = receivedImagesObject[0] as! [String]
//                let finalImagesCleaned = self.convertToBase64(receivedImages: receivedImages)
//                self.items = finalImagesCleaned
//                self.imagesIds = receivedImagesObject[1] as! [Int]
//                self.imageDrawer = receivedImagesObject[2] as! [String]
//                self.imagesView.reloadData()
//                self.spinner.stopAnimating()
//                self.spinner.isHidden = true
//
//            }
//        }
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
        var gotPosition = position
        DispatchQueue.global(qos: .background).async {
            let receivedImagesObject = CotoBackMethods().getTopImage(position: position)
            DispatchQueue.main.async {
                
                let receivedImages = receivedImagesObject[0] as! [String]
                let finalImagesCleaned = self.convertToBase64(receivedImages: receivedImages)
                self.items = finalImagesCleaned
                self.imagesIds.append(receivedImagesObject[1][0] as! Int)
                self.imageDrawer.append(receivedImagesObject[2][0] as! String)
                
                self.imagesView.insertItems(at: [IndexPath(row: self.imagesIds.count-1, section: 0)])
                
                gotPosition += 1
                if (gotPosition<25) {
                    self.getImage(position: gotPosition)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let transform = CGAffineTransform(scaleX: 3, y: 3)
        self.spinner.transform = transform
        self.spinner.startAnimating()
        self.spinner.isHidden = false
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
