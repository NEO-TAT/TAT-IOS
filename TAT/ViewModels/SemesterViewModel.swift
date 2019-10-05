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

    let semesters = input.searchTrigger
      .withLatestFrom(targetStudentIdOberable)
      .do(onNext: { (targetStudentId) in
        print("targetStudentId \(targetStudentId)")
      })
      .flatMap(generateSemesters(from:))
      .share()

    semesters
      .subscribe(onNext: { (semesters) in
        if UserDefaults.standard.object(forKey: "semesters") == nil {
          guard let semesters = try? JSONEncoder().encode(semesters) else { return }
          UserDefaults.standard.set(semesters, forKey: "semesters")
        }
      }, onError: { (error) in
        print(error)
      })
      .disposed(by: rx.disposeBag)

    return Output(semesters: semesters)
  }

}

// MARK: - Private Methods

extension SemesterViewModel {

  private func generateSemesters(from targetStudentId: String) -> Observable<[Semester]> {
    guard let cachedTargetStudentId = UserDefaults.standard.string(forKey: "studentId"),
      cachedTargetStudentId == targetStudentId,
      let cachedData = UserDefaults.standard.object(forKey: "semesters") as? Data,
      let cachedSemesters = try? JSONDecoder().decode([Semester].self, from: cachedData)else {
        return curriculumsUseCase.semesters(targetStudentId: targetStudentId).asObservable()
      }

    return .just(cachedSemesters)
  }

}
