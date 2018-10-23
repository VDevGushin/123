//
//  MonthView.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 22/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

protocol MonthViewDelegate: class {
    func didSelectMonth(monthModel: CalendarItem)
}

final class MonthView: UIView {
    private let monthCollection: UICollectionView = {
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

    private var dates: [CalendarItem] = []
    var delegate: MonthViewDelegate?

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
        self.addSubview(monthCollection)

        self.monthCollection.layout {
            $0.top.equal(to: self.topAnchor)
            $0.leading.equal(to: self.leadingAnchor)
            $0.trailing.equal(to: self.trailingAnchor)
            $0.bottom.equal(to: self.bottomAnchor)
        }

        self.monthCollection.delegate = self
        self.monthCollection.dataSource = self
        self.monthCollection.registerWithClass(CalendarCell.self)
    }

    func update(with dates: [[CalendarItem]]) {
        self.dates = dates.compactMap { $0.first }
        self.monthCollection.reloadData()
    }
    
    func scrollToMonth(monthHash: Int) {
        let index = self.dates.index {
            $0.monthHash == monthHash
        }
        guard let neededIndex = index else { return }
        let indexPath = IndexPath(item: neededIndex, section: 0)
        self.monthCollection.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        //self.monthCollection.scrollToItem(at: indexPath, at: [.centeredVertically, .left], animated: true)
    }
}

extension MonthView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func getMonthName(_ index: Int) -> CalendarItem {
        return self.dates[index]
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dates.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: CalendarCell.self, indexPath: indexPath)!
        cell.setCalendarItemForDay(with: self.getMonthName(indexPath.item))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectMonth(monthModel: self.dates[indexPath.item])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = collectionView.frame.height - 12
        let month = self.getMonthName(indexPath.item).monthName
        let width = month.width(withConstraintedHeight: height, font: UIFont.systemFont(ofSize: 16)) + CalendarCellDay.offsetForDays
        return CGSize(width: width, height: height)
    }
}
