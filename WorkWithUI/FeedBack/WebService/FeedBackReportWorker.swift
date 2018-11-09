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

    func sendFeedBack(model: FeedBackSendModel, data: Data, then handler: @escaping Handler) {
        let config = FeedBackWebConfigurator.sendFeedBack(captchaId: model.captchaId, captchaValue: model.captchaValue, data: data)
        let endpoint = FeedBackEndpoint(configurator: config)
        let request = endpoint.urlRequest()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { return handler(Result.error(error)) }
            guard let jsonData = data else { return handler(Result.error(FeedBackError.noData)) }
            do {
                guard let error: FeedBackErrorMessage = try? jsonData.decode(using: FeedBackConfig.decoder), error.errorCode != nil, error.errorMessage != nil else {
                    let model: FeedBackSendModel = try jsonData.decode(using: FeedBackConfig.decoder)
                    return handler(Result.result(model))
                }
                return handler(Result.error(FeedBackError.sendModelError(error)))
            } catch {
                handler(Result.error(error))
            }
        }
        task.resume()
    }
}
