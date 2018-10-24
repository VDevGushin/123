//
//  Date+Extension.swift
//  SupportLib
//
//  Created by Vladislav Gushin on 03/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

public extension Date {
    
    public static func getDate(_ from: [Int]?) -> Date? {
        guard let from = from, from.count == 3 else { return nil }
        let date = getDate("\(from[2]).\(from[1]).\(from[0])", formatter: .init(with: .ddMMyyyy))
        return date
    }

    public static func getDate(_ from: [Int]?, orDefault defaultDate: Date) -> Date {
        return getDate(from) ?? defaultDate
    }

    public static func getDatesBetweenInterval(_ startDate: Date, _ endDate: Date, then handler: @escaping ((days: [Date], sortedByMonth: [[Date]])) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            var days = [Date]()
            var startDate = startDate
            let calendar = Calendar.current
            while startDate <= endDate {
                days.append(startDate)
                startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
            }
            let sortedDays = sortDateByMonth(dateArray: days)
            DispatchQueue.main.async {
                handler((days, sortedDays))
            }
        }
    }

    public static func getDateWithZeroTimeZone(_ from: String) -> Date? {
        var date: Date?
        for format in DateFormatter.VariantDateFormater.allCases {
            let formatter = DateFormatter.getShortFormatterZeroTimeZone(with: format)
            if let newDate = formatter.date(from: from) {
                date = newDate
                break
            }
        }
        return date
    }

    public static func sortDateByMonth(dateArray: [Date]) -> [[Date]] {
        if dateArray.isEmpty { return [] }

        let inputArray = dateArray.sorted()
        var resultArray = [[inputArray[0]]]

        let calendar = Calendar(identifier: .gregorian)
        for (prevDate, nextDate) in zip(inputArray, inputArray.dropFirst()) {
            if !calendar.isDate(prevDate, equalTo: nextDate, toGranularity: .month) {
                resultArray.append([]) // Start new row
            }
            resultArray[resultArray.count - 1].append(nextDate)
        }
        return resultArray
    }

    public func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }

    public func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }

//    public static func getDate(_ from: String) -> Date? {
//        var date: Date?
//        for format in DateFormatter.VariantDateFormater.allCases {
//            let formatter = DateFormatter.getShortFormatter(with: format)
//            if let newDate = formatter.date(from: from) {
//                date = newDate
//                break
//            }
//        }
//        return date
//    }
    
    static func getDate(_ from: String?, formatter: DateFormatter? = nil) -> Date? {
        guard let from = from else {
            return nil
        }
        
        var date: Date?
        
        if let formatter = formatter {
            if let newDate = formatter.date(from: from) {
                date = newDate
            }
        } else {
            for format in DateFormatter.VariantDateFormater.allCases {
                let formatter = DateFormatter(with: format)
                if let newDate = formatter.date(from: from) {
                    date = newDate
                    break
                }
            }
        }
        
        return date
    }

}
