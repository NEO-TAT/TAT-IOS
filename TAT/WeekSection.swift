//
//  WeekSection.swift
//  TAT
//
//  Created by jamfly on 2019/9/23.
//  Copyright © 2019 jamfly. All rights reserved.
//

import IBPCollectionViewCompositionalLayout

struct WeekSection: Section {
  var items: [Any]

  init() {
    items = [Week.sunday, Week.monday, Week.tuesday, Week.wednesday, Week.thursday, Week.friday, Week.saturday]
  }

  func layoutSection() -> NSCollectionLayoutSection {

    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(CGFloat(1) / CGFloat(items.count)),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 1,
                                                 leading: 1,
                                                 bottom: 1,
                                                 trailing: 1)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                           heightDimension: .absolute(76))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    return section
  }

  func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DayCell.self),
                                                        for: indexPath) as? DayCell,
    let day = items as? [Week] else { fatalError("cannot init DayCell") }

//    if let day = Week(rawValue: indexPath.row)?.toString() {
//      cell.configureCell(with: day)
//    }
    cell.configureCell(with: day[indexPath.row].toString())

    return cell
  }
}
