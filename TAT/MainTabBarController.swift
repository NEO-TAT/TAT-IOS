//
//  MainTabBarController.swift
//  TAT
//
//  Created by jamfly on 2019/8/23.
//  Copyright © 2019 jamfly. All rights reserved.
//

import UIKit

final class MainTabBarController: UITabBarController {

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setUpViewControllers()
  }

  // MARK: - Private Methods

  private func setUpViewControllers() {
    let loginVC = LoginViewController()
    let curriculum = CurriculumViewController()

    loginVC.tabBarItem.title = "login"
    curriculum.tabBarItem.title = "curriculum"

    viewControllers = [loginVC, curriculum]
    selectedViewController = loginVC
  }

}
