//
//  FeedBackSendModel.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 08/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

struct FeedBackErrorMessage: Decodable {
    var errorCode: Int?
    var errorMessage: String?

    enum CodingKeys: String, CodingKey {
        case errorCode = "errorCode"
        case errorMessage = "errorMessage"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.errorCode = try? container.decode(Int.self, forKey: .errorCode)
        self.errorMessage = try? container.decode(String.self, forKey: .errorMessage)
    }
}

struct FeedBackSendModel: Codable {
    let firstName, lastName: String
    let externalSystemID, categoryID: Int
    let description: String
    let organizationID: Int
    let problemType, email: String
    let status: String
    let attachments: [Int] = []

    let middleName: String?
    let phone: String?

    var captchaId = ""
    var captchaValue = ""

    enum CodingKeys: String, CodingKey {
        case externalSystemID = "externalSystemId"
        case categoryID = "categoryId"
        case description, attachments, firstName, lastName, middleName
        case organizationID = "organizationId"
        case problemType, email, phone, status
    }

    init?(from sendForm: SendForm) {
        guard let firstName = sendForm.name,
            let lastName = sendForm.lastName,
            let description = sendForm.detail,
            let organisation = sendForm.organisation,
            let emil = sendForm.mail,
            let theme = sendForm.theme,
            let externalSystemID = theme.systemID,
            let captchaId = sendForm.captchaId,
            let captchaValue = sendForm.captcha
            else { return nil }

        self.status = "new"
        self.firstName = firstName
        self.lastName = lastName
        self.middleName = sendForm.middleName
        self.organizationID = organisation.id
        self.phone = sendForm.phone
        self.email = emil
        self.problemType = theme.systemTitle
        self.description = description

        self.externalSystemID = externalSystemID
        self.categoryID = theme.id

        self.captchaId = captchaId
        self.captchaValue = captchaValue
    }

    func encode() -> Data? {
        let encoder = FeedBackConfig.encoder
        return try? encoder.encode(self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.firstName, forKey: .firstName)
        try container.encode(self.lastName, forKey: .lastName)

        try container.encode(self.externalSystemID, forKey: .externalSystemID)
        try container.encode(self.categoryID, forKey: .categoryID)

        try container.encode(self.description, forKey: .description)
        try container.encode(self.organizationID, forKey: .organizationID)

        try container.encode(self.problemType, forKey: .problemType)
        try container.encode(self.email, forKey: .email)

        try container.encode(self.status, forKey: .status)
        try container.encode(self.attachments, forKey: .attachments)

        try? container.encode(self.middleName, forKey: .middleName)
        try? container.encode(self.phone, forKey: .phone)
    }
}

final class SendForm {
    var name: String?
    var lastName: String?
    var middleName: String?
    var organisation: Organisation?
    var phone: String?
    var mail: String?
    var theme: FeedbackTheme?
    var captcha: String?
    var captchaId: String?
    var detail: String?
    var attach: [Any]?
    
    var isValid: Bool {
        if name != nil &&
            lastName != nil &&
            detail != nil &&
            organisation != nil &&
            mail != nil &&
            theme != nil &&
            captcha != nil &&
            captchaId != nil {
            return true
        }
        return false
    }
}
