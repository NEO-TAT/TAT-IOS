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

  struct Input {}
  struct Output {}

}

// MARK: - ViewModelType

extension SemesterViewModel {

  func transform(input: SemesterViewModel.Input) -> SemesterViewModel.Output {
    return Output()
  }

}
