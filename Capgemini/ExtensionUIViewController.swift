//
//  HideKeyboardMethod.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 22/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func assignbackground(){
        let background = UIImage(named: "background")
        
        var imageview : UIImageView!
        imageview = UIImageView(frame: view.bounds)
        imageview.contentMode =  UIViewContentMode.scaleAspectFill
        imageview.clipsToBounds = true
        imageview.image = background
        imageview.center = view.center
        view.addSubview(imageview)
        self.view.sendSubview(toBack: imageview)
    }
}
