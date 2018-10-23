//
//  DaysView.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 23/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate extension Array where Element == [CalendarItem] {
    func getFlatDates() -> [CalendarItem] {
        let array = self.flatMap { $0 }
        return array
    }
}

protocol DaysViewDelegate: class {
    func didSelectDay(dayModel: CalendarItem)
}

final class DaysView: UIView {
    private let dayCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let myCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        myCollectionView.backgroundColor = UIColor.clear
        myCollectionView.allowsMultipleSelection = false
        return myCollectionView
    }()

    var delegate: DaysViewDelegate?
    private var dates: [CalendarItem] = []
    private var scrollDelegateIsLock = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        self.backgroundColor = UIColor.clear
        self.addSubview(dayCollection)

        self.dayCollection.layout {
            $0.top.equal(to: self.topAnchor)
            $0.leading.equal(to: self.leadingAnchor)
            $0.trailing.equal(to: self.trailingAnchor)
            $0.bottom.equal(to: self.bottomAnchor)
        }

        self.dayCollection.delegate = self
        self.dayCollection.dataSource = self
        self.dayCollection.registerWithClass(CalendarCellDay.self)
    }

    func update(with dates: [[CalendarItem]]) {
        self.dates = dates.getFlatDates()
        self.dayCollection.reloadData()
    }

    func scrollToDay(monthHash: Int) {
        let index = self.dates.index {
            $0.monthHash == monthHash
        }
        guard let neededIndex = index else { return }

        let indexPath = IndexPath(item: neededIndex, section: 0)
        self.scrollDelegateIsLock = true
        self.dayCollection.scrollToItem(at: indexPath, at: [.centeredVertically, .left], animated: true)
    }
}

extension DaysView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //scrollViewDidEndDecelerating
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = dayCollection.contentOffset
        visibleRect.size = CGSize(width: dayCollection.bounds.size.width / 2, height: dayCollection.bounds.size.height)
        let visiblePoint = CGPoint(x: visibleRect.minX + 10, y: visibleRect.midY)
        guard let indexPath = dayCollection.indexPathForItem(at: visiblePoint) else { return }
        if !self.scrollDelegateIsLock {
            delegate?.didSelectDay(dayModel: self.dates[indexPath.item])
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.scrollDelegateIsLock {
            self.scrollDelegateIsLock = false
        }
    }

    private func getMonthDate(_ index: Int) -> Int {
        let datesForMonth = self.dates[index]
        return datesForMonth.day
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectDay(dayModel: self.dates[indexPath.item])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dates.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: CalendarCellDay.self, indexPath: indexPath)!
        cell.setCalendarItemForDay(with: self.dates[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = collectionView.frame.height - 12
        let day = "\(self.getMonthDate(indexPath.item))"
        let width = day.width(withConstraintedHeight: height, font: UIFont.systemFont(ofSize: 16)) + CalendarCellDay.offsetForDays
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

