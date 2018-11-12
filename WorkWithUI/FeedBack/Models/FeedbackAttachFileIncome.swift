//
//  FeedbackAttachFileIncome.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 12/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

typealias FeedbackAttachFileIncomes = [FeedbackAttachFileIncome]

struct FeedbackAttachFileIncome: Codable {
    let filename, contentType, url: String
    let size: Int
    let id: String
}
