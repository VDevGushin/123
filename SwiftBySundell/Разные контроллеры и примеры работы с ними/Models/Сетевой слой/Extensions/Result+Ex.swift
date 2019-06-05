//
//  Result+Ex.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 05/06/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

extension Result where Success == APIResponse<Data> {
    func decode<T: Decodable>(with decoder: JSONDecoder = .init()) -> Result<APIResponse<T>, APIError> {
        do {
            let response = try get()
            let result = try response.decode(to: T.self, decoder: decoder)
            return .success(result)
        } catch {
            return .failure(.decodingFailure)
        }
    }
}

