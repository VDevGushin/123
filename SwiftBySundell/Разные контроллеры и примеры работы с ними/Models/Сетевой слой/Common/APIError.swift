//
//  APIError.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 02/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case makeRequestError
    case requestFailed(Error?)
    case decodingFailure
    case canceled
}
