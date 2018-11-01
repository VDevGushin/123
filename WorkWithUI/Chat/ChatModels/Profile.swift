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
        case user, school
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try? container.decode(String.self, forKey: .name)
        self.type = try? container.decode(String.self, forKey: .type)
        self.userID = try? container.decode(Int.self, forKey: .userID)
        self.agreePersData = try? container.decode(Bool.self, forKey: .agreePersData)
        self.user = try? container.decode(User.self, forKey: .user)
        self.school = try? container.decode(School.self, forKey: .school)
    }
}

struct School: Codable {
    let id: Int
    var name: String? = nil
    var shortName: String? = nil

    enum CodingKeys: String, CodingKey {
        case id, name
        case shortName = "short_name"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try? container.decode(String.self, forKey: .name)
        self.shortName = try? container.decode(String.self, forKey: .shortName)
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
