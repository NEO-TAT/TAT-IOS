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
import Domain

enum APIType {
  case login(studentId: String, password: String)
  case semesters(targetStudentId: String)
  case courses(targetStudentId: String, year: String, semester: String)
}

extension APIType: TargetType {
  
  var baseURL: URL {
    return  URL(string: "https://tat.ntut.club")!
  }
  
  var path: String {
    switch self {
    case .login: return "/login"
    case .semesters: return "auth/curriculums/semesters"
    case .courses: return "auth/curriculums/courses"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .login: return .post
    default: return .get
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
    case .semesters(let targetStudentId):
      params["targetStudentID"] = targetStudentId
    case .courses(let targetStudentId, let year, let semester):
      params["targetStudentID"] = targetStudentId
      params["year"] = year
      params["semester"] = semester
    }
    return params
  }
  
  var task: Task {
    guard let parameters = parameters else { return .requestPlain }
    switch self {
    case .login: return .requestParameters(parameters: parameters, encoding: URLEncoding.httpBody)
    case .semesters: return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    case .courses: return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }
  }
  
  var token: String {
    guard let tokenData = UserDefaults.standard.object(forKey: "token") as? Data else {
      return ""
    }
    guard let token = try? JSONDecoder().decode(Domain.Token.self, from: tokenData) else {
      fatalError("cannot cast token")
    }
    return token.token
  }
  
  var headers: [String : String]? {
    var headers: [String: String] = [:]
    switch self {
    case .login: break
    default:
      headers["Authorization"] = "Bearer " + token
    }
    return headers
  }
  
}
