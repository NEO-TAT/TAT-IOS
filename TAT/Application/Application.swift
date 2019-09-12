//
//  Application.swift
//  TAT
//
//  Created by jamfly on 2019/8/24.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import Domain
import Network
import NSObject_Rx

final class Application {

  static let shared = Application()

  func configurateMainInterface(in window: UIWindow?) {
    window?.rootViewController = MainTabBarController()
    window?.makeKeyAndVisible()
  }

}
