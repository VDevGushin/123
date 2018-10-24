//
//  CalendarModel.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 23/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

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

struct CalendarModel {
    typealias SheduleItem = (date: [Int], items: AnyObject)
    private let calendarItems: [[CalendarItem]]

    init(with sheduleItem: [SheduleItem]) {
        let allDates = Date.sortDateByMonth(dateArray: sheduleItem.map { Date.getDate($0.date, orDefault: Date()) })
        self.calendarItems = allDates.getCalendarItems()
    }

    var source: [[CalendarItem]] {
        return calendarItems
    }
}
