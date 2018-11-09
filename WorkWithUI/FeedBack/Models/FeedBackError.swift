//
//  FeedBackError.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 06/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

enum FeedBackError: Error {
    case noData
    case noImage
    case sendModelError(FeedBackErrorMessage)
    case decode
    case error(Error)
}
