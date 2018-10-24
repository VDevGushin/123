//
//  CalendarItem.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 23/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

struct CalendarItem {
    private let monthsArr = ["январь", "февраль", "март", "апрель", "май", "июнь", "июль", "август", "сентябрь", "октябрь", "ноябрь", "декабрь"]
    private let days = ["пн", "вт", "ср", "чт", "пт", "сб", "вс"]

    var monthHash: Int { return month.hashValue ^ year.hashValue }

    enum ItemType {
        case first
        case last
        case middle
    }

    let date: Date
    let month: Int
    let year: Int
    let day: Int
    let type: ItemType

    var dayName: String { return days[Calendar.current.component(.weekday, from: date) - 1] }
    var monthName: String { return monthsArr[month - 1] }

    init(date: Date, type: ItemType) {
        let calendar = Calendar.current
        self.date = date
        self.month = calendar.component(.month, from: date)
        self.year = calendar.component(.year, from: date)
        self.day = calendar.component(.day, from: date)
        self.type = type
    }
}
