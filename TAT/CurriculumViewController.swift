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
  private var isSearchBarHidden: Bool = false {
    didSet {
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
    let searchTrigger = Observable.merge(rx.viewWillAppear, leftBarItem.rx.tap.asObservable()).share()
    let input = CurriculumViewModel.Input(targetStudentId: Observable.just("104440026"),
                                          searchTrigger: searchTrigger)
    let output = viewModel.transform(input: input)

    output.state
      .subscribe(onNext: { [weak self] (state) in
        switch state {
        case .loading: self?.activityIndicator.startAnimating()
        default: self?.activityIndicator.stopAnimating()
        }
      }, onError: { (error) in
        print(error)
      })
      .disposed(by: rx.disposeBag)

    output.semesters
      .subscribe(onNext: { [weak self] (semesters) in
        let semsterString = semesters.map { "\($0.year) 學年 第\($0.semester)學期" }
        self?.updateTitleView(by: semsterString)
      }, onError: { (error) in
          print(error)
      })
      .disposed(by: rx.disposeBag)

    output.courses
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

    searchTrigger
      .subscribe(onNext: { [weak self] (_) in
        guard let self = self else { return }
        self.isSearchBarHidden = !self.isSearchBarHidden
        self.searchBar.isHidden = self.isSearchBarHidden
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
