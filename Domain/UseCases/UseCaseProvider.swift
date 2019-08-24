//
//  UseCaseProvider.swift
//  Domain
//
//  Created by jamfly on 2019/8/24.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation

public protocol UseCaseProvider {
  func makeLoginUseCase() -> LoginUseCase
}
