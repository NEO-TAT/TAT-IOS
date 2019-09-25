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

  private lazy var courseNameLabel: UILabel = {
    let courseNameLabel = UILabel(frame: .zero)
    courseNameLabel.text = ""
    courseNameLabel.textAlignment = .center
    return courseNameLabel
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configureCell(with courseName: String) {
    backgroundColor = .yellow
    courseNameLabel.text = courseName
  }

  private func setUpLayout() {
    addSubview(courseNameLabel)
    courseNameLabel.snp.makeConstraints { (make) in
      make.leading.trailing.top.bottom.equalTo(self)
    }
  }

}
