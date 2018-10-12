//
//  Style.swift
//  SupportLib
//
//  Created by Vladislav Gushin on 12/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

public struct Style<View: UIView> {
    public let style: (View) -> Void

    public init(_ style: @escaping (View) -> Void) {
        self.style = style
    }

    public func apply(to view: View) {
        style(view)
    }
}
