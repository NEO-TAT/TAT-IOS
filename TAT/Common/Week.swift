//
//  Week.swift
//  TAT
//
//  Created by jamfly on 2019/9/23.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation

enum Week: Int {
  case sunday
  case monday
  case tuesday
  case wednesday
  case thursday
  case friday
  case saturday
}

extension Week {

  func toString() -> String {
    switch self {
    case .monday: return "Mon."
    case .tuesday: return "Tue."
    case .wednesday: return "Wed."
    case .thursday: return "Thur."
    case .friday: return "Fri."
    case .saturday: return "Sat"
    case .sunday: return ""
    }
  }

}
