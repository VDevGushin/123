//
//  ChatStyle.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 30/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

struct ChatResources {
    //Auth part
    static let authToken = "d2f646056b65ab18a35b4858b2cbc610"
    static let pid = 5787352
    static let userid = "5609724"
    static let host = "dnevnik-test.mos.ru"

    static var headers: [String: String] {
        let headers = [
            "Auth-Token": ChatResources.authToken,
            "Profile-Id": "\(ChatResources.pid)",
            "User-Id": ChatResources.userid,
            "Content-Type": "application/json"
        ]
        return headers
    }
    //UIPart
    static let whiteColor = UIColor.white
    static let styleColor = UIColor.init(hex: "#4caabe")
    static let myMessageColor = UIColor.init(hex: "#8fb5bd")
    static let defaultMessageColor = styleColor
    static let subTextColor = UIColor.darkGray
    static let textColor = UIColor.black
    static let myMessageBackgroundColor = UIColor.lightGray

    static let dateFormats = ["dd.MM.yyyy HH:mm", "dd.MM.yyyy HH:mm:ss", "yyyy.MM.dd HH:mm:ss"]

    static var decoder: JSONDecoder {
        let decoder = JSONDecoder.init()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let data = try decoder.singleValueContainer().decode(String.self)
            for format in dateFormats {
                let formatter = DateFormatter()
                formatter.dateFormat = format
                if let date = formatter.date(from: data) {
                    return date
                }
            }
            return Date()
        })
        return decoder
    }

    static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .custom({ (date, encoder) in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
            let stringData = formatter.string(from: date)
            var container = encoder.singleValueContainer()
            try container.encode(stringData)
        })
        return encoder
    }

    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }
}
