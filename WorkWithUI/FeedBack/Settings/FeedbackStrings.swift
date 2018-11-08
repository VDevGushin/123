//
//  FeedbackStrings.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

enum FeedbackStrings {
    enum FeedBackView: String {
        var value: String { return self.rawValue }

        case send = "Отправить"
        case title = "Задать вопрос"
        case themeTitle = "Тема*"
        case organisationTitle = "Учебная организация*"
        case name = "Имя*"
        case surname = "Фамилия*"
        case middleName = "Отчество"
        case phoneTitle = "Телефон"
        case emailTitle = "Электронная почта*"
        case detailTitle = "Подробно о ситуации*"
        case captchaTitle = "Введите текст с картинки*"
        case backButtonText = "Назад"
    }
}
