//
//  CurriculumSection.swift
//  TAT
//
//  Created by jamfly on 2019/9/24.
//  Copyright © 2019 jamfly. All rights reserved.
//

import IBPCollectionViewCompositionalLayout
import Domain

struct CurriculumSection: Section {

  var items: [Any]

  func layoutSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(CGFloat(1) / CGFloat(items.count)),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 1,
                                                 leading: 1,
                                                 bottom: 1,
                                                 trailing: 1)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                           heightDimension: .absolute(80))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    return section
  }

  func configureCell(collectionView: UICollectionView,
                     indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CourseCell.self),
                                                        for: indexPath) as? CourseCell,
      let courses = items as? [Domain.Course] else { fatalError("cannot init") }

    if items.count > 0 {
      if indexPath.row == 0 {
        cell.configureCell(with: String(indexPath.section, radix: 16).uppercased())
      } else {
        cell.configureCell(with: courses[indexPath.row].name)
      }
    }
    return cell
  }

}
