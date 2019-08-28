//
//  LoginUseCase.swift
//  Domain
//
//  Created by jamfly on 2019/8/24.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import RxSwift

public protocol LoginUseCase {
  func login(studentId: String, password: String) -> Observable<Token>
}
