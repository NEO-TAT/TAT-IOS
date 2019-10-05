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

  // MARK: - Properties

  private let curriculumsUseCase: Domain.CurriculumsUseCase

  // MARK: - Init

  override init() {
    let useCaseProvider = UseCaseProvider()
    curriculumsUseCase = useCaseProvider.makeCurriculumsUseCase()
  }

}

// MARK: - ViewModelType

extension CourseViewModel {

  func transform(input: Input) -> Output {
    let cachedTargetStudentId = UserDefaults.standard.string(forKey: "studentId") ?? ""
    let targetStudentIdOberable = Observable.merge(input.targetStudentId, Observable.just(cachedTargetStudentId))
    let inputData = Observable.combineLatest(input.year,
                                             input.semester,
                                             targetStudentIdOberable)
    let state = ReplaySubject<State>.create(bufferSize: 1)

    let courses = input.searchTrigger
      .withLatestFrom(inputData)
      .do(onNext: { (year, semester, taregtStudentId) in
        print("year \(year) semester \(semester) targetStudentId \(taregtStudentId)")
      })
      .filter { $0 != "" && $1 != "" && $2 != "" }
      .flatMap { [unowned self] (year, semester, targetStudentId) -> Observable<[[Domain.Course]]> in
        state.onNext(.loading)
        return self.generateCourses(year: year, semester: semester, targetStudentId: targetStudentId)
      }
      .share(replay: 1)

    courses
      .subscribe(onNext: { (courses) in
        state.onNext(.success)
        if UserDefaults.standard.object(forKey: "courses") == nil {
          guard let courses = try? JSONEncoder().encode(courses) else { return }
          UserDefaults.standard.set(courses, forKey: "courses")
        }
      }, onError: { (error) in
        print(error)
        state.onNext(.error(message: "cannot get courses"))
      })
      .disposed(by: rx.disposeBag)

    return Output(state: state, courses: courses)
  }

}

// MARK: - Private Methods

extension CourseViewModel {

  private func generateCourses(year: String, semester: String, targetStudentId: String) -> Observable<[[Domain.Course]]> {
    return self.curriculumsUseCase.courses(targetStudentId: targetStudentId,
                                                 year: year,
                                                 semester: semester).asObservable()
  }

}
