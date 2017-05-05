//
//  AppDelegate.swift
//  Praxs
//
//  Created by Denis Ricard on 2017-04-14.
//  Copyright © 2017 Denis Ricard. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var daily = Daily()
    var routine = Routine()

    func loadSampleData() {
        
        // Create contexts
        
        let sleepContext = Context(hours: 22, minutes: 30, previous: nil, next: nil, color: 2, title: "Getting ready to sleep")
        let eveningContext = Context(hours: 18, minutes: 30, previous: nil, next: sleepContext, color: 3, title: "Evening")
        let afternoonCommuteContext = Context(hours: 17, minutes: 30, previous: nil, next: eveningContext, color: 1, title: "Afternoon Commute")
        let workContext = Context(hours: 8, minutes: 30, previous: nil, next: afternoonCommuteContext, color: 4, title: "Work")
        let morningCommute = Context(hours: 7, minutes: 30, previous: nil, next: workContext, color: 1, title: "Morning commute")
        let morningContext = Context(hours: 6, minutes: 30, previous: nil, next: morningCommute, color: 0, title: "Morning")
        morningCommute.previous = morningContext
        workContext.previous = morningCommute
        afternoonCommuteContext.previous = workContext
        eveningContext.previous = afternoonCommuteContext
        sleepContext.previous = eveningContext
        daily.contexts.append(morningContext)
        daily.contexts.append(morningCommute)
        daily.contexts.append(workContext)
        daily.contexts.append(afternoonCommuteContext)
        daily.contexts.append(eveningContext)
        daily.contexts.append(sleepContext)
        
        // Create a routine
        for index in 0...5 {
            let task = Task(name: "task \(index)", time: index * 5 + 45, done: index % 2 == 0)
            routine.tasks.append(task)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // load sample data
        loadSampleData()
        
        // inject daily
        guard let navController = window?.rootViewController as? UINavigationController, let viewController = navController.topViewController as? ContextVC else { return true }
        viewController.daily = daily
        viewController.routine = routine
        
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
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

