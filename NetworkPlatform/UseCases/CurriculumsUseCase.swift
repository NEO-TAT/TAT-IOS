//
//  CurriculumsUseCase.swift
//  NetworkPlatform
//
//  Created by jamfly on 2019/8/26.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import Domain
import RxSwift
import Moya

final class CurriculumsUseCase: Domain.CurriculumsUseCase {

  // MARK: - Properties

  private let provider: MoyaProvider<APIType>

  // MARK: - Init

  init() { provider = MoyaProvider<APIType>() }

  // MARK: Methods

  func semesters(targetStudentId: String) -> Observable<[Domain.Semester]> {
    return provider.rx.request(.semesters(targetStudentId: targetStudentId))
      .asObservable()
      .filterSuccessfulStatusCodes()
      .map([Domain.Semester].self)
  }

  func courses(targetStudentId: String, year: String, semester: String) -> Observable<[[Domain.Course]]> {
    return provider.rx.request(.courses(targetStudentId: targetStudentId,
                                        year: year,
                                        semester: semester))
      .asObservable()
      .filterSuccessfulStatusCodes()
      .map(Domain.CurriculumCourses.self)
      .map(generateCourses)
  }

}

// MARK: - Private Methods

extension CurriculumsUseCase {

  private func generateCourses(from curriculumCourses: Domain.CurriculumCourses) -> [[Domain.Course]] {
    var array: [[Domain.Course]] = self.initCourses()
    for course in curriculumCourses.courses {
      for (day, period) in course.periods.enumerated() {
        self.reshapCourses(period: period,
                           day: day,
                           course: course,
                           array: &array)
      }
    }
    return array
  }

  private func reshapCourses(period: String, day: Int, course: Course, array: inout[[Domain.Course]]) {
    if period.count > 0 {
      let periods = period.split(separator: " ")
      periods.forEach { (period) in
        let section = Int(String(period), radix: 16) ?? 0
        array[section - 1][day] = course
      }
    }
  }

  private func initCourses() -> [[Domain.Course]] {
    let array = [[Domain.Course]].init(
      repeating: [Course].init(
        repeating: Course(id: "",
                          name: "",
                          instructor: [],
                          periods: [],
                          classroom: []),
        count: 7),
      count: 13)
    return array
  }

}
