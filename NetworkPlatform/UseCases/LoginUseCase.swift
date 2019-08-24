//
//  LoginUseCase.swift
//  NetworkPlatform
//
//  Created by jamfly on 2019/8/24.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import Domain
import RxSwift
import Moya

final class LoginUseCase: Domain.LoginUseCase {

  private let provider: MoyaProvider<APIType>
  
  init() {
    provider = MoyaProvider<APIType>()
  }
  
  func login(studentId: String, password: String) -> Observable<Any> {
    return provider.rx.request(.login(studentId: studentId, password: password))
      .asObservable()
      .filterSuccessfulStatusCodes()
      .mapJSON()
  }
  
}
