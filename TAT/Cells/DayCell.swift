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

  private lazy var dayLabel: UILabel = {
    let dayLabel = UILabel(frame: .zero)
    dayLabel.text = ""
    dayLabel.textAlignment = .center
    return dayLabel
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configureCell(with day: String) {
    backgroundColor = .white
    dayLabel.text = day
  }

  private func setUpLayout() {
    addSubview(dayLabel)
    dayLabel.snp.makeConstraints { (make) in
      make.leading.trailing.top.bottom.equalTo(self)
    }
  }
}
