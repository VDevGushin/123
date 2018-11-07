//
//  OrganisationWorker.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
import SupportLib

protocol IFeedBackWorkerDelegate: class {
    func sourceChanged<T>(isFirstTime: Bool, source: T)
    func sourceError(with: Error)
    func sourceCount(perPage: Int) -> Int
}

protocol IFeedBackWorker {
    var delegate: IFeedBackWorkerDelegate? { get set }
    func execute()
    func refresh()
}

protocol OrganisationWorkerDelegate: IFeedBackWorkerDelegate {
    func sourceChanged(isFirstTime: Bool, source: Result<[Organisation]>)
    func sourceCount(perPage: Int) -> Int
}

final class OrganisationWorker: IFeedBackWorker {
    weak var delegate: IFeedBackWorkerDelegate?
    typealias T = Result
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
        //guard let page = delegate?.sourceCount(perPage: self.perPage) else { return }
        self.isInLoading = true
        // self.page = page
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
                let model: [Organisation] = try jsonData.decode(using: FeedBackConfig.decoder)
                wSelf.delegate?.sourceChanged(isFirstTime: wSelf.isFirstTime, source: model)
                wSelf.isFirstTime = false
            } catch {
                wSelf.delegate?.sourceError(with: error)
                wSelf.isInLoading = false
            }
        }
        task.resume()
    }
}
