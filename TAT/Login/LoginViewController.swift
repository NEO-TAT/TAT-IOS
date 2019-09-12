//
//  LoginViewController.swift
//  TAT
//
//  Created by jamfly on 2019/9/4.
//  Copyright © 2019 jamfly. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class LoginViewController: UIViewController, UITextFieldDelegate {

  private let viewModel: LoginViewModel = LoginViewModel()

  private lazy var studentIdTextField: UITextField = {
    let studentIdTextField = UITextField(frame: .zero)
    studentIdTextField.placeholder = "Plz enter your student id"
    studentIdTextField.borderStyle = .roundedRect
    let account = UserDefaults.standard.string(forKey: "studentId")
    studentIdTextField.text = account
    return studentIdTextField
  }()

  private lazy var passwordTextField: UITextField = {
    let passwordTextField = UITextField(frame: .zero)
    passwordTextField.placeholder = "Plz enter your password"
    passwordTextField.borderStyle = .roundedRect
    passwordTextField.isSecureTextEntry = true
    return passwordTextField
  }()

  private lazy var storeButton: UIButton = {
    let storeButton = UIButton(frame: .zero)
    storeButton.setTitle("store", for: .normal)
    storeButton.backgroundColor = UIColor.blue
    storeButton.layer.cornerRadius = 5
    return storeButton
  }()

  private lazy var clearButton: UIButton = {
    let clearButton = UIButton(frame: .zero)
    clearButton.setTitle("clear", for: .normal)
    clearButton.backgroundColor = UIColor.red
    clearButton.layer.cornerRadius = 5
    return clearButton
  }()

  private lazy var activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    activityIndicator.color = .blue
    return activityIndicator
  }()

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    tabBarController?.title = "login"
    setUpLayouts()
    setUpButtonsTap()
    bindViewModel()
  }

  // MARK: - Private Methonds

  private func bindViewModel() {
    let input = LoginViewModel.Input(studentId: studentIdTextField.rx.text.orEmpty.asObservable(),
                                     password: passwordTextField.rx.text.orEmpty.asObservable(),
                                     store: storeButton.rx.tap.asObservable())
    let output = viewModel.transform(input: input)

    output.state
      .asObservable()
      .subscribe(onNext: { [weak self] (state) in
        switch state {
        case .loading: self?.activityIndicator.startAnimating()
        default: self?.activityIndicator.stopAnimating()
        }
        print(state)
      }, onError: { (error) in
        print(error)
      })
      .disposed(by: rx.disposeBag)

  }

  private func setUpLayouts() {
    setUpTextFields()
    setUpButtons()
    setUpActivityIndicator()
  }

  private func setUpTextFields() {
    view.addSubview(studentIdTextField)
    view.addSubview(passwordTextField)

    studentIdTextField.delegate = self
    passwordTextField.delegate = self

    studentIdTextField.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.center.equalToSuperview()
      make.width.equalTo(view.bounds.width * 0.8)
    }

    passwordTextField.snp.makeConstraints { (make) in
      make.left.equalTo(studentIdTextField)
      make.right.equalTo(studentIdTextField)
      make.top.equalTo(studentIdTextField.snp.bottom).offset(30)
    }
  }

  private func setUpButtons() {
    view.addSubview(clearButton)
    view.addSubview(storeButton)

    clearButton.snp.makeConstraints { (make) in
      make.top.equalTo(passwordTextField.snp.bottom).offset(20)
      make.left.equalTo(passwordTextField)
      make.width.equalTo(view.bounds.width * 0.8 * 0.4)
      make.height.equalTo(studentIdTextField)
    }

    storeButton.snp.makeConstraints { (make) in
      make.top.equalTo(clearButton)
      make.bottom.equalTo(clearButton)
      make.right.equalTo(passwordTextField)
      make.width.equalTo(clearButton)
    }
  }

  private func setUpActivityIndicator() {
    view.addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
  }

  private func emptyTextField(_ textField: UITextField) -> Binder<Void> {
    return Binder<Void>(textField) { (textField, _) in textField.text = nil }
  }

  private func setUpButtonsTap() {
    let emptyStudentId = emptyTextField(studentIdTextField)
    let emptyPassword = emptyTextField(passwordTextField)

    clearButton.rx.tap
      .observeOn(MainScheduler.instance)
      .bind(to: emptyStudentId)
      .disposed(by: rx.disposeBag)

    clearButton.rx.tap
      .observeOn(MainScheduler.instance)
      .bind(to: emptyPassword)
      .disposed(by: rx.disposeBag)
  }

}

// MARK: - UITextFieldDelegate

extension LoginViewController {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

}

extension LoginViewController {

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if (studentIdTextField.isFirstResponder) {
      studentIdTextField.resignFirstResponder()
    } else if (passwordTextField.isFirstResponder) {
      passwordTextField.resignFirstResponder()
    }
  }

}
