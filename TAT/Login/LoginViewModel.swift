//
//  LoginViewModel.swift
//  TAT
//
//  Created by jamfly on 2019/9/4.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import RxSwift
import RxCocoa

final class LoginViewModel: NSObject, ViewModelType {

  enum State {
    case success
    case loading
    case error(message: String)
  }

  struct Input {
    let studentId: Observable<String>
    let password: Observable<String>
    let store: Observable<Void>
  }

  struct Output {
    let state: Observable<State>
  }

  private let loginUseCase: Domain.LoginUseCase

  override init() {
    let useCaseProvider = UseCaseProvider()
    loginUseCase = useCaseProvider.makeLoginUseCase()
  }

}

// MARK: - ViewModelType

extension LoginViewModel {

  func transform(input: Input) -> Output {
    let inputData = Observable.combineLatest(input.studentId, input.password)
    let state = PublishSubject<State>()

    let token = input.store
      .withLatestFrom(inputData)
      .flatMapLatest { [unowned self] (studentId, password) -> Observable<Token> in
        state.onNext(.loading)
        return self.loginUseCase.login(studentId: studentId, password: password)
      }

    token
      .asObservable()
      .subscribe(onNext: { (token) in
        let encoder = JSONEncoder()
        guard let token = try? encoder.encode(token) else { return state.onNext(.error(message: "cannot store token")) }
        UserDefaults.standard.set(token, forKey: "token")
        state.onNext(.success)
      }, onError: { (error) in
        print(error)
        state.onNext(.error(message: error.localizedDescription))
      })
      .disposed(by: rx.disposeBag)

    return Output(state: state)
  }

}
