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
  }

  private let curriculumsUseCase: Domain.CurriculumsUseCase

  override init() {
    let useCaseProvider = UseCaseProvider()
    curriculumsUseCase = useCaseProvider.makeCurriculumsUseCase()
  }

}

// MARK: - ViewModelType

extension CurriculumViewModel {

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

    courses
      .asObservable()
      .subscribe(onNext: { (courses) in
        print("courses \(courses)")
        state.onNext(.success)
      }, onError: { (error) in
        print(error)
        state.onNext(.error(message: error.localizedDescription))
      })
      .disposed(by: rx.disposeBag)

    return Output(state: state)
  }

}
