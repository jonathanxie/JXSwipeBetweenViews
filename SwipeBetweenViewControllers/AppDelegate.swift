//
//  AppDelegate.swift
//  SwipeBetweenViewControllers
//
//  Created by Jonathan Xie on 5/19/15.
//  Copyright (c) 2015 Jonathan Xie. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Create a horizontal scrolling view controller
        var pageController = UIPageViewController(
            transitionStyle: UIPageViewControllerTransitionStyle.Scroll, //Set the transition style to scroll
            navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, // Horizontal scrolling only
            options: nil
        )
        
        // Create the navigation controller that the app will use as the main navigation controller and set the root view to the pageController above
        var navigationController = JXSwipeBetweenViewControllers(rootViewController: pageController)
        
        // Set the background to white or to whatever you like
        navigationController.view.backgroundColor = UIColor.lightGrayColor()

        var leftView = UIViewController();
        var middleView = UIViewController();
        var rightView = UIViewController();
        
        leftView.view.backgroundColor = UIColor.brownColor()
        middleView.view.backgroundColor = UIColor.whiteColor()
        rightView.view.backgroundColor = UIColor.redColor()
        
        // Set the swipable views here in a specific order with left most view first
        navigationController.viewControllerArray = [leftView, middleView, rightView]
        
        // Set the root view to the navigation controller defined above
        self.window!.rootViewController = navigationController;
        self.window!.makeKeyAndVisible()
        
        
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

