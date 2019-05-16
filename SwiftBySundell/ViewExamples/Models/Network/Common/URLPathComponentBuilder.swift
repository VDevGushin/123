//
//  URLPathComponentBuilder.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 16/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation


//В каждом end point конфигураторе есть enum с позможными path
//Данный протокол нужен для разных конфигураций этих путей

protocol URLPathComponentBuilder: CustomStringConvertible {
    static func createPath(components: Self...) -> String
}

extension URLPathComponentBuilder {
    static func createPath(components: Self...) -> String {
        return components.map { $0.description }.reduce("") {
            var old = $0
            old += "/\($1)"
            return old
        }
    }
}
