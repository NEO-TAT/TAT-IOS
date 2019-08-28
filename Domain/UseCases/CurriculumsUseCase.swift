//
//  CurriculumsUseCase.swift
//  Domain
//
//  Created by jamfly on 2019/8/26.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import RxSwift

public protocol CurriculumsUseCase {
  func semesters(targetStudentId: String) -> Observable<[Semester]>
  func courses(targetStudentId: String, year: String, semester: String) -> Observable<Any>
}
