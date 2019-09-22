//
//  SemesterViewModel.swift
//  TAT
//
//  Created by jamfly on 2019/9/13.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import RxSwift
import RxCocoa

final class SemesterViewModel: NSObject, ViewModelType {

  struct Input {
    let targetStudentId: Observable<String>
  }

  struct Output {
    let semesters: Observable<[Semester]>
  }

  private let curriculumsUseCase: Domain.CurriculumsUseCase

  override init() {
    let useCaseProvider = UseCaseProvider()
    curriculumsUseCase = useCaseProvider.makeCurriculumsUseCase()
  }

}

// MARK: - ViewModelType

extension SemesterViewModel {

  func transform(input: SemesterViewModel.Input) -> SemesterViewModel.Output {

    let semesters = input.targetStudentId.flatMap { [unowned self] (targetStudentId) -> Observable<[Semester]> in
      return self.curriculumsUseCase.semesters(targetStudentId: targetStudentId)
    }

    return Output(semesters: semesters)
  }

}
