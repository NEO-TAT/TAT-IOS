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
    let state = ReplaySubject<State>.create(bufferSize: 1)

    let courses = input.searchTrigger
      .withLatestFrom(inputData)
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

  private func generateCourses(year: String, semester: String, targetStudentId: String) -> Observable<[[Domain.Course]]> {
    guard let cachedData = UserDefaults.standard.object(forKey: "courses") as? Data,
      let cachedCourses = try? JSONDecoder().decode([[Domain.Course]].self, from: cachedData) else {
      return self.curriculumsUseCase.courses(targetStudentId: targetStudentId,
                                             year: year,
                                             semester: semester)
    }
    return .just(cachedCourses)
  }

}
