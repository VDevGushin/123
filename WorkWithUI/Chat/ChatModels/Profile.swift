//
//  Profile.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 30/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

struct Profile: Codable, Hashable {
    enum CodingKeys: String, CodingKey {
        case id, name, type
        case userID = "user_id"
        case agreePersData = "agree_pers_data"
        case user, school, isSelected
    }

    var hashValue: Int {
        return self.id
    }

    static func == (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    let id: Int
    var name: String? = nil
    var type: String? = nil
    var userID: Int? = nil
    var agreePersData: Bool? = nil
    var user: User? = nil
    var school: School? = nil
    var isSelected: Bool = false

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)

        if let name = try? container.decode(String?.self, forKey: .name) {
            self.name = name
        }

        if let type = try? container.decode(String?.self, forKey: .type) {
            self.type = type
        }

        if let userID = try? container.decode(Int?.self, forKey: .userID) {
            self.userID = userID
        }

        if let agreePersData = try? container.decode(Bool?.self, forKey: .agreePersData) {
            self.agreePersData = agreePersData
        }

        if let user = try? container.decode(User?.self, forKey: .user) {
            self.user = user
        }

        if let school = try? container.decode(School?.self, forKey: .school) {
            self.school = school
        }
    }
}


struct School: Codable {
    let id: Int?
    let name, shortName: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case shortName = "short_name"
    }
}


struct User: Codable {
    let lastName, middleName, firstName, email: String?
    let gusoevLogin: String?

    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case middleName = "middle_name"
        case firstName = "first_name"
        case email
        case gusoevLogin = "gusoev_login"
    }
}

extension User: CustomStringConvertible {
    var description: String {
        return "\(firstName ?? "") \(middleName ?? "")  \(lastName ?? "")"
    }
}
