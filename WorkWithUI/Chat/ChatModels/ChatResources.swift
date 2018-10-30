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
    static let authToken = "a74d900e934cfeee126105c19d0ed5b8"
    static let pid = 5787352
    static let userid = "5609724"
    static let host = "dnevnik.mos.ru"
    
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
        // formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        return formatter
    }
    
    static var encoder : JSONEncoder{
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }
}
