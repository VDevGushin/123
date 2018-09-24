//
//  TransformingСollections.swift
//  MyWork
//
//  Created by Vladislav Gushin on 21/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

// MARK: - mapping and flatMapping
extension Bundle {
    func loadFiles(named fileNames: [String]) throws -> [File] {
        return fileNames.compactMap { name in
            return url(forResource: name, withExtension: nil)
        }.map(Data.init).map(File.init)
    }
}
// MARK: - Reducing

extension Bundle {
    func calculateTotal(named fileNames: [String]) -> Int {
        return fileNames.reduce(0) { result, name in
            return result + name.count
        }
    }
}
