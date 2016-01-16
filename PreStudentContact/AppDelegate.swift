//
//  AppDelegate.swift
//  PreStudentContact
//
//  Created by kerautret on 12/11/2015.
//  Copyright © 2015 ker. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var mainController : MainInputController?

  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    mainController =  window?.rootViewController as? MainInputController

    let sharedDefault = NSUserDefaults.standardUserDefaults()
    if checkExistSavingFile() {
      print("FILE exist no creation")
    }else
    {
      print("FILE no exist creation")
    }
    if sharedDefault.objectForKey("FORUM_NAME") == nil {
      sharedDefault.setObject("ForumNoName", forKey: "FORUM_NAME")     
    }
    if sharedDefault.objectForKey("MAIL_DEST") == nil {
      sharedDefault.setObject("delphine.george@univ-lorraine.fr", forKey: "MAIL_DEST")
    }
    if sharedDefault.objectForKey("ARRAY_SAVE") == nil {
      let dico = Array<String>()
      sharedDefault.setObject(dico, forKey: "ARRAY_SAVE")
    }
    application.idleTimerDisabled = true;
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    mainController?.loadDate()
    
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

