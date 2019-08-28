//
//  Token.swift
//  Domain
//
//  Created by jamfly on 2019/8/27.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation

public struct Token: Codable {
  
  public let code: Int
  public let expire: String
  public let token: String

}
