//
//  NSMutableAttributedString.swift
//  MyWork
//
//  Created by Vladislav Gushin on 27/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
extension NSMutableAttributedString {
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
    }
}
