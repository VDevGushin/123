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
    typealias Handler = (Result<(Any)>) -> Void

    func sendFeedBack(_ sendForm: SendForm, then handler: @escaping Handler) {
        DispatchQueue.global(qos: .utility).async {
            guard let model = FeedBackSendModel(from: sendForm), let data = model.encode() else {
                return handler(Result.error(FeedBackError.sendModelError))
            }

            let config = FeedBackWebConfigurator.sendFeedBack(captchaId: model.captchaId, captchaValue: model.captchaValue, data: data)
            let endpoint = FeedBackEndpoint(configurator: config)
            let request = endpoint.urlRequest()
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error { return handler(Result.error(error)) }
                guard let jsonData = data else { return handler(Result.error(FeedBackError.noData)) }
                do {
                    guard let error: FeedBackErrorMessage = try? jsonData.decode(using: FeedBackConfig.decoder), error.errorCode != nil, let message = error.errorMessage else {
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
