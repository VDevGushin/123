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
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setColor(with model: (current: ColorInfoModel, next: ColorInfoModel?)) {
        let currentColor = model.current.color
        var sourceColors = [currentColor]
        self.colorLabel.text = model.current.info
        if currentColor.isLight() {
            self.colorLabel.textColor = currentColor.darken(byPercentage: 30)
        } else {
            self.colorLabel.textColor = currentColor.lighten(byPercentage: 30)
        }
        if let nextColor = model.next?.color {
            sourceColors.append(nextColor)
        }
        self.gradientView.setGradientBackground(colors: sourceColors, isHorisontal: false)

    }
}
