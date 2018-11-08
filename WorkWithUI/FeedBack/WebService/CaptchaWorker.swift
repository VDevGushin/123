//
//  CaptchaService.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 06/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

final class CaptchaWorker {
    typealias Handler = (Result<(CaptchaModel)>) -> Void

    func getCaptcha(then handler: @escaping Handler) {
        let config = FeedBackWebConfigurator.getCaptcha()
        let endpoint = FeedBackEndpoint(configurator: config)
        let request = endpoint.urlRequest()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { return handler(Result.error(error)) }
            guard let jsonData = data else { return handler(Result.error(FeedBackError.noData)) }
            do {
                let model: CaptchaModel = try jsonData.decode(using: FeedBackConfig.decoder)
                return handler(Result.result(model))
            } catch {
                handler(Result.error(error))
            }
        }
        task.resume()
    }
}
