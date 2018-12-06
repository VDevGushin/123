//
//  SourceViewModel.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 05/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

struct Source {
    var id: String
    var name: String
    var description: String

    init?(dictionary: [String: String]) {
        guard let id = dictionary["id"],
            let name = dictionary["name"],
            let description = dictionary["description"] else {
                return nil
        }

        self.id = id
        self.name = name
        self.description = description
    }

    init(viewModel: SourceViewModel) {
        self.id = viewModel.id ?? ""
        self.name = viewModel.name
        self.description = viewModel.body
    }
}

class SourceViewModel {
    var id: String?
    var name: String
    var body: String

    init(name: String, description: String) {
        self.name = name
        self.body = description
    }

    init(source: Source) {
        self.id = source.id
        self.name = source.name
        self.body = source.description
    }
}
