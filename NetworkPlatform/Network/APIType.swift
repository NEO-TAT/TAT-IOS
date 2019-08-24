//
//  Api.swift
//  NetworkPlatform
//
//  Created by jamfly on 2019/8/24.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import RxSwift
import Moya

enum APIType {
  case login(studentId: String, password: String)
}

extension APIType: TargetType {
  
  var baseURL: URL {
    switch self {
    case .login: return URL(string: "http://localhost:8080")!
    }
  }
  
  var path: String {
    switch self {
    case .login: return "/login"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .login: return .post
    }
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var parameters: [String: Any]? {
    var params: [String: Any] = [:]
    switch self {
    case .login(let studentId, let password):
      params["studentID"] = studentId
      params["password"] = password
    }
    return params
  }
  
  var task: Task {
    guard let parameters = parameters else { return .requestPlain }
    switch self {
    case .login: return .requestParameters(parameters: parameters, encoding: URLEncoding.httpBody)
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
  
}
