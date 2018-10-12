//
//  ColorsWheelConfiguration.swift
//  ImageAnalyzer
//
//  Created by Vladislav Gushin on 11/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

struct ColorsWheelConfiguration {
    typealias IndicatorLayers = [Indicator]
    let indicatorCircleRadius: CGFloat = 8.0
    let selectedIndicatorCircleRadius: CGFloat = 18.0
    let indicatorColor: CGColor = UIColor.white.cgColor
    let mainIndicatorColor: CGColor = UIColor.flatPink.cgColor
    let indicatorBorderWidth: CGFloat = 2.0
    let scale: CGFloat = UIScreen.main.scale
    var brightness: CGFloat = 1.0
    var indicators: IndicatorLayers = []
    var startColors: [UIColor] = []
    var colorScheme: UIColor.ColorScheme = .triad
    var mainColor: UIColor = .white
    var currentColors: [UIColor] = []
    var isReady = false
}
