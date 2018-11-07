//
//  ThemesWorker.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
import SupportLib

final class ThemesWorker: IFeedBackWorker {
    var withPagination: Bool = false
    
    weak var delegate: IFeedBackWorkerDelegate?

    private var isFirstTime = true
    private var isInLoading = false

    func refresh() {
        self.isFirstTime = true
        self.execute()
    }

    func execute() {
        self.isInLoading = true
        let config = FeedBackWebConfigurator.getThemes()
        let request = FeedBackEndpoint(configurator: config).urlRequest()

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let wSelf = self else { return }

            if let error = error {
                wSelf.delegate?.sourceError(with: error)
                return
            }

            guard let jsonData = data else {
                wSelf.delegate?.sourceError(with: FeedBackError.noData)
                return
            }

            do {
                let model: FeedbackThemes = try jsonData.decode(using: FeedBackConfig.decoder)
                wSelf.delegate?.sourceChanged(isFirstTime: wSelf.isFirstTime, source: model)
            } catch {
                wSelf.delegate?.sourceError(with: error)
            }
        }
        task.resume()
    }
}
