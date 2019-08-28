//
//  LoginUseCaseProvider.swift
//  NetworkPlatform
//
//  Created by jamfly on 2019/8/24.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import Domain

public final class UseCaseProvider: Domain.UseCaseProvider {
  
  public init() {}
  
  public func makeLoginUseCase() -> Domain.LoginUseCase {
    return LoginUseCase()
  }
  
  public func makeCurriculumsUseCase() -> Domain.CurriculumsUseCase {
    return CurriculumsUseCase()
  }
  
}
