//
//  CourseCell.swift
//  TAT
//
//  Created by jamfly on 2019/9/24.
//  Copyright © 2019 jamfly. All rights reserved.
//

import UIKit.UICollectionViewCell
import SnapKit

final class CourseCell: UICollectionViewCell {

  // MARK: - Properties

  private lazy var courseNameLabel: UILabel = {
    let courseNameLabel = UILabel(frame: .zero)
    courseNameLabel.text = ""
    courseNameLabel.textAlignment = .center
    courseNameLabel.numberOfLines = 0
    return courseNameLabel
  }()

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .yellow
    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Methods

  func configureCell(with courseName: String) {
    courseNameLabel.text = courseName
  }

}

// MARK: - Private Methods

extension CourseCell {

  private func setUpLayout() {
     addSubview(courseNameLabel)
     courseNameLabel.snp.makeConstraints { (make) in
       make.leading.trailing.top.bottom.equalTo(self)
     }
   }

}
