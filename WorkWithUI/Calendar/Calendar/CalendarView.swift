//
//  CalendarView.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 23/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate extension Array where Element == Date {
    func getCalendarItems() -> [CalendarItem] {
        var array: [CalendarItem] = []
        for i in 0..<self.count {
            switch i {
            case 0:
                array.append(CalendarItem(date: self[i], type: .first))
            case self.count - 1:
                array.append(CalendarItem(date: self[i], type: .last))
            default:
                array.append(CalendarItem(date: self[i], type: .middle))
            }

        }
        return array
    }
}

fileprivate extension Array where Element == [Date] {
    func getCalendarItems() -> [[CalendarItem]] {
        return self.map { $0.getCalendarItems() }
    }
}

final class CalendarView: UIView {
    @IBOutlet private weak var monthView: MonthView!
    @IBOutlet private weak var daysView: DaysView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    func setModel(with: CalendarModel) {
        Date.getDatesBetweenInterval(with.startDate, with.endDate) {
            let items = $0.sortedByMonth.getCalendarItems()
            self.monthView.update(with: items)
            self.daysView.update(with: items)
        }
    }

    private func setupUI() {
        guard let view = self.loadFromNib(CalendarView.self) else { return }
        self.daysView.delegate = self
        self.monthView.delegate = self
        self.addSubview(view)
        self.setModel(with: CalendarModel(startDate: Date(), endDate: Date.getDate("2020-11-24")!))
    }
}

extension CalendarView: DaysViewDelegate, MonthViewDelegate {
    func didSelectDay(dayModel: CalendarItem) {
        self.monthView.scrollToMonth(monthHash: dayModel.monthHash)
    }

    func didSelectMonth(monthModel: CalendarItem) {
        self.daysView.scrollToDay(monthHash: monthModel.monthHash)
    }
}
