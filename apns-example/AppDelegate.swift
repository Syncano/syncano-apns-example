//
//  AppDelegate.swift
//  apns-example
//
//  Created by Jakub Machoń on 18.04.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

import UIKit
import syncano_ios

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let notificationNameNewMessage = "notificationNewMessage"
    
    var window: UIWindow?
    var deviceToken: NSData?
    let syncano = Syncano.sharedInstanceWithApiKey("", instanceName: "")
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        initializeNotificationServices()
        
        return true
    }

    // MARK: notifications
    func initializeNotificationServices() -> Void {
        let settings = UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        self.deviceToken = deviceToken
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("register for remote notifications failed: \(error.description)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(AppDelegate.notificationNameNewMessage, object: self, userInfo: userInfo)
        
        completionHandler(UIBackgroundFetchResult.NoData)
    }
}

