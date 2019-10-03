//
//  DayCell.swift
//  TAT
//
//  Created by jamfly on 2019/9/23.
//  Copyright © 2019 jamfly. All rights reserved.
//

import UIKit.UICollectionViewCell
import SnapKit

final class DayCell: UICollectionViewCell {

  // MARK: - Properties

  private lazy var dayLabel: UILabel = {
    let dayLabel = UILabel(frame: .zero)
    dayLabel.text = ""
    dayLabel.textAlignment = .center
    return dayLabel
  }()

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Methods

  func configureCell(with day: String) {
    dayLabel.text = day
  }

}

// MARK: - Private Methods

extension DayCell {

  private func setUpLayout() {
    addSubview(dayLabel)
    dayLabel.snp.makeConstraints { (make) in
      make.leading.trailing.top.bottom.equalTo(self)
    }
  }

}
