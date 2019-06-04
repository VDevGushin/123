//
//  URLCache+Ex.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 04/06/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

extension URLCache {
    static func makePromiseCache(path: String = "base") -> URLCache {
        let MB = 1024 * 1024
        return URLCache(memoryCapacity: 50 * MB, diskCapacity: 50 * MB, diskPath: path)
    }
}
