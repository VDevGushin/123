//
//  CalendarCellDay.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 23/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

class CalendarCellDay: UICollectionViewCell {
    static let offsetForDays: CGFloat = 12.0
    static let defaultFontSize: CGFloat = 17.0
    static let smallFontSize: CGFloat = 12.0
    static let defaultLineHeight: CGFloat = 20.0
    static let smallLineHeight: CGFloat = 14.0
    static let defaultFont = UIFont.systemFont(ofSize: CalendarCellDay.defaultFontSize)
    static let smallFont = UIFont.systemFont(ofSize: CalendarCellDay.smallFontSize)

    var calendarItem: CalendarItem?

    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.setSelectedStyle()
            } else {
                self.setDefaultStyle()
            }
        }
    }

    func setCalendarItemForDay(with: CalendarItem) {
        self.calendarItem = with
        self.dayNumber.text = "\(with.day)"
        self.day.text = with.dayName
        self.setDefaultStyle()
        self.border.backgroundColor = self.makeBorderColor()
    }

//        if let item = self.calendarItem {
//            switch item.type {
//            case .first:
//                self.dayNumber.textColor = .white
//                return Colors.lightYellow
//            case .last:
//                self.dayNumber.textColor = .white
//                return Colors.lightRed
//            case .middle:
//                self.dayNumber.textColor = .white
//                return Colors.lightGray
//            }
//        }
//        self.dayNumber.textColor = .black
//        return .clear
//}

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    private func setup() {
        setupViews()
        self.backgroundColor = CalendarStyle.Colors.whiteFontColor
        self.setDefaultStyle()
    }

    private func setupViews() {
        addSubview(myStackView)
        myStackView.layoutConstraint {
            $0.top.equal(to: topAnchor)
            $0.leftAnchor.equal(to: leftAnchor)
            $0.rightAnchor.equal(to: rightAnchor)
            $0.bottom.equal(to: bottomAnchor)
        }
        myStackView.addArrangedSubview(day)
        myStackView.addArrangedSubview(roundView)

        addSubview(border)
        border.layoutConstraint {
            $0.top.equal(to: topAnchor)
            $0.rightAnchor.equal(to: rightAnchor)
            $0.bottom.equal(to: bottomAnchor)
        }

        roundView.addSubview(dayNumber)
        dayNumber.layoutConstraint {
            $0.top.equal(to: roundView.topAnchor)
            $0.leftAnchor.equal(to: roundView.leftAnchor)
            $0.rightAnchor.equal(to: roundView.rightAnchor)
            $0.bottom.equal(to: roundView.bottomAnchor)
        }
        border.widthAnchor.constraint(equalToConstant: 1).isActive = true
    }

    private let day: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = CalendarCellDay.smallFont
        label.setLineHeight(lineHeight: CalendarCellDay.smallLineHeight)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dayNumber: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = CalendarCellDay.defaultFont
        label.setLineHeight(lineHeight: CalendarCellDay.defaultLineHeight)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let myStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let border: UIView = {
        let border = UIView()
        border.backgroundColor = .clear
        return border
    }()

    private let roundView: RoundView = {
        let view = RoundView()
        return view
    }()
}

// MARK: - Style
fileprivate extension CalendarCellDay {
    func makeBorderColor() -> UIColor {
        if let item = self.calendarItem, case item.type = CalendarItem.ItemType.last {
            return CalendarStyle.Colors.grayFontColor
        }
        return .clear
    }

    func setSelectedStyle() {
        self.dayNumber.textColor = CalendarStyle.Colors.whiteFontColor
        self.day.textColor = CalendarStyle.Colors.grayFontColor
        self.roundView.backgroundColor = CalendarStyle.Colors.selectedColor
    }

    func setDefaultStyle() {
        self.dayNumber.textColor = CalendarStyle.Colors.blackFontColor
        self.day.textColor = CalendarStyle.Colors.grayFontColor
        self.roundView.backgroundColor = .clear
    }
}

