//
//  AppDelegate.swift
//  Capgemini
//
//  Created by xavier green on 17/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let themeColor = UIColor(red: 0.01, green: 0.41, blue: 0.22, alpha: 1.0)
    
    @objc func fireEvent(notification: NSNotification) {
        let resultat = notification.object as! String
        FireEvents().fireDone(resultat: resultat)
    }
    
    @objc func loginSuccess() {
        StatController().loginSuccess()
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.addHack), name: NSNotification.Name(rawValue: "ADD_HACK"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hackAttempt), name: NSNotification.Name(rawValue: "HACK_ATTEMPT"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loginSuccess), name: NSNotification.Name(rawValue: "LOGIN_SUCCESS"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loginFail), name: NSNotification.Name(rawValue: "LOGIN_FAIL"), object: nil)
        print("Done !")
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window?.tintColor = themeColor
        ServerFunctions().getUserList()
        CotoBackMethods().getUsersNames()
        initStats()
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

