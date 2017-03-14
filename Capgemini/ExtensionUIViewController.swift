//
//  HideKeyboardMethod.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 22/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//
//  This file is an extension of the UIViewController
//


import Foundation
import UIKit

extension UIViewController {
    
    /**
     
     This function dismisses keyboard when user taps the View.
     It is present in all Controller's ViewDidLoad
     
     */
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /**
     Sets Application background.
     Present in all ViewDidLoad
     */
    func assignbackground(){
        let background = UIColor(red: (251/255.0), green: (251/255.0), blue: (251/255.0), alpha: 1.0)
        //let background = UIColor(red: (0/255.0), green: (150/255.0), blue: (94/255.0), alpha: 1.0)
        
        var imageview : UIImageView!
        imageview = UIImageView(frame: view.bounds)
        imageview.contentMode =  UIViewContentMode.scaleAspectFill
        imageview.clipsToBounds = true
        imageview.backgroundColor = background
        //imageview.image = background
        imageview.center = view.center
        view.addSubview(imageview)
        self.view.sendSubview(toBack: imageview)
    }
    
    /**
     Takes a name as argument and see if it matches RegEx
     
     - Parameter testStr: the string that will be matched to the RegEx
     - Returns: true if it matches
     */
    func isValidName(testStr:String) -> Bool {
        let nameRegEx = "[A-Za-z0-9]+"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: testStr)
    }
    
    /**
     See if the name entered is available for sign in
     
     - Parameter username: string entered by user
     - Parameter allUsernames: Array of all registered usernames
     - Returns: true if username not in array (if username can be used)
     */
    func isAvailableUsername(username: String, allUsernames: [String]) -> Bool {
        if allUsernames.contains(username) {
            return false
        }
        return true
    }
    
    /**
     See if the name entered exists in our database
     
     - Parameter username: string entered by user
     - Parameter allUsernames: Array of all registered usernames
     - Returns: true if username in array (if username can be used)
     */
    func isValidUsername(username: String, allUsernames: [String]) -> Bool {
        if allUsernames.contains(username) {
            return true
        }
        return false
    }
    
    /**
     Gets the bottom most View Controller
     
     - Parameters: None
     - Returns: First Root View Controller
     */
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
    
    /**
     Gets the bottom most View Controller
     
     - Parameters: None
     - Returns: First Root View Controller
     */
    func bottomMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentingViewController != nil) {
            topController = topController.presentingViewController!
        }
        return topController
    }
    
    
    func testInternetConnection() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet Connection Available!")
        }
        else
        {
            print("Internet Connection not Available!")
            let alert = UIAlertController(title: "Connection Internet", message: "Vous n'êtes pas connecté à Internet. Cette application requiert une connexion à Internet", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            topMostController().present(alert, animated: true, completion: nil)
        }
    }
    
    
    func goBacktohomefromApp() {
        bottomMostController().dismiss(animated: true, completion: nil)
        bottomMostController().dismiss(animated: false, completion: nil)
    }
}

extension String {
    
    var RFC3986UnreservedEncoded:String {
        let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        let unreservedCharsSet: CharacterSet = CharacterSet(charactersIn: unreservedChars)
        let encodedString: String = self.addingPercentEncoding(withAllowedCharacters: unreservedCharsSet)!
        return encodedString
    }
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
