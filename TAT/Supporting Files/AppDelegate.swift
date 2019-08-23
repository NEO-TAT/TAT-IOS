//
//  AppDelegate.swift
//  TAT
//
//  Created by jamfly on 2019/8/23.
//  Copyright © 2019 jamfly. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    guard let window = window else { fatalError("there's no window") }
    window.rootViewController = ViewController()
    window.makeKeyAndVisible()
    
    return true
  }
  
}
