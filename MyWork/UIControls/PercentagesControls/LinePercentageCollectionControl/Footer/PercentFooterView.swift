//
//  PercentFooterView.swift
//  MyWork
//
//  Created by Vladislav Gushin on 27/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class PercentFooterView: UITableViewHeaderFooterView {
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l3: UILabel!
    @IBOutlet weak var l4: UILabel!
    @IBOutlet weak var l5: UILabel!

    func setup() {
        l1.attributedText = self.getText(value: PercentagesSource.PercentagesTypeTitle.rightAnswer.value, color: UIColor(UIColor.ColorType.rightAnswer))
        l2.attributedText = self.getText(value: PercentagesSource.PercentagesTypeTitle.needCheck.value, color: UIColor(UIColor.ColorType.needCheck))
        l3.attributedText = self.getText(value:  PercentagesSource.PercentagesTypeTitle.incorrectAnswer.value, color: UIColor(UIColor.ColorType.incorrectAnswer))
        l4.attributedText = self.getText(value:  PercentagesSource.PercentagesTypeTitle.skipped.value, color: UIColor(UIColor.ColorType.skipped))
        l5.attributedText = self.getText(value:  PercentagesSource.PercentagesTypeTitle.notViewed.value, color: UIColor(UIColor.ColorType.notViewed))
    }

    private func getText(value: String, color: UIColor) -> NSMutableAttributedString {
        let v = NSMutableAttributedString(string: "● " + value)
        v.setColorForText(textForAttribute: "●", withColor: color)
        return v
    }
}

extension NSMutableAttributedString {
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
    }
}
