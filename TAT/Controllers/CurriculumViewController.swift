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
import IBPCollectionViewCompositionalLayout
import Domain

final class CurriculumViewController: UIViewController {

  // MARK: - Properties

  private let viewModel: CurriculumViewModel = CurriculumViewModel()
  private let searchButtonTapped = PublishSubject<Void>()

  private var isSearchBarHidden: Bool = true {
    didSet {
      searchBar.isHidden = self.isSearchBarHidden
      collectionView.snp.removeConstraints()
      setUpCollectionView()
    }
  }

  private lazy var activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    activityIndicator.color = .systemPink
    return activityIndicator
  }()

  private lazy var leftBarItem: UIBarButtonItem = {
    return UIBarButtonItem(barButtonSystemItem: .search,
                           target: self,
                           action: nil)
  }()

  private lazy var searchBar: UISearchBar = {
    let searchBar = UISearchBar(frame: .zero)
    searchBar.backgroundColor = .white
    searchBar.showsCancelButton = true
    searchBar.delegate = self
    let targetStudentId = UserDefaults.standard.string(forKey: "studentId") ?? "please store your feaking student id"
    searchBar.placeholder = targetStudentId
    return searchBar
  }()

  private lazy var collectionView: UICollectionView = {
    let collectionViewLayout = generateLayout()
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: collectionViewLayout)
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = .black
    collectionView.dataSource = self
    collectionView.delegate = self

    collectionView.register(DayCell.self,
                            forCellWithReuseIdentifier: String(describing: DayCell.self))
    collectionView.register(CourseCell.self,
                            forCellWithReuseIdentifier: String(describing: CourseCell.self))
    return collectionView
  }()

  private lazy var sections: [Section] = {
    var sections: [Section] = [WeekSection()]
    for i in 0..<13 {
      sections.append(CurriculumSection(items: []))
    }
    return sections
  }()

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
    tabBarController?.title = "curriculum"

    setUpNavigationBarItems()
    setUpLayouts()
    bindViewModel()
  }

}

// MARK: - Private Methods

extension CurriculumViewController {

  private func setUpNavigationBarItems() {
    navigationItem.leftBarButtonItem = leftBarItem
  }

  private func updateTitleView(by items: [String]) -> TitleView? {
    guard let navigationController = navigationController else { return nil }
    let titleView = TitleView(navigationController: navigationController,
                              title: items.first ?? "",
                              items: items)
    navigationItem.titleView = titleView
    return titleView
  }

  private func bindViewModel() {
    let yearSubject: PublishSubject<String> = PublishSubject<String>()
    let semesterSubject: PublishSubject<String> = PublishSubject<String>()
    let searchSemesterSubject: BehaviorSubject<Void> = BehaviorSubject<Void>(value: ())
    let searchCourseSubject: PublishSubject<Void> = PublishSubject<Void>()

    var semesterIndex: Int = 0

    searchSemesterSubject
      .subscribe(onNext: { (_) in
      print("search semester")
    }).disposed(by: rx.disposeBag)

    let input = CurriculumViewModel.Input(targetStudentId: searchBar.rx.text.orEmpty.asObservable(),
                                          searchSemesterTrigger: searchSemesterSubject.asObserver(),
                                          searchCourseTrigger: searchCourseSubject.asObserver(),
                                          yearObserver: yearSubject.asObserver(),
                                          semesterObserver: semesterSubject.asObserver())
    let output = viewModel.transform(input: input)

    searchButtonTapped
      .bind(to: searchSemesterSubject)
      .disposed(by: rx.disposeBag)

    output.state
      .subscribe(onNext: { [weak self] (state) in
        switch state {
        case .loading:
          self?.activityIndicator.startAnimating()
          self?.leftBarItem.isEnabled = false
        default:
          self?.activityIndicator.stopAnimating()
          self?.leftBarItem.isEnabled = true
        }
      }, onError: { (error) in
        print(error)
      })
      .disposed(by: rx.disposeBag)

    output.semesters
      .subscribe(onNext: { [weak self] (semesters) in
        let semsterString = semesters.map { "\($0.year) 學年 第\($0.semester)學期" }
        let titleView = self?.updateTitleView(by: semsterString)
        titleView?.action = { (index) in
          semesterIndex = index
          yearSubject.onNext(semesters[index].year)
          semesterSubject.onNext(semesters[index].semester)
          searchCourseSubject.onNext(())
        }

        let currentSemester = semesters[semesterIndex]
        yearSubject.onNext(currentSemester.year)
        semesterSubject.onNext(currentSemester.semester)
        searchCourseSubject.onNext(())
      }, onError: { (error) in
          print(error)
      })
      .disposed(by: rx.disposeBag)

    output.courses
      .do(onNext: { (_) in
        print("get courses")
      })
      .subscribe(onNext: { [weak self] (courses) in
        guard let self = self else { return }
        for (index, courses) in courses.enumerated() {
          self.sections[index + 1].items = courses
        }
        self.updateCollectionView()
      }, onError: { (error) in
        print(error)
      })
      .disposed(by: rx.disposeBag)

    leftBarItem.rx.tap
      .subscribe(onNext: { [weak self] (_) in
        guard let self = self else { return }
        self.isSearchBarHidden = !self.isSearchBarHidden
      }, onError: { (error) in
          print(error)
      })
      .disposed(by: rx.disposeBag)
  }

  private func setUpLayouts() {
    setUpSearchBar()
    setUpCollectionView()
    setUpActivityIndicator()
  }

  private func setUpSearchBar() {
    view.addSubview(searchBar)
    searchBar.snp.makeConstraints { (make) in
      make.left.right.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.height.equalTo(80)
    }
  }

  private func setUpActivityIndicator() {
     collectionView.addSubview(activityIndicator)
     activityIndicator.snp.makeConstraints { (make) in
       make.center.equalToSuperview()
     }
   }

  private func updateCollectionView() {
    let layout = generateLayout()
    self.collectionView.collectionViewLayout = layout
    DispatchQueue.main.async { [weak self] in
      self?.collectionView.reloadData()
    }
  }

  private func setUpCollectionView() {
    view.addSubview(collectionView)

    collectionView.snp.makeConstraints { (make) in
      let topAnchor = isSearchBarHidden ? view.safeAreaLayoutGuide.snp.top : searchBar.snp.bottom
      make.top.equalTo(topAnchor)
      make.leading.trailing.bottom.equalToSuperview()
    }
    collectionView.setContentOffset(.init(x: 0, y: 0), animated: false)
    print("update collection")
  }

  private func generateLayout() -> UICollectionViewLayout {
    let sections = self.sections
    let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
      return sections[sectionIndex].layoutSection()
    }
    return layout
  }

}

// MARk: - UICollectionViewDataSource

extension CurriculumViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return sections[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      return sections[indexPath.section].configureCell(collectionView: collectionView,
                                                       indexPath: indexPath)
    }
}

// MARK: - UICollectionViewDelegate

extension CurriculumViewController: UICollectionViewDelegate {}

// MARK: - UISearchBarDelegate

extension CurriculumViewController: UISearchBarDelegate {

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    view.endEditing(true)
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchButtonTapped.onNext(())
    isSearchBarHidden = true
    view.endEditing(true)
  }

}
