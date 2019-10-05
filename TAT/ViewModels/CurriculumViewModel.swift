//
//  CurriculumViewModel.swift
//  TAT
//
//  Created by jamfly on 2019/9/12.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import RxSwift
import RxCocoa

final class CurriculumViewModel: NSObject, ViewModelType {

  struct Input {
    let targetStudentId: Observable<String>
    let searchSemesterTrigger: Observable<Void>
    let searchCourseTrigger: Observable<Void>
    let yearObserver: Observable<String>
    let semesterObserver: Observable<String>
  }

  struct Output {
    let state: Observable<State>
    let semesters: Observable<[Semester]>
    let courses: Observable<[[Course]]>
  }

  // MARK: - Properties

  private let semesterViewModel: SemesterViewModel
  private let courseViewModel: CourseViewModel

  // MARK: - Init

  override init() {
    semesterViewModel = SemesterViewModel()
    courseViewModel = CourseViewModel()
  }

}

// MARK: - ViewModelType

extension CurriculumViewModel {

  func transform(input: Input) -> Output {
    let semesterInput = SemesterViewModel.Input(targetStudentId: input.targetStudentId, searchTrigger: input.searchSemesterTrigger)
    let semesterOutput = semesterViewModel.transform(input: semesterInput)

    let courseInput = CourseViewModel.Input(year: input.yearObserver,
                                            semester: input.semesterObserver,
                                            targetStudentId: input.targetStudentId,
                                            searchTrigger: input.searchCourseTrigger)
    let courseOutput = courseViewModel.transform(input: courseInput)
    let stateObserver = Observable.merge(semesterOutput.state, courseOutput.state)
    return Output(state: stateObserver,
                  semesters: semesterOutput.semesters,
                  courses: courseOutput.courses)
  }

}
