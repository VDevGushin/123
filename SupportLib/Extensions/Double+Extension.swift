//
//  Double+Extension.swift
//  SupportLib
//
//  Created by Vladislav Gushin on 30/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

public extension Double {
    public func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

public extension Double {
    public var r: Double {
        return fmod(floor(self / 1000000), 1000000)
    }

    public var g: Double {
        return fmod(floor(self / 1000), 1000)
    }

    public var b: Double {
        return fmod(self, 1000)
    }

    public var isDarkColor: Bool {
        return (r * 0.2126) + (g * 0.7152) + (b * 0.0722) < 127.5
    }

    public var isBlackOrWhite: Bool {
        return (r > 232 && g > 232 && b > 232) || (r < 23 && g < 23 && b < 23)
    }

    public func isDistinct(_ other: Double) -> Bool {
        let _r = self.r
        let _g = self.g
        let _b = self.b
        let o_r = other.r
        let o_g = other.g
        let o_b = other.b

        return (fabs(_r - o_r) > 63.75 || fabs(_g - o_g) > 63.75 || fabs(_b - o_b) > 63.75)
            && !(fabs(_r - _g) < 7.65 && fabs(_r - _b) < 7.65 && fabs(o_r - o_g) < 7.65 && fabs(o_r - o_b) < 7.65)
    }

    public func with(minSaturation: Double) -> Double {
        // Ref: https://en.wikipedia.org/wiki/HSL_and_HSV

        // Convert RGB to HSV
        let _r = r / 255
        let _g = g / 255
        let _b = b / 255
        var H, S, V: Double
        let M = fmax(_r, fmax(_g, _b))
        var C = M - fmin(_r, fmin(_g, _b))

        V = M
        S = V == 0 ? 0 : C / V

        if minSaturation <= S {
            return self
        }

        if C == 0 {
            H = 0
        } else if _r == M {
            H = fmod((_g - _b) / C, 6)
        } else if _g == M {
            H = 2 + ((_b - _r) / C)
        } else {
            H = 4 + ((_r - _g) / C)
        }

        if H < 0 {
            H += 6
        }

        // Back to RGB

        C = V * minSaturation
        let X = C * (1 - fabs(fmod(H, 2) - 1))
        var R, G, B: Double

        switch H {
        case 0...1:
            R = C
            G = X
            B = 0
        case 1...2:
            R = X
            G = C
            B = 0
        case 2...3:
            R = 0
            G = C
            B = X
        case 3...4:
            R = 0
            G = X
            B = C
        case 4...5:
            R = X
            G = 0
            B = C
        case 5..<6:
            R = C
            G = 0
            B = X
        default:
            R = 0
            G = 0
            B = 0
        }

        let m = V - C

        return (floor((R + m) * 255) * 1000000) + (floor((G + m) * 255) * 1000) + floor((B + m) * 255)
    }

    public func isContrasting(_ color: Double) -> Bool {
        let bgLum = (0.2126 * r) + (0.7152 * g) + (0.0722 * b) + 12.75
        let fgLum = (0.2126 * color.r) + (0.7152 * color.g) + (0.0722 * color.b) + 12.75
        if bgLum > fgLum {
            return 1.6 < bgLum / fgLum
        } else {
            return 1.6 < fgLum / bgLum
        }
    }

    public var uicolor: UIColor {
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
    }

    public var pretty: String {
        return "\(Int(self.r)), \(Int(self.g)), \(Int(self.b))"
    }
}
