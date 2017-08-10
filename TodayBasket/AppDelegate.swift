//
//  AppDelegate.swift
//  slidetest1
//
//  Created by MD313-008 on 2017. 2. 7..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications
import Firebase
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    var pushAction:String = ""
    var userInfo1: [AnyHashable: Any]? = nil

    /// This method will be called whenever FCM receives a new, default FCM token for your
    /// Firebase project's Sender ID.
    /// You can send this token to your application server to send notifications to this device.
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String)
    {
        debugPrint("--->messaging:\(messaging)")
        debugPrint("--->didRefreshRegistrationToken:\(fcmToken)")
    }
    
    @available(iOS 10.0, *)
    public func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage)
    {
        debugPrint("--->messaging:\(messaging)")
        debugPrint("--->didReceive Remote Message:\(remoteMessage.appData)")
        guard let data =
            try? JSONSerialization.data(withJSONObject: remoteMessage.appData, options: .prettyPrinted),
            let prettyPrinted = String(data: data, encoding: .utf8) else { return }
        print("Received direct channel message:\n\(prettyPrinted)")
        
    }
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Alamofire.request("http://210.122.7.193:8080/TodayBasket_manager/Today_Counting.jsp").responseJSON { (responseData) -> Void in }
       
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        
        debugPrint("###> 1 AppDelegate DidFinishLaunchingWithOptions")
        self.initializeFCM(application)
        let token = InstanceID.instanceID().token()
        debugPrint("GCM TOKEN = \(String(describing: token))")
        
//        if let payload = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary, let identifier = payload["identifier"] as? String {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: identifier)
//            window?.rootViewController = vc
//        }
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        debugPrint("###> 1.2 AppDelegate DidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        debugPrint("###> 1.2 AppDelegate DidEnterForground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        debugPrint("###> 1.3 AppDelegate DidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        debugPrint("###> 1.3 AppDelegate applicationWillTerminate")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        debugPrint("didFailToRegisterForRemoteNotificationsWithError: \(error)")
    }
    
    func application(received remoteMessage: MessagingRemoteMessage)
    {
        debugPrint("remoteMessage:\(remoteMessage.appData)")
    }
    
    func initializeFCM(_ application: UIApplication)
    {
        print("initializeFCM")
        //-------------------------------------------------------------------------//
        if #available(iOS 10.0, *) // enable new way for notifications on iOS 10
        {
            UNUserNotificationCenter.current().delegate = self
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.badge, .alert , .sound]) { (accepted, error) in
                if !accepted
                {
                    print("Notification access denied.")
                }
                else
                {
                    print("Notification access accepted.")
                    UIApplication.shared.registerForRemoteNotifications();
                }
            }
        }
        else
        {
            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound];
            let setting = UIUserNotificationSettings(types: type, categories: nil);
            UIApplication.shared.registerUserNotificationSettings(setting);
            UIApplication.shared.registerForRemoteNotifications();
            
            //NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotificaiton), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        }
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
        
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings)
    {
        debugPrint("didRegister notificationSettings")
        if (notificationSettings.types == .alert || notificationSettings.types == .badge || notificationSettings.types == .sound)
        {
            application.registerForRemoteNotifications()
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        //Handle the notification ON APP
        debugPrint("*** willPresent notification")
        debugPrint("*** notification: \(notification)")
        
        completionHandler([.alert, .sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        //Handle the notification ON BACKGROUND
        debugPrint("*** didReceive response Notification ")
        debugPrint("*** response: \(response)")
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        debugPrint("didRegisterForRemoteNotificationsWithDeviceToken: NSDATA")
        
        let token = String(format: "%@", deviceToken as CVarArg)
        debugPrint("*** deviceToken: \(token)")
        
        Messaging.messaging().apnsToken = deviceToken as Data
        debugPrint("Firebase Token:",InstanceID.instanceID().token() as Any)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        debugPrint("didRegisterForRemoteNotificationsWithDeviceToken: DATA")
        let token = String(format: "%@", deviceToken as CVarArg)
        debugPrint("*** deviceToken: \(token)")
        
        Messaging.messaging().apnsToken = deviceToken
        debugPrint("Firebase Token:",InstanceID.instanceID().token() as Any)
    }
    //-------------------------------------------------------------------------//
    
    @available(iOS 10.0, *)
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        //        let rootVC = self.window?.rootViewController as! SWRevealViewController
        //        let mainView = rootVC.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        //        mainView.notificationMode = "teamUserManage"
        //        rootVC.pushFrontViewController(mainView, animated: false)
        
        // Print full message.
        print(userInfo)
    }
    
    @available(iOS 10.0, *)
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let messageID = userInfo["gcm.message_id"] {
            debugPrint("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    // 세로모드 지정
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
}
