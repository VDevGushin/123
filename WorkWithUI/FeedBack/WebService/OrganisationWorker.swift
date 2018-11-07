//
//  OrganisationWorker.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
import SupportLib

final class OrganisationWorker: IFeedBackWorker {
    weak var delegate: IFeedBackWorkerDelegate?
    private var perPage = 100
    private var page = 1
    private var isFirstTime = true
    private var isInLoading = false

    func refresh() {
        self.isFirstTime = true
        self.page = 1
        self.execute()
    }

    func execute() {
        self.isInLoading = true
        let config = FeedBackWebConfigurator.getOrganisations(page: self.page, perPage: self.perPage)
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
                let model: Organisations = try jsonData.decode(using: FeedBackConfig.decoder)
                wSelf.delegate?.sourceChanged(isFirstTime: wSelf.isFirstTime, source: model)
                wSelf.isFirstTime = false
                wSelf.page += 1
            } catch {
                wSelf.delegate?.sourceError(with: error)
                wSelf.isInLoading = false
            }
        }
        task.resume()
    }
}
