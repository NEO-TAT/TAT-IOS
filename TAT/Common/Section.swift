//
//  Section.swift
//  TAT
//
//  Created by jamfly on 2019/9/23.
//  Copyright © 2019 jamfly. All rights reserved.
//

import UIKit

protocol Section {
  var items: [Any] { get set }
  func layoutSection() -> NSCollectionLayoutSection
  func configureCell(collectionView: UICollectionView,
                     indexPath: IndexPath) -> UICollectionViewCell
}
