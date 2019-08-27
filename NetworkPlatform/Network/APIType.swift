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
    return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NjY3NTIxNjYsIm9yaWdfaWF0IjoxNTY2NzQ4NTY2LCJwYXNzd29yZCI6Im50dXRoYWNrZXIwMTMxIiwic3R1ZGVudElEIjoiMTA0NDQwMDI2In0.1Up2Pvw48ZNnbYNqVpTHamSRZupNWzwx8JHFWrq2juQ"
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
