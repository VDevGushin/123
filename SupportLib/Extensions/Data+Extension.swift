//
//  Data+Extension.swift
//  SupportLib
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

public extension Data {
    public func decode<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }

    //более расширенная функция декодирования
    public func decode<T: Decodable>(using decoder: JSONDecoder = .init()) throws -> T {
        return try decoder.decode(T.self, from: self)
    }
}
