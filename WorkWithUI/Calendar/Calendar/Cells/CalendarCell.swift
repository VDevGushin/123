//
//  MonthCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 23/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    static let offsetForDays: CGFloat = 12.0
    var calendarItem: CalendarItem?
    struct Colors {
        static var darkGray = #colorLiteral(red: 0.3764705882, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
        static var lightRed = #colorLiteral(red: 0.8039215803, green: 0.3953110376, blue: 0.4118975407, alpha: 1)
    }

    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected == true ? Colors.lightRed : .clear
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    private func setup() {
        backgroundColor = UIColor.clear
        // layer.cornerRadius = 5
        // layer.masksToBounds = true
        setupViews()
    }

    private func setupViews() {
        addSubview(month)
        month.layout {
            $0.top.equal(to: topAnchor)
            $0.leftAnchor.equal(to: leftAnchor, offsetBy: CalendarCell.offsetForDays / 2)
            $0.rightAnchor.equal(to: rightAnchor, offsetBy: -(CalendarCell.offsetForDays / 2))
            $0.bottom.equal(to: bottomAnchor)
        }
    }

    func setCalendarItemForDay(with: CalendarItem) {
        self.month.text = "\(with.monthName)"
    }

    private let month: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
