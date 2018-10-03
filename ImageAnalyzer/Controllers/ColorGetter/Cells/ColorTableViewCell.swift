//
//  ColorTableViewCell.swift
//  ImageAnalyzer
//
//  Created by Vladislav Gushin on 30/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

public class ColorTableViewCell: UITableViewCell {
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var colorLabel: UILabel!

    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setColor(with model: (current: ColorInfoModel, next: ColorInfoModel?)) {
        let currentColor = model.current.color
        var sourceColors = [currentColor]
        self.colorLabel.text = model.current.info
        self.colorLabel.textColor = currentColor.isLight() ? currentColor.darken(byPercentage: 30) : currentColor.lighten(byPercentage: 30)

        if let nextColor = model.next?.color {
            sourceColors.append(nextColor)
        }

        self.gradientView.setGradientBackground(colors: sourceColors, isHorisontal: false)
    }
}
