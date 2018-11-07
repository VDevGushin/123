//
//  FeedbackTheme.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

typealias FeedbackThemes = [FeedbackTheme]

struct FeedbackTheme: Decodable, ISource {
    var innerTitle: String?
    var innerRaw: Any?
    
    let id: Int
    let systemID: Int?
    let title, systemTitle: String
    let forStudentOrParent: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case systemID = "systemId"
        case title, systemTitle, forStudentOrParent
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        
        self.systemID = try? container.decode(Int.self, forKey: .systemID)
        self.title = try container.decode(String.self, forKey: .title)
        self.systemTitle = try container.decode(String.self, forKey: .systemTitle)
        self.forStudentOrParent = try? container.decode(Bool.self, forKey: .forStudentOrParent)
        
        self.innerTitle = self.title
        self.innerRaw = self
    }
}
