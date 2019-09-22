//
//  CurriculumViewModel.swift
//  TAT
//
//  Created by jamfly on 2019/9/12.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import RxSwift
import RxCocoa

final class CurriculumViewModel: NSObject, ViewModelType {

  struct Input {}

  struct Output {}
}

// MARK: - ViewModelType

extension CurriculumViewModel {

  func transform(input: Input) -> Output {
    return Output()
  }

}
