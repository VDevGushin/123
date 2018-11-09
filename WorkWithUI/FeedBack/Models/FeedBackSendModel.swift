//
//  FeedBackSendModel.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 08/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

struct FeedBackSendModel: Codable {
    let firstName, lastName, organizationName: String
    let externalSystemID, categoryID: Int
    let description: String
    let organizationID: Int
    let problemType, email, login: String
    let status: String

    let middleName: String?
    let phone: String?

    var captchaId = ""
    var captchaValue = ""

    enum CodingKeys: String, CodingKey {
        case externalSystemID = "externalSystemId"
        case categoryID = "categoryId"
        case description, firstName, lastName, middleName, organizationName
        case organizationID = "organizationId"
        case problemType, email, login, phone, status
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
        self.organizationName = ""
        self.login = ""

        self.externalSystemID = externalSystemID
        self.categoryID = theme.id
        
        self.captchaId = captchaId
        self.captchaValue = captchaValue
    }

    func encode() -> Data? {
        let encoder = FeedBackConfig.encoder
        return try? encoder.encode(self)
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
