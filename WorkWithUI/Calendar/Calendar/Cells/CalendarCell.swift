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
    static let lineHeight: CGFloat = 20.0
    static let defaultFontSize: CGFloat = 17.0

    var calendarItem: CalendarItem?

    override var isSelected: Bool {
        didSet {
            if isSelected {
                setSelectedStyle()
            } else {
                setDefaultStyle()
            }
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
        setupViews()
    }

    private func setupViews() {
        addSubview(self.month)
        self.month.layout {
            $0.top.equal(to: topAnchor)
            $0.leftAnchor.equal(to: leftAnchor, offsetBy: CalendarCell.offsetForDays / 2)
            $0.rightAnchor.equal(to: rightAnchor, offsetBy: -(CalendarCell.offsetForDays / 2))
            $0.bottom.equal(to: bottomAnchor)
        }

        addSubview(self.border)
        self.border.layout {
            $0.leftAnchor.equal(to: leftAnchor)
            $0.rightAnchor.equal(to: rightAnchor)
            $0.bottom.equal(to: bottomAnchor)
        }
        
        self.border.heightAnchor.constraint(equalToConstant: 2).isActive = true
        self.backgroundColor = CalendarStyle.Colors.monthBackground
        self.setDefaultStyle()
    }

    func setCalendarItemForDay(with: CalendarItem) {
        self.month.text = "\(with.monthName)"
    }

    private let month: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: CalendarCell.defaultFontSize)
        label.setLineHeight(lineHeight: CalendarCell.lineHeight)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let border: UIView = {
        let border = UIView()
        return border
    }()
}

// MARK: - Style
fileprivate extension CalendarCell {
    func setSelectedStyle() {
        self.month.textColor = CalendarStyle.Colors.blackFontColor
        self.border.backgroundColor = CalendarStyle.Colors.selectedColor
    }

    func setDefaultStyle() {
        self.month.textColor = CalendarStyle.Colors.monthGrayFontColor
        self.border.backgroundColor = CalendarStyle.Colors.monthBackground
    }
}
