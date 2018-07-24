//
//  UIColor+Ex.swift
//  MyWork
//
//  Created by Vladislav Gushin on 24/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit


extension UIColor {
    convenience init(hex: String) {
        let color = hex.fromHex()
        self.init(cgColor: color.cgColor)
    }

    convenience init(_ colorType: ColorType) {
        self.init(hex: colorType.rawValue)
    }

    enum ColorType: String {
        case rightAnswer = "#76d5b4"
        case needCheck = "#76cced"
        case incorrectAnswer = "#ef8874"
        case skipped = "#f5bd89"
        case notViewed = "#eaeaea"
    }
}
