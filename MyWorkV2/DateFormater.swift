//
//  DateFormater.swift
//  MyWorkV2
//
//  Created by Vladislav Gushin on 05/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

public protocol CaseIterable {
    associatedtype AllCases: Collection where AllCases.Element == Self
    static var allCases: AllCases { get }
}
extension CaseIterable where Self: Hashable {
    static var allCases: [Self] {
        return [Self](AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            var first: Self?
            return AnyIterator {
                let current = withUnsafeBytes(of: &raw) { $0.load(as: Self.self) }
                if raw == 0 {
                    first = current
                } else if current == first {
                    return nil
                }
                raw += 1
                return current
            }
        })
    }
}

extension DateFormatter {
    enum VariantDateFormater: String, CaseIterable {
        case formatV1 = "dd.MM.yyyy"
        case formatV2 = "dd-mm-yyyy"
        case formatV3 = "yyyy-MM-dd"
        case formatV4 = "yyyy.MM.dd"
    }

    class func getShortFormatter(with format: VariantDateFormater) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        formatter.dateFormat = format.rawValue
        return formatter
    }
}

extension Date {
    static func getDate(_ from: [Int]) -> Date? {
        guard from.count == 3 else { return nil }
        let endDateStr = "\(from[2]).\(from[1]).\(from[0])"
        let formatter = DateFormatter.getShortFormatter(with: .formatV1)
        let date = formatter.date(from: endDateStr)
        return date
    }

    static func getDate(_ from: String) -> Date? {
        var date: Date?
        for format in DateFormatter.VariantDateFormater.allCases {
            let formatter = DateFormatter.getShortFormatter(with: format)
            if let newDate = formatter.date(from: from) {
                date = newDate
                break
            }
        }
        return date
    }
}
