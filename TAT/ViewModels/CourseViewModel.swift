//
//  CourseViewModel.swift
//  TAT
//
//  Created by jamfly on 2019/9/23.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import RxSwift
import RxCocoa

final class CourseViewModel: NSObject, ViewModelType {

  enum State {
    case success
    case loading
    case error(message: String)
  }

  struct Input {
    let year: Observable<String>
    let semester: Observable<String>
    let targetStudentId: Observable<String>
    let searchTrigger: Observable<Void>
  }

  struct Output {
    let state: Observable<State>
    let courses: Observable<[[Domain.Course]]>
  }

  private let curriculumsUseCase: Domain.CurriculumsUseCase

  override init() {
    let useCaseProvider = UseCaseProvider()
    curriculumsUseCase = useCaseProvider.makeCurriculumsUseCase()
  }

}

// MARK: - ViewModelType

extension CourseViewModel {

  func transform(input: Input) -> Output {
    let inputData = Observable.combineLatest(input.year,
                                             input.semester,
                                             input.targetStudentId)
    let state = PublishSubject<State>()

    let courses = input.searchTrigger
      .withLatestFrom(inputData)
      .flatMap { [unowned self] (year, semester, targetStudentId) -> Observable<CurriculumCourses> in
        state.onNext(.loading)
        return self.curriculumsUseCase.courses(targetStudentId: targetStudentId,
                                               year: year,
                                               semester: semester)
    }

    let coursesObseravle = courses
      .asObservable()
      .flatMap({ [unowned self] (curriculumCourses) -> Observable<[[Domain.Course]]> in
        var array: [[Domain.Course]] = self.initCourses()

        for course in curriculumCourses.courses {
          for (day, period) in course.periods.enumerated() {
            self.reshapCourses(period: period, day: day, course: course, array: &array)
          }
        }

        state.onNext(.success)
        return Observable.just(array)
      })

    return Output(state: state, courses: coursesObseravle)
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
