//
//  AppDelegate.swift
//  Capgemini
//
//  Created by xavier green on 17/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit
import Photos
import Speech

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let themeColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 1.0)
    
    
    //MARK: Events Functions
    @objc func fireEvent(notification: NSNotification) {
        let resultat = notification.object as! String
        FireEvents().fireDone(resultat: resultat)
    }
    
    @objc func loginFail(notification: NSNotification) {
        let email = notification.object as! String
        StatController().loginFail(email: email)
    }
    
    @objc func hackAttempt() {
        StatController().hackAttempt()
    }
    
    @objc func addHack(notification: NSNotification) {
        let hacker = notification.object as! String
        StatController().addHack(hacker: hacker)
    }
    
    func initStats() {
        print("Initialising stats listener...")
        // Add Hacker and Hacked to Server when user gets hacked
        NotificationCenter.default.addObserver(self, selector: #selector(self.addHack), name: NSNotification.Name(rawValue: "ADD_HACK"), object: nil)
        
        // Add Hack Attempt to Server when user tries to log in as another user
        NotificationCenter.default.addObserver(self, selector: #selector(self.hackAttempt), name: NSNotification.Name(rawValue: "HACK_ATTEMPT"), object: nil)
       
        // Increment Login Success in Server when user fails authentication
        NotificationCenter.default.addObserver(self, selector: #selector(self.loginFail), name: NSNotification.Name(rawValue: "LOGIN_FAIL"), object: nil)
        
        // If Server Status is != from 200, send an Error Notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.connectionToNuanceFail), name: NSNotification.Name(rawValue: "ERROR_NUANCE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.connectionToServerFail), name: NSNotification.Name(rawValue: "ERROR_BACK"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.connectionToServerFail), name: NSNotification.Name(rawValue: "TIME_OUT_BACK"), object: nil)
        
        print("Done !")
    }
    
    func checkSpeechPermission() {
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            switch authStatus {
            case .authorized:
                print("all okay")
                
            case .denied:
                print("User denied access to speech recognition")
                
            case .restricted:
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                print("Speech recognition not yet authorized")
            }
        }
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
    
    /**
     Gets the bottom most View Controller
     
     - Parameters: None
     - Returns: First Root View Controller
     */
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        // Loops until there's no ViewController
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
    
    /**
     Presents pop-up when a server error happens.
     The pop up happens when a notification is send and caught by an observer initialised in the InitStats
     
     - Parameters: None
    */
    func connectionToNuanceFail() {
        print("server error")
        let alert = UIAlertController(title: "Erreur de connection", message: "Erreur de connection au serveur Nuance", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        topMostController().present(alert, animated: true, completion: nil)
    }
    func connectionToServerFail() {
        print("server error")
        let alert = UIAlertController(title: "Erreur de connection", message: "Erreur de connection au serveur", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        topMostController().present(alert, animated: true, completion: nil)
    }
    
    func checkMicrophonePermission() {
        switch AVAudioSession.sharedInstance().recordPermission() {
            case AVAudioSessionRecordPermission.granted:
                print("Permission granted")
            case AVAudioSessionRecordPermission.denied:
                print("Pemission denied")
            case AVAudioSessionRecordPermission.undetermined:
                print("Request permission here")
            default:
                break
        }
    }
    
    func checkImageSavePermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            print("authorized")
            break
            
        case .denied, .restricted : break
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() { (status) -> Void in
                switch status {
                case .authorized:
                    print("authorized")
                    break
                    
                case .denied, .restricted: break
                    
                case .notDetermined: break
                }
            }
        }
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        window?.tintColor = themeColor
        initStats()
        checkMicrophonePermission()
        checkImageSavePermission()
        checkSpeechPermission()
        NotificationCenter.default.addObserver(self, selector: #selector(self.fireEvent), name: NSNotification.Name(rawValue: "DONE_SPEECH_TO_TEXT"), object: nil)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

