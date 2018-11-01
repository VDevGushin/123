//
//  ProfileWorker.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 01/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
import SupportLib

protocol ProfileWorkerDelegate: class {
    func sourceChanged(isFirstTime: Bool, source: Result<[Profile]>)
}

final class ProfileWorker {
    weak var delegate: ProfileWorkerDelegate?
    private var perPage = 1000
    private var page = 1
    private var isFirstTime = true
    private var isInLoading = false

    func refresh() {
        self.isFirstTime = true
        self.page = 1
        if !self.isInLoading {
            self.getProfiles()
        }
    }

    func getProfiles() {
        self.isInLoading = true
        let config = ETBChatWebConfigurator.getProfiles(page: self.page, perPage: self.perPage)
        let request = ChatEndpoint(configurator: config).urlRequest()
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let wSelf = self else { return }
            
            if let error = error {
                wSelf.delegate?.sourceChanged(isFirstTime: false, source: Result.error(error))
                return
            }
            guard let jsonData = data else {
                wSelf.delegate?.sourceChanged(isFirstTime: false, source: Result.error(ChatsLoaderError.noData))
                return
            }
            
            do {
                let profiles: [Profile] = try jsonData.decode(using: ChatResources.decoder)
                wSelf.delegate?.sourceChanged(isFirstTime: wSelf.isFirstTime, source: Result.result(profiles.reversed()))
                wSelf.isFirstTime = false
            } catch {
                wSelf.delegate?.sourceChanged(isFirstTime: false, source: Result.error(error)) }
            
            wSelf.isInLoading = false
        }
        task.resume()
    }
}

