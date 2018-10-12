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

    mutating func removeFromViewExceptMain() {
        let mainIndicator = self.first { $0.isMain == true }
        guard let mainIndex = mainIndicator?.index else { return }
        var indexes = [Int]()
        for i in 0..<self.count {
            if i != mainIndex {
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
    weak var delegate: ColorsWheelDelegate?
    lazy var config = ColorsWheelConfiguration()
    var wheelLayer: CALayer!
    var brightnessLayer: CAShapeLayer!

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
        if !config.isReady {
            config.isReady.toggle()
            wheelLayer.frame = self.bounds
            wheelLayer.contents = createColorWheel(wheelLayer.frame.size)
        }
    }

    func setColors(_ colors: [UIColor], colorScheme: UIColor.ColorScheme) {
        config.startColors = colors
        config.currentColors = colors
        config.mainColor = colors[0]
        config.colorScheme = colorScheme
        config.brightness = config.startColors[0].brightness()
        self.wheelLayer.contents = createColorWheel(wheelLayer.frame.size)
        layoutSubviews()
        self.redraw()
        self.styleIndicator(config.indicators[0])
    }

    func selectColor(_ color: UIColor) {
        for i in 0..<config.indicators.count where config.indicators[i].color == color {
            self.redraw()
            self.styleIndicator(config.indicators[i])
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

//MARK: - Drawing
fileprivate extension ColorsWheel {
    func isMain(color: UIColor) -> Bool {
        return color == config.mainColor
    }

    func redraw() {
        config.indicators.removeFromView()
        self.drawIndicators(config.startColors)
    }

    func touchHandlerForIndicators(_ touches: Set<UITouch>) {
        var point: CGPoint = CGPoint(x: 0, y: 0)
        if let touch = touches.first { point = touch.location(in: self) }
        let indicatorCoordinate = getIndicatorCoordinate(point)
        point = indicatorCoordinate.point

        for i in 0..<config.indicators.count {
            let indicator = config.indicators[i]
            if indicator.rect.contains(point) {
                if indicator.isMain {
                    var color = (hue: CGFloat(0), saturation: CGFloat(0))
                    if !indicatorCoordinate.isCenter {
                        color = hueSaturationAtPoint(CGPoint(x: point.x * config.scale, y: point.y * config.scale))
                    }
                    let newColor = UIColor(hue: color.hue, saturation: color.saturation, brightness: config.brightness, alpha: 1.0)
                    config.indicators[i].color = newColor
                    config.mainColor = newColor
                    self.styleIndicator(indicator, newPoint: point)
                } else {
                    self.styleIndicator(indicator)
                }
            } else {
                self.resetIndicator(indicator)
            }
        }
    }

    func makeNewIndicatorsFor(model: Indicator) {
        let colors = model.color.colorScheme(config.colorScheme)
        config.indicators.removeFromViewExceptMain()
        self.drawIndicators(colors)
    }

    func styleIndicator(_ model: Indicator, newPoint: CGPoint? = nil) {
        delegate?.selection(color: model.color.lighter(by: 30)!)
        let indicatorLayer = model.layer
        var newRect = CGRect.zero
        if let newPoint = newPoint {
            newRect = CGRect(x: newPoint.x - config.selectedIndicatorCircleRadius, y: newPoint.y - config.selectedIndicatorCircleRadius, width: config.selectedIndicatorCircleRadius * 2, height: config.selectedIndicatorCircleRadius * 2)
            self.makeNewIndicatorsFor(model: model)
        } else {
            let oldRect = model.rect
            newRect = CGRect(x: oldRect.midX - config.selectedIndicatorCircleRadius, y: oldRect.midY - config.selectedIndicatorCircleRadius, width: config.selectedIndicatorCircleRadius * 2, height: config.selectedIndicatorCircleRadius * 2)
        }
        indicatorLayer.path = UIBezierPath(roundedRect: newRect, cornerRadius: config.selectedIndicatorCircleRadius).cgPath
        indicatorLayer.fillColor = model.color.cgColor
        config.indicators[model.index].rect = newRect
    }

    func resetIndicator(_ model: Indicator) {
        let indicatorLayer = model.layer
        let oldRect = model.rect
        let newRect = CGRect(x: oldRect.midX - config.indicatorCircleRadius, y: oldRect.midY - config.indicatorCircleRadius, width: config.indicatorCircleRadius * 2, height: config.indicatorCircleRadius * 2)
        indicatorLayer.path = UIBezierPath(roundedRect: newRect, cornerRadius: config.indicatorCircleRadius).cgPath
        config.indicators[model.index].rect = newRect
    }

    func drawIndicators(_ colors: [UIColor]) {
        if config.indicators.count > 0 {
            var index = config.indicators.map { $0.index }.max() ?? 0
            for i in 0..<colors.count {
                index += 1
                let settings = (colors[i], index)
                let newIndicator = makeIndicator(settings)
                config.indicators.append(newIndicator)
            }
        } else {
            for i in 0..<colors.count {
                let settings = (colors[i], i)
                let newIndicator = makeIndicator(settings)
                config.indicators.append(newIndicator)
            }
        }
        let reversed: [Indicator] = config.indicators.sorted { $0.index > $1.index }
        for i in 0..<reversed.count {
            self.layer.addSublayer(reversed[i].layer)
        }
    }

    func makeIndicator(_ settings: (color: UIColor, index: Int)) -> Indicator {
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = settings.color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) { print("SwiftHSVColorPicker: exception <The color provided to SwiftHSVColorPicker is not convertible to HSV>") }
        let isMain = settings.index == 0
        let point = pointAtHueSaturation(hue, saturation: saturation)
        let indicatorLayer = CAShapeLayer()
        indicatorLayer.strokeColor = !isMain ? config.indicatorColor : config.mainIndicatorColor
        indicatorLayer.lineWidth = config.indicatorBorderWidth
        indicatorLayer.fillColor = settings.color.cgColor
        let newRect = CGRect(x: point.x - config.indicatorCircleRadius, y: point.y - config.indicatorCircleRadius, width: config.indicatorCircleRadius * 2, height: config.indicatorCircleRadius * 2)
        indicatorLayer.path = UIBezierPath(roundedRect: newRect, cornerRadius: config.indicatorCircleRadius).cgPath
        let newIndicator = Indicator(layer: indicatorLayer, rect: newRect, color: settings.color, index: settings.index, isMain: isMain)
        return newIndicator
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
