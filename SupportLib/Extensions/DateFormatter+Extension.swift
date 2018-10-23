//
//  DateFormatter+Extension.swift
//  SupportLib
//
//  Created by Vladislav Gushin on 03/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

public extension DateFormatter {
    public enum VariantDateFormater: String, CaseIterable {
        case formatV1 = "dd.MM.yyyy"
        case formatV2 = "dd-mm-yyyy"
        case formatV3 = "yyyy-MM-dd"
        case formatV4 = "yyyy.MM.dd"
    }
    
   public class func getShortFormatterZeroTimeZone(with format: VariantDateFormater) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        formatter.dateFormat = format.rawValue
        return formatter
    }
    
    public class func getShortFormatter(with format: VariantDateFormater) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter
    }
}
