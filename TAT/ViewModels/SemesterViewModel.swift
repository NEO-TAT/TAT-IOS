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
    let searchTrigger: Observable<Void>
  }

  struct Output {
    let semesters: Observable<[Semester]>
    let state: Observable<State>
  }

  // MARK: - Properties

  private let curriculumsUseCase: Domain.CurriculumsUseCase

  // MARK: - Init

  override init() { curriculumsUseCase = UseCaseProvider().makeCurriculumsUseCase() }

}

// MARK: - ViewModelType

extension SemesterViewModel {

  func transform(input: SemesterViewModel.Input) -> SemesterViewModel.Output {
    let cachedTargetStudentId = UserDefaults.standard.string(forKey: "studentId") ?? ""
    let targetStudentIdOberable = Observable.merge(input.targetStudentId, Observable.just(cachedTargetStudentId))

    let state = ReplaySubject<State>.create(bufferSize: 1)

    let semesters = input.searchTrigger
      .withLatestFrom(targetStudentIdOberable)
      .do(onNext: { (targetStudentId) in
        print("targetStudentId \(targetStudentId)")
      })
      .flatMap { [unowned self] (targetStudentId) -> Observable<[Semester]> in
        state.onNext(.loading)
        return self.generateSemesters(from: targetStudentId)
      }
      .share()

    semesters
      .subscribe(onNext: { (semesters) in
        state.onNext(.success)
        if UserDefaults.standard.object(forKey: "semesters") == nil {
          guard let semesters = try? JSONEncoder().encode(semesters) else { return }
          UserDefaults.standard.set(semesters, forKey: "semesters")
        }
      }, onError: { (error) in
        state.onNext(.error(message: error.localizedDescription))
        print(error)
      })
      .disposed(by: rx.disposeBag)

    return Output(semesters: semesters, state: state.asObserver())
  }

}

// MARK: - Private Methods

extension SemesterViewModel {

  private func generateSemesters(from targetStudentId: String) -> Observable<[Semester]> {
     return curriculumsUseCase.semesters(targetStudentId: targetStudentId).asObservable()
  }

}
