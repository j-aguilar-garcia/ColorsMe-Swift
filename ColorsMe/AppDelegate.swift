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
import Sentry
import SwiftyBeaver
import UserNotifications
let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.registerForRemoteNotifications()

        
        AppData.appStartDate = Date()
        
        // Init SwiftyBeaver
        #if DEBUG
        let console = ConsoleDestination()
        let file = FileDestination()
        log.addDestination(console)
        log.addDestination(file)
        #endif
        let cloud = SBPlatformDestination(
            appID: AppConfiguration.default.swiftyBeaverAppId,
            appSecret: AppConfiguration.default.swiftyBeaverAppSecret,
            encryptionKey: AppConfiguration.default.swiftyBeaverEncryptionKey)
        #if !DEBUG
        cloud.asynchronously = true
        cloud.minLevel = .warning
        #endif
        log.addDestination(cloud)

        Realm.registerRealmables([RealmAnnotation.self])
        
        DataManager.shared.fetchData()
        
        UNUserNotificationCenter.current().delegate = self
        SentrySDK.start(options: [ "dsn": AppConfiguration.default.sentryDsn!, "debug": false ])
                
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
        log.verbose("DidReceiveRemoteNotification")
        let taskContext = DataManager.shared.cloudDataManager.persistentContainer.newBackgroundContext()
            taskContext.performAndWait {
                var lastHistoryToken = DataManager.shared.cloudDataManager.lastHistoryToken

                let historyFetchRequest = NSPersistentHistoryTransaction.fetchRequest!
                taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                let request = NSPersistentHistoryChangeRequest.fetchHistory(after: lastHistoryToken)
                request.fetchRequest = historyFetchRequest
                
                let result = (try? taskContext.execute(request)) as? NSPersistentHistoryResult
                guard let transactions = result?.result as? [NSPersistentHistoryTransaction],
                      !transactions.isEmpty
                    else { return }
                
                lastHistoryToken = transactions.last!.token
                DataManager.shared.cloudDataManager.lastHistoryToken = lastHistoryToken
                AppData.lastCloudSync = Date()
                AppData.iCloudHasSynced = true
                
                log.info("###\(#function): FINISHED \(String(describing: lastHistoryToken))")
                NotificationCenter.default.post(name: .didSyncFromCloud, object: nil)
            }
            completionHandler(.newData)
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = DataManager.shared.cloudDataManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                log.error(nserror)
            }
        }
    }

}

