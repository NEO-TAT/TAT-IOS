//
//  CurriculumCourses.swift
//  Domain
//
//  Created by jamfly on 2019/8/28.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation

public struct CurriculumCourses: Codable {

  public let courses: [Course]
  public let hasNoPeriodsCourses: Bool
  public let hasSaturdayCourses: Bool
  public let hasSundayCourses: Bool

}
