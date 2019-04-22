//
//  AppDelegate.swift
//  muhattapp
//
//  Created by Arif Doğan on 8.01.2019.
//  Copyright © 2019 Arif Doğan. All rights reserved.
//

import UIKit
import OneSignal
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,OSSubscriptionObserver {
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
        
        //The player id is inside stateChanges. But be careful, this value can be nil if the user has not granted you permission to send notifications.
        if let playerId = stateChanges.to.userId {
            
            UserDefaults.standard.set(playerId, forKey: "device_id")
            UserDefaults.standard.synchronize()
            
            print("Current playerId \(playerId)")
        }
    }

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "d88f4045-bc1f-4806-94f2-2d64b2ee5574",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        
        AuthSystem()
        OneSignal.add(self as OSSubscriptionObserver)

        
        return true
    }


    func AuthSystem() {
        
        window = UIWindow(frame: UIScreen.main.bounds)
   
        
        if (UserDefaults.standard.string(forKey: "user_key") != nil){
            if (UserDefaults.standard.bool(forKey: "isPersonal") == false){
                let MainVC = MainMenuViewController()
                window?.rootViewController = MainVC
            }else {
                let departmanVC = DepartmanBildirimViewController()
                window?.rootViewController = departmanVC
            }
        } else {
            let LoginVC = LoginViewController()
            window?.rootViewController = LoginVC
        }
        
            window?.makeKeyAndVisible()
    }

}

