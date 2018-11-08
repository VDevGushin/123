//
//  FeedBackConfig.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 06/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

struct FeedBackConfig {
    static let host = "urs-test.mos.ru"

    // MARK: - Encoders/Decoders
    static let dateFormats = ["dd.MM.yyyy HH:mm", "dd.MM.yyyy HH:mm:ss", "yyyy.MM.dd HH:mm:ss"]

    static var decoder: JSONDecoder {
        let decoder = JSONDecoder.init()
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

}
