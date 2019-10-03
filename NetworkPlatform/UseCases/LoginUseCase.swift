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

  // MARK: - Properties

  private let provider: NetworkProvvider<APIType>

  // MARK: - Init

  init() { provider = NetworkProvvider<APIType>() }

  // MARK: - Methods

  func login(studentId: String, password: String) -> Single<Domain.Token> {
    return provider.request(.login(studentId: studentId, password: password))
      .filterSuccessfulStatusCodes()
      .map(Domain.Token.self)
  }

}
