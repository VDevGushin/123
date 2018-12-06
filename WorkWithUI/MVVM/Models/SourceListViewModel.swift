//
//  SourceListViewModel.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 05/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

protocol IWebservice {
    func loadSources(_ handler: ([Source]) -> Void)
}

class Webservice: IWebservice {
    func loadSources(_ handler: ([Source]) -> Void) {
        handler([])
    }
}

class SourceListViewModel {
    private(set) var sourceViewModels: [SourceViewModel] = [SourceViewModel]()
    private var webService: IWebservice

    init(webService: IWebservice) {
        self.webService = webService
        self.populateSources()
    }

    func populateSources() {
        self.webService.loadSources { [unowned self] sources in
            self.sourceViewModels = sources.compactMap(SourceViewModel.init)
        }
    }

    func addSource(source: SourceViewModel) {
        self.sourceViewModels.append(source)
    }

    func source(at index: Int) -> SourceViewModel {
        return self.sourceViewModels[index]
    }
}
