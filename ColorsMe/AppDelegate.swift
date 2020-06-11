//
//  AppDelegate.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 19.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit
import CoreData
import Unrealm
import Firebase
import Sentry
import CloudCore
import SwiftyBeaver
let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let iCloudDelegateHandler = CloudKitDelegate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.registerForRemoteNotifications()
        
        // Init SwiftyBeaver
        let console = ConsoleDestination()  // log to Xcode Console
        let file = FileDestination()
        let cloud = SBPlatformDestination(
            appID: AppConfiguration.default.swiftyBeaverAppId,
            appSecret: AppConfiguration.default.swiftyBeaverAppSecret,
            encryptionKey: AppConfiguration.default.swiftyBeaverEncryptionKey)
        log.addDestination(console)
        log.addDestination(file)
        log.addDestination(cloud)
        
        Realm.registerRealmables([RealmAnnotation.self])
        
        DataManager.shared.fetchData()
        //_ = DataManager.shared.dataManager(willRetrieveWith: .remote)
        
        SentrySDK.start(options: [ "dsn": AppConfiguration.default.sentryDsn!, "debug": false ])
        
        CloudCore.delegate = iCloudDelegateHandler
        CloudCore.enable(persistentContainer: persistentContainer)
        
        FirebaseApp.configure()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        AppData.selectedFilterIndex = 0
        AppData.selectedFilterName = "All Colors"
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            // Check if it CloudKit's and CloudCore notification
        if CloudCore.isCloudCoreNotification(withUserInfo: userInfo) {
            // Fetch changed data from iCloud
            CloudCore.pull(using: userInfo, to: persistentContainer, error: nil, completion: { (fetchResult) in
                AppData.lastCloudSync = Date()
                completionHandler(fetchResult.uiBackgroundFetchResult)
            })
        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "ColorsMe")

        let storeDescription = container.persistentStoreDescriptions.first
        storeDescription?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                log.error(nserror)
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

