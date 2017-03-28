//
//  AppDelegate.swift
//  Family_Tree
//
//  Created by Manish Patel on 20/12/16.
//  Copyright © 2016 Jaydeep Vachhani. All rights reserved.
//

import UIKit
import FMDB
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import IQKeyboardManagerSwift
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.132779924499"
    
    

  

   
    let kClientID = "132779924499-8brpp05c59mc6dn0vv3jtfa48v4a7360.apps.googleusercontent.com"
 
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      print(url)
        print("\(sourceApplication)")
           return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        
    }
    
    func getdatabase() {
        var success: Bool
        let fileManager = FileManager.default
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        // Database filename can have extension db/sqlite.
       
        let appDBPath:URL = URL(fileURLWithPath: paths).appendingPathComponent("Family_Tree.sqlite")
        let appDBPath1:String = URL(fileURLWithPath: paths).appendingPathComponent("Family_Tree.sqlite").absoluteString

        print("\(appDBPath)")
        success = fileManager.fileExists(atPath:appDBPath1)
        if success {
            return
        }
        // The writable database does not exist, so copy the default to the appropriate location.
        let defaultDBPath:URL = URL(fileURLWithPath: Bundle.main.resourcePath!).appendingPathComponent("Family_Tree.sqlite")
        do {
           try fileManager.copyItem(at: defaultDBPath, to: appDBPath)
        }
        catch {
        }
    }
    
    class func insertquery(query:NSString,arr:NSArray)
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let appDBPath1:String = URL(fileURLWithPath: paths).appendingPathComponent("Family_Tree.sqlite").absoluteString
        let database:FMDatabase = FMDatabase.init(path: appDBPath1)
        database.open()
        database.executeUpdate(query as String, withArgumentsIn:arr as [AnyObject])
        database.close()
    }
    
    class func selectquery(query:NSString,arr:NSArray) -> NSMutableArray
    {
        let accountid:NSMutableArray = NSMutableArray()
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let appDBPath1:String = URL(fileURLWithPath: paths).appendingPathComponent("Family_Tree.sqlite").absoluteString
        let database:FMDatabase = FMDatabase.init(path: appDBPath1)
        
        database.open()
        let resultsWithCollegeName:FMResultSet=database.executeQuery(query as String, withArgumentsIn: arr as [AnyObject])
        
        while(resultsWithCollegeName.next()) {
            accountid.add(resultsWithCollegeName.resultDictionary())
        }
        database.close()
        return accountid;
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = -100
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
       // GIDSignIn.sharedInstance().clientID = kClientID
       // GIDSignIn.sharedInstance().delegate = self
        getdatabase()
        registerForPushNotifications(application: application)
        // Override point for customization after application launch.
        // Use Firebase library to configure APIs
        FIRApp.configure()
        if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
            // 2
            let aps = notification["aps"] as! [String: AnyObject]
            print(aps)
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        FIRMessaging.messaging().disconnect()

        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        connectToFcm()

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func registerForPushNotifications(application: UIApplication) {
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        //print("abcd=\(((userInfo as NSDictionary).value(forKey: "aps") as! NSDictionary).value(forKey: "alert") as! String)")
        print((userInfo as NSDictionary).value(forKey: "type") as! String)
         if (userInfo as NSDictionary).value(forKey: "type") as! String == "request sent"
         {
            
        }
    }
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print(token)
        UserDefaults.standard.set(token, forKey: "device_token")
        //Tricky line
        FIRInstanceID.instanceID().setAPNSToken(deviceToken as Data, type: FIRInstanceIDAPNSTokenType.sandbox)
    //print(FIRInstanceID.instanceID().token()!)

    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        
        // Print full message.
        print(userInfo)
        if UIApplication.shared.applicationState == UIApplicationState.active {
            
            // Do something you want when the app is active
            
        } else {
            if UserDefaults.standard.string(forKey: "userid") != "0" {
                let rootViewController = self.window?.rootViewController as! UINavigationController
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                if (userInfo as NSDictionary).value(forKey: "gcm.notification.type") as! String == "request sent"
                {
                    
                    let setViewController = mainStoryboard.instantiateViewController(withIdentifier: "PendingrequestViewController") as! PendingrequestViewController
                    setViewController.actionstr = "Pending Friend Request"
                    rootViewController.pushViewController(setViewController, animated: true)
                }
                else if (((userInfo as NSDictionary).value(forKey:  "gcm.notification.type") as! String == "request accepted") || ((userInfo as NSDictionary).value(forKey: "gcm.notification.type") as! String == "tree modified"))
                {
                    
                    let setViewController = mainStoryboard.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
                    setViewController.profileid=0
                    setViewController.userid=Int((userInfo as NSDictionary).value(forKey: "gcm.notification.userid") as! String)!
                    setViewController.api_token=UserDefaults.standard.string(forKey: "api_token")!
                    rootViewController.pushViewController(setViewController, animated: true)
                    
                }
                else if (userInfo as NSDictionary).value(forKey: "gcm.notification.type") as! String == "friend registered"
                {
                    
                    let setViewController = mainStoryboard.instantiateViewController(withIdentifier: "PendingrequestViewController") as! PendingrequestViewController
                    rootViewController.pushViewController(setViewController, animated: true)
                }
            }
            // Do something else when your app is in the background
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    func connectToFcm() {
        // Won't connect since there is no token
//        guard FIRInstanceID.instanceID().token() != nil else {
//            return;
//        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }

}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
        
        
//        ["google.c.a.e": "1","google.c.a.ts": "1488967048","google.c.a.udt":" 0", "gcm.n.e": "1", "aps": {
//            "alert" =     {
//                "body" = "fdfgdf";
//                "title" = "aabc";
//            };
//            }, "google.c.a.c_id": "7430593497277108462", "gcm.message_id": "0:1488967048254905%87708b2a87708b2a"]
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

// [START ios_10_data_message_handling]
extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}
