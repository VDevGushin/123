//
//  UIColor+Ex.swift
//  MyWork
//
//  Created by Vladislav Gushin on 24/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

public struct UIImageColors {
    public var background: UIColor!
    public var primary: UIColor!
    public var secondary: UIColor!
    public var detail: UIColor!

    public init(background: UIColor, primary: UIColor, secondary: UIColor, detail: UIColor) {
        self.background = background
        self.primary = primary
        self.secondary = secondary
        self.detail = detail
    }
}

public enum UIImageColorsQuality: CGFloat {
    case lowest = 50 // 50px
    case low = 100 // 100px
    case high = 250 // 250px
    case highest = 0 // No scale
}

public struct UIImageColorsCounter {
    let color: Double
    let count: Int
    init(color: Double, count: Int) {
        self.color = color
        self.count = count
    }
}

public extension UIColor {
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

    static func random() -> UIColor {
        return UIColor(red: .random(),
                       green: .random(),
                       blue: .random(),
                       alpha: 1.0)
    }

    static var linePercentCollectionHexSource: [String] {
        return ["#00AABB", "#26C6DA", "#82E9F6", "#26C6DA", "#4DD8D3"]
    }

    static var linePercentCollectionColorSource: [UIColor] {
        var source = [UIColor]()
        for colorHex in UIColor.linePercentCollectionHexSource {
            source.append(UIColor(hex: colorHex))
        }
        return source
    }

    func isLight() -> Bool {
        let components = self.cgColor.components!
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        if brightness < 0.5
            {
            return false
        }
            else
        {
            return true
        }
    }
}
