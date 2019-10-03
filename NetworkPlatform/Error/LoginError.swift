//
//  LoginError.swift
//  NetworkPlatform
//
//  Created by jamfly on 2019/10/4.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation

enum LoginError: Error {
  case wrongMailOrPassword
  case tokenExpired
}
