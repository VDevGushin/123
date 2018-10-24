//
//  CalendarCellDay.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 23/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class CalendarCellDay: UICollectionViewCell {
    static let offsetForDays: CGFloat = 12.0
    var calendarItem: CalendarItem?
    struct Colors {
        static var sekectedColor = UIColor.init(hex: "#00aec5")
        static var darkRed = #colorLiteral(red: 0.8039215803, green: 0.3953110376, blue: 0.4118975407, alpha: 1)
        static var lightGray = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        static var lightRed = #colorLiteral(red: 0.8039215803, green: 0.572896705, blue: 0.5696038044, alpha: 1)
        static var lightYellow = #colorLiteral(red: 0.8039215803, green: 0.7101274876, blue: 0.5080572985, alpha: 1)
    }

    override var isSelected: Bool {
        didSet { self.backgroundColor = isSelected == true ? Colors.darkRed : self.makeBackgroundColor() }
    }

    func setCalendarItemForDay(with: CalendarItem) {
        self.calendarItem = with
        self.dayNumber.text = "\(with.day)"
        self.day.text = with.dayName

        self.backgroundColor = self.makeBackgroundColor()
    }

    private func makeBackgroundColor() -> UIColor {
        if let item = self.calendarItem {
            switch item.type {
            case .first:
                self.dayNumber.textColor = .white
                return Colors.lightYellow
            case .last:
                self.dayNumber.textColor = .white
                return Colors.lightRed
            case .middle:
                self.dayNumber.textColor = .white
                return Colors.lightGray
            }
        }
        self.dayNumber.textColor = .black
        return .clear
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
        addSubview(myStackView)
        myStackView.layout {
            $0.top.equal(to: topAnchor)
            $0.leftAnchor.equal(to: leftAnchor)
            $0.rightAnchor.equal(to: rightAnchor)
            $0.bottom.equal(to: bottomAnchor)
        }
        myStackView.addArrangedSubview(day)
        myStackView.addArrangedSubview(dayNumber)
    }

    private let day: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dayNumber: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkGray
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
}
