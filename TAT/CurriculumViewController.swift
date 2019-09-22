//
//  CurriculumViewController.swift
//  TAT
//
//  Created by jamfly on 2019/9/4.
//  Copyright © 2019 jamfly. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class CurriculumViewController: UIViewController {

  private let viewModel: CurriculumViewModel = CurriculumViewModel()

  private lazy var searchButton: UIButton = {
    let searchButton = UIButton(frame: .zero)
    searchButton.setTitle("search", for: .normal)
    return searchButton
  }()

  private lazy var activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    activityIndicator.color = .blue
    return activityIndicator
  }()

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .yellow
    tabBarController?.title = "curriculum"

    setUpLayouts()
    bindViewModel()
  }

  // MARK: - Private Methonds

  private func bindViewModel() {
    let input = CurriculumViewModel.Input(year: Observable.just("108"),
                                          semester: Observable.just("1"),
                                          targetStudentId: Observable.just("104440026"),
                                          searchTrigger: searchButton.rx.tap.asObservable())
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
    setUpButtonsLayout()
    setUpActivityIndicator()
  }

  private func setUpButtonsLayout() {
    view.addSubview(searchButton)

    searchButton.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.size.equalTo(CGSize(width: 50, height: 50))
    }
  }

  private func setUpActivityIndicator() {
     view.addSubview(activityIndicator)
     activityIndicator.snp.makeConstraints { (make) in
       make.center.equalToSuperview()
     }
   }

}
