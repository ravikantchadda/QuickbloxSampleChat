//
//  AppDelegate.swift
//  chatswift
//
//  Created by ravi kant on 12/17/15.
//  Copyright © 2015 Net Solutions. All rights reserved.
//

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,QBRTCClientDelegate {

    var window: UIWindow?
    
    //******Core Data objects*********
    var managedObjectContextVar:NSManagedObjectContext!
    var managedObjectModelVar:NSManagedObjectModel!
    var persistentStoreCoordinatorVar:NSPersistentStoreCoordinator!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        /*
        *********Set QuickBlox credentials**************
        ************************************************
        */
        
        QBApplication.sharedApplication().applicationId = 32165
        QBConnection.registerServiceKey("mz8Wy8GadCmtTyD")
        QBConnection.registerServiceSecret("En9bEVXx9xt77Of")
        QBSettings.setAccountKey("geBjH6atfzJmyyRyFYzs")
        
        
        // Enables Quickblox REST API calls debug console output
        QBSettings.setLogLevel(QBLogLevel.Debug)
        
        // Enables detailed XMPP logging in console output
        QBSettings.enableXMPPLogging()
        
        /****************************************************/
        
        /*
        **********************QuickbloxWebRTC preferences*********************************
        */
        
        // Set answer time interval
        QBRTCConfig.setAnswerTimeInterval(60)
        
        // Set disconnect time interval
        QBRTCConfig.setDisconnectTimeInterval(30)
        
        // Set dialing time interval
        QBRTCConfig.setDialingTimeInterval(5)
        
        // Enable DTLS (Datagram Transport Layer Security)
        QBRTCConfig.setDTLSEnabled(true)
        
        // Set custom ICE servers
        
        
        let stunUrl: NSURL = NSURL(string: "stun:turn.quickblox.com")!
        let stunServer:QBICEServer = QBICEServer(URL: stunUrl, username: "quickblox", password: "baccb97ba2d92d71e26eb9886da5f1e0")
        
        
        let turnUDPUrl: NSURL = NSURL(string: "turn:turn.quickblox.com:3478?transport=udp")!
        let turnUDPServer:QBICEServer = QBICEServer(URL: turnUDPUrl, username: "quickblox", password: "baccb97ba2d92d71e26eb9886da5f1e0")
        
        let turnTCPUrl: NSURL = NSURL(string: "turn:turn.quickblox.com:3478?transport=tcp")!
        let turnTCPServer:QBICEServer = QBICEServer(URL: turnTCPUrl, username: "quickblox", password: "baccb97ba2d92d71e26eb9886da5f1e0")
        
        QBRTCConfig.setICEServers([stunServer, turnUDPServer, turnTCPServer])
        QBRTCClient.instance().addDelegate(self)
        
    /****************************************************************************************/

        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // Logout from chat
        //
        ServicesManager.instance().chatService.logoutChat()
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        
        // Login to QuickBlox Chat
        //
        ServicesManager.instance().chatService.logIn { (error:NSError!) -> Void in
            
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: ----------------------------------------------------------------------
    //MARK: - Method to Call Another Storyboard
    
    
    //MARK: ----------------------------------------------------------------------
    //MARK: -  Core Data stack
    
    func applicationDocumentsDirectory() -> NSURL {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.netsolution.SampleCoreData.QBSampleChat" in the application's documents directory.
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        return paths.lastObject as! NSURL
        
    }
    
    func managedObjectModel() -> NSManagedObjectModel {
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        if managedObjectModelVar != nil {
            return managedObjectModelVar
        }
        let modelURL: NSURL = NSBundle.mainBundle().URLForResource("QBSampleChat", withExtension: "momd")!
        self.managedObjectModelVar = NSManagedObjectModel(contentsOfURL: modelURL)
        return managedObjectModelVar
    }
    
    func persistentStoreCoordinator() -> NSPersistentStoreCoordinator {
        
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
        if persistentStoreCoordinatorVar != nil {
            return persistentStoreCoordinatorVar
        }
        // Create the coordinator and store
        
        self.persistentStoreCoordinatorVar = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel())
        let storeURL: NSURL = self.applicationDocumentsDirectory().URLByAppendingPathComponent("QBSampleChat.sqlite")
        let error: NSError? = nil
        let failureReason: String = "There was an error creating or loading the application's saved data."
        
        
        if ((try? self.persistentStoreCoordinatorVar.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)) != nil){
            var dict: [NSObject : AnyObject] = [NSObject : AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error!
           // error = NSError.errorWithDomain("YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error %@, %@", error!, error!.userInfo)
            abort()
        
        }
        
        return persistentStoreCoordinatorVar;
        
    }
    
//    func managedObjectContext() -> NSManagedObjectContext {
//        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
//        if managedObjectContextVar != nil {
//            return managedObjectContextVar
//        }
//        var coordinator: NSPersistentStoreCoordinator = self.persistentStoreCoordinator()
//        if (coordinator == nil){
//            return 0
//        }
//        self.managedObjectContextVar = NSManagedObjectContext(concurrencyType: NSMainQueueConcurrencyType)
//        managedObjectContextVar.persistentStoreCoordinator = coordinator
//        return managedObjectContext
//    }
}

