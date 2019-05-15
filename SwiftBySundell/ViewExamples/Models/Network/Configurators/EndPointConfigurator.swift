//
//  RequestConfigurator.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 15/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

protocol EndPointConfigurator {
    var scheme: String { get set }
    var host: String { get set }
    var path: String { get set }
    var method: HTTPMethod { get set }
    var queryItems: [URLQueryItem]? { get set }
    var headers: [HTTPHeader]? { get set }
    var body: Data? { get set }
    var multipartData: [Multipartable]? { get set }
}

protocol Multipartable {
    var id: ObjectIdentifier { get set }
    var maxSize: Double? { get set }
    var fileName: String { get set }
    var mimeType: String { get set }
    var data: Data { get set }
    var bytes: [UInt8] { get set }
    var isValid: Bool { get }
}

extension Multipartable {
    var isValid: Bool {
        guard let maxSize = self.maxSize else {
            return true
        }
        let sizeMB = Double(self.bytes.count) / 1024.0 / 1024.0
        return sizeMB <= maxSize
    }
}
