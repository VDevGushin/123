//
//  ChatStyle.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 30/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

struct ChatResources {
    static let whiteColor = UIColor.white
    static let styleColor = UIColor.init(hex: "#4caabe")
    static let myMessageColor = UIColor.red
    static let defaultMessageColor = styleColor
    static let subTextColor = UIColor.darkGray
    static let textColor = UIColor.black
    static let myMessageBackgroundColor = UIColor.lightGray


    static var decoder: JSONDecoder {
        let decoder = JSONDecoder.init()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }

    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }
    
    static var encoder : JSONEncoder{
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }
}
