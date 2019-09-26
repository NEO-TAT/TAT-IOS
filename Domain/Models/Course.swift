//
//  Course.swift
//  Domain
//
//  Created by jamfly on 2019/8/28.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation

public struct Course: Codable {

  public let id: String
  public let name: String
  public let instructor: [String]
  public let periods: [String]
  public let classroom: [String]

  public init(id: String,
             name: String,
             instructor: [String],
             periods: [String],
             classroom: [String]) {
    self.id = id
    self.name = name
    self.instructor = instructor
    self.periods = periods
    self.classroom = classroom
  }

}
