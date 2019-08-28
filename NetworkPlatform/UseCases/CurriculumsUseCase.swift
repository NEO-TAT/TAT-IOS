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

  private let provider: MoyaProvider<APIType>

  init() { provider = MoyaProvider<APIType>() }

  func semesters(targetStudentId: String) -> Observable<[Domain.Semester]> {
    return provider.rx.request(.semesters(targetStudentId: targetStudentId))
      .asObservable()
      .filterSuccessfulStatusCodes()
      .map([Domain.Semester].self)
  }

  func courses(targetStudentId: String, year: String, semester: String) -> Observable<Domain.CurriculumCourses> {
    return provider.rx.request(.courses(targetStudentId: targetStudentId, year: year, semester: semester))
      .asObservable()
      .filterSuccessfulStatusCodes()
      .map(Domain.CurriculumCourses.self)
  }

}
