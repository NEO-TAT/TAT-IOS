//
//  NetworkProvvider.swift
//  NetworkPlatform
//
//  Created by jamfly on 2019/10/4.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Domain
import NSObject_Rx

final class NetworkProvvider<Target>: NSObject where Target: Moya.TargetType {

  // MARL: - Properties

  private let provider: MoyaProvider<Target>

  // MARL: - Init

  init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
       requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
       stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
       manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
       plugins: [PluginType] = [],
       trackInflights: Bool = false) {

    self.provider = MoyaProvider(endpointClosure: endpointClosure,
                                 requestClosure: requestClosure,
                                 stubClosure: stubClosure,
                                 manager: manager,
                                 plugins: plugins,
                                 trackInflights: trackInflights)
  }

  // MARK: - Methods

  func request(_ token: Target) -> Single<Moya.Response> {
    let request = provider.rx.request(token)
    return request
      .flatMap { (response)  in
        if response.statusCode == 401 {
          return self.refreshToken().flatMap { _ in return self.request(token) }
        } else {
          return Single.just(response)
        }
    }

  }

}

// MARK: - Private Methods

extension NetworkProvvider {

  private func refreshToken() -> Single<Domain.Token> {
    return Single.create { [weak self] (subscriber) -> Disposable in
      guard let self = self else { return Disposables.create() }
      guard let studentId = UserDefaults.standard.string(forKey: "studentId"),
        let password = UserDefaults.standard.string(forKey: "password") else {
          subscriber(.error(LoginError.wrongMailOrPassword))
          return Disposables.create()
      }

      LoginUseCase().login(studentId: studentId, password: password)
        .subscribe(onSuccess: { (token) in
          if let token = try? JSONEncoder().encode(token) {
            UserDefaults.standard.set(token, forKey: "token")
          }
          subscriber(.success(token))
        }) { (error) in
          subscriber(.error(error))
      }
      .disposed(by: self.rx.disposeBag)

      return Disposables.create()
    }
  }

}
