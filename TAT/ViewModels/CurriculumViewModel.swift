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
    let searchTrigger: Observable<Void>
  }

  struct Output {
    let state: Observable<CourseViewModel.State>
    let semesters: Observable<[Semester]>
  }

  private let semesterViewModel: SemesterViewModel
  private let courseViewModel: CourseViewModel

  override init() {
    semesterViewModel = SemesterViewModel()
    courseViewModel = CourseViewModel()
  }

}

// MARK: - ViewModelType

extension CurriculumViewModel {

  func transform(input: Input) -> Output {
    let semesterInput = SemesterViewModel.Input(targetStudentId: input.targetStudentId)

    let semesters = semesterViewModel.transform(input: semesterInput).semesters

    let courseInput = CourseViewModel.Input(year: Observable.just("108"),
                                            semester: Observable.just("1"),
                                            targetStudentId: input.targetStudentId,
                                            searchTrigger: input.searchTrigger)

    let state = courseViewModel.transform(input: courseInput).state

    return Output(state: state,
                  semesters: semesters)
  }

}
