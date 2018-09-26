//
//  ColorInfoModel.swift
//  UIPart
//
//  Created by Vladislav Gushin on 26/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

final class ColorInfoModel {
    let color: UIColor
    let info: String
    init(color: UIColor, info: String) {
        self.color = color
        self.info = info
    }
}
