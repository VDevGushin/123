//
//  Date+Extension.swift
//  SupportLib
//
//  Created by Vladislav Gushin on 03/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

public extension Date {
    public static func getDate(_ from: String) -> Date? {
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
