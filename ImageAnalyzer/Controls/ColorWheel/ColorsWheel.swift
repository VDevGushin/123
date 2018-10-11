//
//  ColorsWheel.swift
//  UIPart
//
//  Created by Vladislav Gushin on 28/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

fileprivate extension Array where Element == Indicator {
    mutating func removeFromView() {
        for element in self {
            element.layer.removeFromSuperlayer()
        }
        self.removeAll()
    }

    mutating func removeFromView(ignore index: Int) {
        var indexes = [Int]()
        for i in 0..<self.count {
            if i != index {
                indexes.append(i)
            }
        }

        for index in indexes.sorted(by: >) {
            self[index].layer.removeFromSuperlayer()
            remove(at: index)
        }
    }
}

protocol ColorsWheelDelegate: class {
    func selection(color: UIColor)
}

class ColorsWheel: UIView {
    lazy var config = ColorsWheelConfiguration()
    var isReady = false
    var wheelLayer: CALayer!
    // Layer for the indicator
    var brightnessLayer: CAShapeLayer!
    weak var delegate: ColorsWheelDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSelf()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSelf(frame: frame)
    }

    private func setupSelf(frame: CGRect? = nil) {
        wheelLayer = CALayer()
        wheelLayer.frame = frame ?? CGRect(x: self.bounds.midX, y: self.bounds.midY, width: self.bounds.width, height: self.bounds.height)
        self.layer.addSublayer(wheelLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if !isReady {
            isReady.toggle()
            wheelLayer.frame = self.bounds
            wheelLayer.contents = createColorWheel(wheelLayer.frame.size)
        }
    }

    func setColors(_ colors: [UIColor], colorScheme: UIColor.ColorScheme) {
        config.colors = colors
        config.colorScheme = colorScheme
        self.redraw(isFirtTime: true)
    }

    func selectColor(_ color: UIColor) {
        for i in 0..<config.indicators.count where config.indicators[i].color == color {
            self.redraw()
            self.changeIndicatorSize(config.indicators[i], index: i)
            break
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandlerForIndicators(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandlerForIndicators(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandlerForIndicators(touches)
    }
}

fileprivate extension ColorsWheel {
    func redraw(isFirtTime: Bool = false) {
        if isFirtTime {
            config.brightness = config.colors[0].brightness()
            self.wheelLayer.contents = createColorWheel(wheelLayer.frame.size)
            layoutSubviews()
        }
        config.indicators.removeFromView()
        for i in 0..<config.colors.count {
            let isMainColor = i == 0 ? true : false
            self.drawIndicator(config.colors[i])
        }
        if isFirtTime {
            self.changeIndicatorSize(config.indicators[0], index: 0)
        }
    }

    func touchHandlerForIndicators(_ touches: Set<UITouch>) {
        var point: CGPoint = CGPoint(x: 0, y: 0)
        if let touch = touches.first { point = touch.location(in: self) }
        let indicatorCoordinate = getIndicatorCoordinate(point)
        point = indicatorCoordinate.point

        for i in 0..<config.indicators.count {
            let indicator = config.indicators[i]
            if indicator.rect.contains(point) {
                var color = (hue: CGFloat(0), saturation: CGFloat(0))
                if !indicatorCoordinate.isCenter {
                    color = hueSaturationAtPoint(CGPoint(x: point.x * config.scale, y: point.y * config.scale))
                }
                config.indicators[i].color = UIColor(hue: color.hue, saturation: color.saturation, brightness: config.brightness, alpha: 1.0)
                self.changeIndicatorSize(indicator, index: i, newPoint: point)
                break
            } else {
                self.resetIndicatorSize(indicator, index: i)
            }
        }
    }
}

//MARK: - Drawing
fileprivate extension ColorsWheel {
    func makeNewIndicatorsFor(color: UIColor, index: Int) {
        let colors = color.colorScheme(config.colorScheme)
        config.indicators.removeFromView(ignore: index)
        for color in colors {
            self.drawIndicator(color)
        }
    }

    func changeIndicatorSize(_ model: Indicator, index: Int, newPoint: CGPoint? = nil) {
        delegate?.selection(color: model.color.lighter(by: 30)!)
        let indicatorLayer = model.layer
        var newRect = CGRect.zero
        if let newPoint = newPoint {
            newRect = CGRect(x: newPoint.x - config.selectedIndicatorCircleRadius, y: newPoint.y - config.selectedIndicatorCircleRadius, width: config.selectedIndicatorCircleRadius * 2, height: config.selectedIndicatorCircleRadius * 2)
            self.makeNewIndicatorsFor(color: model.color, index: index)
        } else {
            let oldRect = model.rect
            newRect = CGRect(x: oldRect.midX - config.selectedIndicatorCircleRadius, y: oldRect.midY - config.selectedIndicatorCircleRadius, width: config.selectedIndicatorCircleRadius * 2, height: config.selectedIndicatorCircleRadius * 2)
        }
        indicatorLayer.path = UIBezierPath(roundedRect: newRect, cornerRadius: config.selectedIndicatorCircleRadius).cgPath
        indicatorLayer.fillColor = model.color.cgColor
        config.indicators[index].rect = newRect
    }

    func drawIndicator(_ color: UIColor) {
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) { print("SwiftHSVColorPicker: exception <The color provided to SwiftHSVColorPicker is not convertible to HSV>") }
        let point = pointAtHueSaturation(hue, saturation: saturation)
        let indicatorLayer = CAShapeLayer()
        indicatorLayer.strokeColor = config.indicatorColor
        indicatorLayer.lineWidth = config.indicatorBorderWidth
        indicatorLayer.fillColor = color.cgColor
        self.layer.addSublayer(indicatorLayer)
        let newRect = CGRect(x: point.x - config.indicatorCircleRadius, y: point.y - config.indicatorCircleRadius, width: config.indicatorCircleRadius * 2, height: config.indicatorCircleRadius * 2)
        indicatorLayer.path = UIBezierPath(roundedRect: newRect, cornerRadius: config.indicatorCircleRadius).cgPath
        let newIndicator = Indicator(layer: indicatorLayer, rect: newRect, color: color)
        config.indicators.append(newIndicator)
    }

    func resetIndicatorSize(_ model: Indicator, index: Int) {
        let indicatorLayer = model.layer
        let oldRect = model.rect
        let newRect = CGRect(x: oldRect.midX - config.indicatorCircleRadius, y: oldRect.midY - config.indicatorCircleRadius, width: config.indicatorCircleRadius * 2, height: config.indicatorCircleRadius * 2)
        indicatorLayer.path = UIBezierPath(roundedRect: newRect, cornerRadius: config.indicatorCircleRadius).cgPath
        config.indicators[index].rect = newRect
    }

    func getIndicatorCoordinate(_ coord: CGPoint) -> (point: CGPoint, isCenter: Bool) {
        // Making sure that the indicator can't get outside the Hue and Saturation wheel
        let dimension: CGFloat = min(wheelLayer.frame.width, wheelLayer.frame.height)
        let radius: CGFloat = dimension / 2
        let wheelLayerCenter: CGPoint = CGPoint(x: wheelLayer.frame.origin.x + radius, y: wheelLayer.frame.origin.y + radius)

        let dx: CGFloat = coord.x - wheelLayerCenter.x
        let dy: CGFloat = coord.y - wheelLayerCenter.y
        let distance: CGFloat = sqrt(dx * dx + dy * dy)
        var outputCoord: CGPoint = coord

        // If the touch coordinate is outside the radius of the wheel, transform it to the edge of the wheel with polar coordinates
        if (distance > radius) {
            let theta: CGFloat = atan2(dy, dx)
            outputCoord.x = radius * cos(theta) + wheelLayerCenter.x
            outputCoord.y = radius * sin(theta) + wheelLayerCenter.y
        }

        // If the touch coordinate is close to center, focus it to the very center at set the color to white
        let whiteThreshold: CGFloat = 10
        var isCenter = false
        if (distance < whiteThreshold) {
            outputCoord.x = wheelLayerCenter.x
            outputCoord.y = wheelLayerCenter.y
            isCenter = true
        }
        return (outputCoord, isCenter)
    }

    func createColorWheel(_ size: CGSize) -> CGImage {
        // Creates a bitmap of the Hue Saturation wheel
        let originalWidth: CGFloat = size.width
        let originalHeight: CGFloat = size.height
        let dimension: CGFloat = min(originalWidth * config.scale, originalHeight * config.scale)
        let bufferLength: Int = Int(dimension * dimension * 4)

        let bitmapData: CFMutableData = CFDataCreateMutable(nil, 0)
        CFDataSetLength(bitmapData, CFIndex(bufferLength))
        let bitmap = CFDataGetMutableBytePtr(bitmapData)

        for y in stride(from: CGFloat(0), to: dimension, by: CGFloat(1)) {
            for x in stride(from: CGFloat(0), to: dimension, by: CGFloat(1)) {
                var hsv: HSV = (hue: 0, saturation: 0, brightness: 0, alpha: 0)
                var rgb: RGB = (red: 0, green: 0, blue: 0, alpha: 0)

                let color = hueSaturationAtPoint(CGPoint(x: x, y: y))
                let hue = color.hue
                let saturation = color.saturation
                var a: CGFloat = 0.0
                if (saturation < 1.0) {
                    // Antialias the edge of the circle.
                    if (saturation > 0.99) {
                        a = (1.0 - saturation) * 100
                    } else {
                        a = 1.0
                    }

                    hsv.hue = hue
                    hsv.saturation = saturation
                    hsv.brightness = config.brightness
                    hsv.alpha = a
                    rgb = hsv2rgb(hsv)
                }
                let offset = Int(4 * (x + y * dimension))
                bitmap?[offset] = UInt8(rgb.red * 255)
                bitmap?[offset + 1] = UInt8(rgb.green * 255)
                bitmap?[offset + 2] = UInt8(rgb.blue * 255)
                bitmap?[offset + 3] = UInt8(rgb.alpha * 255)
            }
        }

        // Convert the bitmap to a CGImage
        let colorSpace: CGColorSpace? = CGColorSpaceCreateDeviceRGB()
        let dataProvider: CGDataProvider? = CGDataProvider(data: bitmapData)
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.last.rawValue)
        let imageRef: CGImage? = CGImage(width: Int(dimension), height: Int(dimension), bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: Int(dimension) * 4, space: colorSpace!, bitmapInfo: bitmapInfo, provider: dataProvider!, decode: nil, shouldInterpolate: false, intent: CGColorRenderingIntent.defaultIntent)
        return imageRef!
    }

    func hueSaturationAtPoint(_ position: CGPoint) -> (hue: CGFloat, saturation: CGFloat) {
        // Get hue and saturation for a given point (x,y) in the wheel
        let c = wheelLayer.frame.width * config.scale / 2
        let dx = CGFloat(position.x - c) / c
        let dy = CGFloat(position.y - c) / c
        let d = sqrt(CGFloat (dx * dx + dy * dy))

        let saturation: CGFloat = d

        var hue: CGFloat
        if (d == 0) {
            hue = 0
        } else {
            hue = acos(dx / d) / CGFloat(Double.pi) / 2.0
            if (dy < 0) {
                hue = 1.0 - hue
            }
        }
        return (hue, saturation)
    }

    func pointAtHueSaturation(_ hue: CGFloat, saturation: CGFloat) -> CGPoint {
        let dimension: CGFloat = min(wheelLayer.frame.width, wheelLayer.frame.height)
        let radius: CGFloat = saturation * dimension / 2
        let x = dimension / 2 + radius * cos(hue * CGFloat(Double.pi) * 2) + wheelLayer.frame.origin.x
        let y = dimension / 2 + radius * sin(hue * CGFloat(Double.pi) * 2) + wheelLayer.frame.origin.y
        return CGPoint(x: x, y: y)
    }
}
