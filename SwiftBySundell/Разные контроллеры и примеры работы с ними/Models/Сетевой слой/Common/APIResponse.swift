//
//  APIResponse.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 02/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

struct APIResponse<Body> {
    let statusCode: Int
    let body: Body
}

extension APIResponse where Body == Data? {
    func decode<BodyType: Decodable>(to type: BodyType.Type, decoder: JSONDecoder = JSONDecoder()) throws -> APIResponse<BodyType> {
        guard let data = body else { throw APIError.decodingFailure }
        let decodedJSON = try decoder.decode(BodyType.self, from: data)
        return APIResponse<BodyType>(statusCode: self.statusCode,
            body: decodedJSON)
    }
}

extension APIResponse where Body == Data {
    func decode<BodyType: Decodable>(to type: BodyType.Type, decoder: JSONDecoder = JSONDecoder()) throws -> APIResponse<BodyType> {
        let decodedJSON = try decoder.decode(BodyType.self, from: body)
        return APIResponse<BodyType>(statusCode: self.statusCode,
            body: decodedJSON)
    }
}
