//
//  AppDelegate.swift
//  Marvoice
//
//  Created by ruyuzhou on 3/12/18.
//  Copyright © 2018 ruyuzhou. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var launchFromTerminated = false
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.launchFromTerminated = true
        if UserDefaults.standard.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
            print("Marvoice already launched")
            
        }else{
            UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("Marvoice launched first time")
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            let result = formatter.string(from: date)
            print(result)
            UserDefaults.standard.set(result, forKey: "initial_date")
            UserDefaults.standard.register(defaults: ["initial_date" : result])
            UserDefaults.standard.synchronize()
        }
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
        print("Entering foreground")
        if launchFromTerminated == false {
            showSplashScreen(autoDismiss: true)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("Did become active")
        if launchFromTerminated {
            showSplashScreen(autoDismiss: false)
            launchFromTerminated = false
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    

}


extension AppDelegate {
    
    /// Load the SplashViewController from Splash.storyboard
    func showSplashScreen(autoDismiss: Bool) {
        let storyboard = UIStoryboard(name: "Splash", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        
        // Control the behavior from suspended to launch
        controller.autoDismiss = autoDismiss
        
        // Present the view controller over the top view controller
        let vc = topController()
        vc.present(controller, animated: false, completion: nil)
    }
    
    
    /// Determine the top view controller on the screen
    /// - Returns: UIViewController
    func topController(_ parent:UIViewController? = nil) -> UIViewController {
        if let vc = parent {
            if let tab = vc as? UITabBarController, let selected = tab.selectedViewController {
                return topController(selected)
            } else if let nav = vc as? UINavigationController, let top = nav.topViewController {
                return topController(top)
            } else if let presented = vc.presentedViewController {
                return topController(presented)
            } else {
                return vc
            }
        } else {
            return topController(UIApplication.shared.keyWindow!.rootViewController!)
        }
    }
}

