//
//  SceneDelegate.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 19.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit
import Backendless
import Unrealm

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        if let urlContext = connectionOptions.urlContexts.first?.url {
            let components = URLComponents(url: urlContext, resolvingAgainstBaseURL: true)
            handleDeepLink(scene, components: components!)
            return
        }
        if let userActivity = connectionOptions.userActivities.first {
            self.scene(scene, continue: userActivity)
        }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }


        let introWireframe = IntroWireframe()
        let navigationController = UINavigationController()
        navigationController.setRootWireframe(introWireframe)
        self.window = UIWindow(windowScene: windowScene)
        self.window!.tintColor = .cmAppDefaultColor
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, didUpdate userActivity: NSUserActivity) {
        log.info("")
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        log.info("")
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                return
        }
        handleDeepLink(scene, components: components)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        log.info("")
        guard let url = URLContexts.first?.url, let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return
        }
        log.info("openURLContexts \(url.absoluteString)")
        
        handleDeepLink(scene, components: components)
    }
    
    func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String) {
        log.info(userActivityType)
    }
    
    
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        log.debug("")
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        log.debug("")
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        log.debug("")
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        log.debug("")
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        log.debug("")
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    
    private func handleDeepLink(_ scene: UIScene, components: URLComponents) {
        var queryID: String?
        
        for queryItem in components.queryItems ?? [] {
            if queryItem.name == "id" {
                queryID = queryItem.value!
            }
        }

        guard queryID != nil else {
            return
        }
        if queryID!.count == 36 {
            var cmAnnotation: CMAnnotation!
            let annotations = DataManager.shared.localDataManager.getAllLocal()
            let containsAnnotation = annotations.contains(where: { $0.guid!.contains(queryID!)})
            if !containsAnnotation {
                let remoteAnnotationById = DataManager.shared.remoteDataManager.findBy(guid: queryID!)
                guard remoteAnnotationById != nil else {
                    return
                }
                cmAnnotation = CMAnnotation(annotation: remoteAnnotationById!)
            } else {
                cmAnnotation = annotations.first(where: { $0.guid!.contains(queryID!) })
            }
            
            if self.window == nil {
                log.info("self.window is nil")
                guard let windowScene = (scene as? UIWindowScene) else { return }
                self.window = UIWindow(windowScene: windowScene)
                log.info("rootView after setup \(String(describing: self.window?.rootViewController?.typeString()))")
            }

            // Current View is ColorTabBar
            if let tabBarController = self.window?.rootViewController as? ColorTabBarViewController {
                log.info("Current View is ColorTab ... \(String(describing: self.window?.rootViewController?.typeString()))")
                tabBarController.selectedIndex = 0
                let vc = tabBarController.selectedViewController as? ColorMapViewController
                DispatchQueue.main.async {
                    vc?.showMapLayer(layerType: .defaultmap)
                    vc?.zoomToAnnotation(annotation: cmAnnotation)
                }
            } else {
                // Current View is Intro
                if self.window?.rootViewController is IntroViewController {
                    log.info("Current View is Intro ... \(String(describing: self.window?.rootViewController?.typeString()))")
                    let introWireframe = IntroWireframe()
                    let tabBarWireframe = ColorTabBarWireframe()
                    tabBarWireframe.installTabBar(with: cmAnnotation)
                    introWireframe.switchRootWireframe(rootWireframe: tabBarWireframe, animated: true, completion: nil)
                } else {
                    // Start directly with Tabbar
                    log.info("Current View is nil ... \(String(describing: self.window?.rootViewController?.typeString()))")
                    let tabBarWireframe = ColorTabBarWireframe()
                    tabBarWireframe.installTabBar(with: cmAnnotation)
                    self.window?.rootViewController = tabBarWireframe.viewController
                    self.window!.tintColor = .cmAppDefaultColor
                    self.window?.makeKeyAndVisible()
                }
            }
        }
    }

}

