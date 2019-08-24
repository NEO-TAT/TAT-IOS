//
//  TATApi.swift
//  NetworkPlatform
//
//  Created by jamfly on 2019/8/24.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import RxSwift

protocol TATAPI {
  func loging(studentId: String, password: String) -> Observable<Any>
}
