//
//  ColorInfoModel.swift
//  ImageAnalyzer
//
//  Created by Vladislav Gushin on 30/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

public final class ColorInfoModel {
    let color: UIColor
    let info: String
    init(color: UIColor, info: String) {
        self.color = color
        self.info = info
    }
}
