//
//  Set+Extension.swift
//  SupportLib
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

public extension Set {
    func getElement(index: Int) -> Element {
        return Array(self)[index]
    }
}
