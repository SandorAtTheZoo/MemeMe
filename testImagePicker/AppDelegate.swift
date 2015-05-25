//
//  AppDelegate.swift
//  testImagePicker
//
//  Created by Christopher Johnson on 5/9/15.
//  Copyright (c) 2015 Christopher Johnson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var memes = [Meme]()

    //http://stackoverflow.com/questions/26753925/set-initial-viewcontroller-in-appdelegate-swift
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //added this to transition directly to meme editor if there are no memes (could happen with core data)
        //needed to create my own class for IB navigation controller and tie in tab controller as root in order to
        //sync this up with what was in storyboard.  Then just a matter of pushing meme edit viewController on stack without
        //animation to achieve option on startup
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController : UINavigationController = storyboard.instantiateInitialViewController() as! myInitNavController
        let rootViewController : UIViewController = storyboard.instantiateViewControllerWithIdentifier("myTabController") as! UITabBarController
        navigationController.viewControllers = [rootViewController]
        self.window?.rootViewController = navigationController
        if memes.count <= 0 {
            let nextVC = storyboard.instantiateViewControllerWithIdentifier("MemeEditViewController") as! EditMemeViewController
            navigationController.pushViewController(nextVC, animated: false)
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    


}

