//
//  ViewModelType.swift
//  TAT
//
//  Created by jamfly on 2019/9/7.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation

protocol ViewModelType {
  associatedtype Input
  associatedtype Output

  func transform(input: Input) -> Output
}
