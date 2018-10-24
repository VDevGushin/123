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
        case ddMMyyyy = "dd.MM.yyyy"
        case dd_MM_yyyy = "dd-MM-yyyy"
        case yyyy_MM_dd = "yyyy-MM-dd"
        case yyyyMMdd = "yyyy.MM.dd"
        case yyyy_MM_ddHHmmssSSSz = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case dd_I_MM_I_yyyy = "dd/MM/yyyy"
        case EE
        case dd
        case ddMM = "dd.MM"
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
    
    convenience init(with format: VariantDateFormater) {
        self.init()
        self.timeZone = TimeZone(abbreviation: "UTC+0:00")
        self.dateFormat = format.rawValue
    }
}
