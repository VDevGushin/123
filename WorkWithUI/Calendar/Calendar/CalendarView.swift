//
//  CalendarView.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 23/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit


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

    func setModel() {
        let source: [CalendarModel.SheduleItem] = [
            ([2018, 10, 24], UIView()),
            ([2018, 10, 25], UIView()),
            ([2018, 10, 26], UIView()),
            ([2018, 10, 27], UIView()),
            ([2018, 10, 28], UIView()),
            ([2018, 10, 29], UIView()),
            ([2018, 10, 30], UIView()),
            ([2018, 10, 31], UIView()),
            ([2018, 11, 1], UIView()),
            ([2018, 11, 2], UIView()),
            ([2018, 11, 3], UIView()),
            ([2018, 11, 4], UIView()),
            ([2018, 11, 5], UIView()),
            ([2018, 11, 6], UIView()),
            ([2018, 11, 7], UIView()),
            ([2018, 11, 8], UIView()),
        ]
        let model = CalendarModel(with: source)
        self.daysView.update(with: model.source)
        self.monthView.update(with: model.source)
    }

    private func setupUI() {
        guard let view = self.loadFromNib(CalendarView.self) else { return }
        self.monthView.didSelectMonthHandler.delegate(to: self, with: self.didSelectMonth)
        self.daysView.didSelectDayHandler.delegate(to: self, with: self.self.didSelectDay)
        self.addSubview(view)
        self.setModel()
    }
}

extension CalendarView {
    func didSelectDay(delegate: CalendarView, dayModel: CalendarItem) {
        self.monthView.scrollToMonth(monthHash: dayModel.monthHash)
    }

    func didSelectMonth(delegate: CalendarView, monthModel: CalendarItem) {
        self.daysView.scrollToDay(monthHash: monthModel.monthHash)
    }
}
