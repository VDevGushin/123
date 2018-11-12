//
//  FeedBackReportWorker.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 09/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
import SupportLib

final class FeedBackReportWorker {
    private let sendForm = SendForm()
    typealias Handler = (Result<(Any)>) -> Void
    private var isInRequest: Bool = false

    func sendAction(_ with: FeedBackCellIncomeData, then handler: @escaping Handler) {
        switch with {
        case .captcha(id: let id, text: let text):
            self.sendForm.captcha = text
            self.sendForm.captchaId = id
        case .detail(with: let value):
            self.sendForm.detail = value
        case .mail(with: let value):
            self.sendForm.mail = value
        case .middleName(with: let value):
            self.sendForm.middleName = value
        case .name(with: let value):
            self.sendForm.name = value
        case .organisation(with: let value):
            self.sendForm.organisation = value
        case .phone(with: let value):
            self.sendForm.phone = value
        case .lastName(with: let value):
            self.sendForm.lastName = value
        case .theme(with: let value):
            self.sendForm.theme = value
        case .attach(with: let value):
            self.sendForm.attach = value
        case .done:
            if sendForm.isValid {
                if self.isInRequest { return }
                self.isInRequest = true
                self.sendFeedBack(sendForm, then: handler)
            } else {
                return handler(Result.error(FeedBackError.invalidModel))
            }
        }
    }

    private func sendFeedBack(_ sendForm: SendForm, then handler: @escaping Handler) {
        DispatchQueue.global(qos: .utility).async {
            guard let model = FeedBackSendModel(from: sendForm), let data = model.encode() else {
                return handler(Result.error(FeedBackError.sendModelError))
            }

            let config = FeedBackWebConfigurator.sendFeedBack(captchaId: model.captchaId, captchaValue: model.captchaValue, data: data)
            let endpoint = FeedBackEndpoint(configurator: config)
            let request = endpoint.urlRequest()
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                self.isInRequest = false
                if let error = error { return handler(Result.error(error)) }
                guard let jsonData = data else { return handler(Result.error(FeedBackError.noData)) }
                do {
                    guard let error: FeedBackErrorMessage = try? jsonData.decode(using: FeedBackConfig.decoder),
                        error.errorCode != nil,
                        let message = error.errorMessage else {
                            let model: FeedBackSendModel = try jsonData.decode(using: FeedBackConfig.decoder)
                            return handler(Result.result(model))
                    }

                    if message.lowercased().contains("captcha") {
                        return handler(Result.error(FeedBackError.captcha))
                    }

                    return handler(Result.error(FeedBackError.sendModelError))
                } catch {
                    handler(Result.error(error))
                }
            }
            task.resume()
        }
    }
}
