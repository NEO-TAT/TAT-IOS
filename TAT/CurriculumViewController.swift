//
//  CurriculumViewController.swift
//  TAT
//
//  Created by jamfly on 2019/9/4.
//  Copyright © 2019 jamfly. All rights reserved.
//

import UIKit.UIViewController
import RxSwift
import RxCocoa
import SnapKit
import Dropdowns

final class CurriculumViewController: UIViewController {

  private let semestersViewModel: SemesterViewModel = SemesterViewModel()
  private let courseViewModel: CourseViewModel = CourseViewModel()

  private lazy var activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    activityIndicator.color = .blue
    return activityIndicator
  }()

  private lazy var leftBarItem: UIBarButtonItem = {
    return UIBarButtonItem(barButtonSystemItem: .search,
                           target: self,
                           action: nil)
  }()

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .yellow
    tabBarController?.title = "curriculum"

    setUpNavigationBarItems()
    setUpLayouts()
    bindViewModel()
  }

  // MARK: - Private Methonds

  private func setUpNavigationBarItems() {
    title = "curriculum"
    navigationItem.leftBarButtonItem = leftBarItem
  }

  private func updateTitleView(by items: [String]) {
    guard let navigationController = navigationController else { return }
    let titleView = TitleView(navigationController: navigationController,
                              title: items.first ?? "",
                              items: items)
    navigationItem.titleView = titleView
  }

  private func bindViewModel() {
    bindSemesterViewModel()
    bindCurriculumViewModel()
  }

  private func bindSemesterViewModel() {
    let input = SemesterViewModel.Input(targetStudentId: Observable.just("104440026"))
    let output = semestersViewModel.transform(input: input)

    output.semesters
      .asObservable()
      .subscribe(onNext: { [weak self] (semesters) in
        print(semesters)
        let semsterString = semesters.map { "\($0.year) 學年 第\($0.semester)學期" }
        self?.updateTitleView(by: semsterString)
      })
      .disposed(by: rx.disposeBag)
  }

  private func bindCurriculumViewModel() {
    let input = CourseViewModel.Input(year: Observable.just("108"),
                                             semester: Observable.just("1"),
                                             targetStudentId: Observable.just("104440026"),
                                             searchTrigger: leftBarItem.rx.tap.asObservable())
       let output = courseViewModel.transform(input: input)

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
    setUpActivityIndicator()
  }

  private func setUpActivityIndicator() {
     view.addSubview(activityIndicator)
     activityIndicator.snp.makeConstraints { (make) in
       make.center.equalToSuperview()
     }
   }

}
