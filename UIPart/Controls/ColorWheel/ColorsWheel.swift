//
//  ColorsWheel.swift
//  UIPart
//
//  Created by Vladislav Gushin on 28/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate extension Array where Element == (indicator: CAShapeLayer, rect: CGRect) {
    func removeFromView() {
        for (element, _) in self {
            element.removeFromSuperlayer()
        }
    }
}

protocol ColorsWheelDelegate: class {
    func selection(_: UIColor)
}

class ColorsWheel: UIView {
    typealias IndicatorLayers = [(indicator: CAShapeLayer, rect: CGRect)]

    fileprivate struct ColorWheel {
        static var indicatorCircleRadius: CGFloat = 12.0
        static var indicatorColor: CGColor = UIColor.lightGray.cgColor
        static var indicatorBorderWidth: CGFloat = 2.0
    }

    var indicators: IndicatorLayers = []
    var colors: [UIColor] = []

    var color: UIColor! = .white
    // Layer for the Hue and Saturation wheel
    var wheelLayer: CALayer!
    // Overlay layer for the brightness
    //var brightnessLayer: CAShapeLayer!
    var brightness: CGFloat = 1.0

    // Layer for the indicator
    var indicatorLayer: CAShapeLayer!
    var point: CGPoint!

    // Retina scaling factor
    let scale: CGFloat = UIScreen.main.scale

    weak var delegate: ColorsWheelDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSelf(with: self.color)
    }

    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.setupSelf(with: color)
    }

    private func setupSelf(with color: UIColor) {
        self.backgroundColor = .black
        self.color = color
        // Layer for the Hue/Saturation wheel
        wheelLayer = CALayer()
        wheelLayer.frame = CGRect(x: 20, y: 20, width: self.frame.width - 40, height: self.frame.height - 40)
        wheelLayer.contents = createColorWheel(wheelLayer.frame.size)
        self.layer.addSublayer(wheelLayer)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // touchHandler(touches)
        touchHandlerForIndicators(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // touchHandler(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //touchHandler(touches)
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
        let dimension: CGFloat = min(originalWidth * scale, originalHeight * scale)
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
                    hsv.brightness = 1.0
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
        let c = wheelLayer.frame.width * scale / 2
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
        // Get a point (x,y) in the wheel for a given hue and saturation
        let dimension: CGFloat = min(wheelLayer.frame.width, wheelLayer.frame.height)
        let radius: CGFloat = saturation * dimension / 2
        let x = dimension / 2 + radius * cos(hue * CGFloat(Double.pi) * 2) + 20
        let y = dimension / 2 + radius * sin(hue * CGFloat(Double.pi) * 2) + 20
        return CGPoint(x: x, y: y)
    }


}

//MARK: - work with colors
extension ColorsWheel {
    func setColors(_ colors: [UIColor]) {
        self.colors = colors
        self.redraw()
    }
}

fileprivate extension ColorsWheel {
    func redraw() {
        ColorWheel.indicatorCircleRadius = 12.0
        self.indicators.removeFromView()
        self.indicators.removeAll()
        for color in colors {
            self.setup(color)
        }
    }

    func setup(_ color: UIColor) {
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) {
            print("SwiftHSVColorPicker: exception <The color provided to SwiftHSVColorPicker is not convertible to HSV>")
        }
        //self.color = color
        //self.brightness = brightness
        //brightnessLayer.fillColor = UIColor(white: 0, alpha: 1.0 - self.brightness).cgColor
        let point = pointAtHueSaturation(hue, saturation: saturation)
        drawIndicators(point: point, color: color)
    }

    func drawIndicators(point: CGPoint, color: UIColor) {
        let indicatorLayer = CAShapeLayer()
        indicatorLayer.strokeColor = ColorWheel.indicatorColor
        indicatorLayer.lineWidth = ColorWheel.indicatorBorderWidth
        indicatorLayer.fillColor = color.cgColor
        self.layer.addSublayer(indicatorLayer)
        let newRect = CGRect(x: point.x - ColorWheel.indicatorCircleRadius, y: point.y - ColorWheel.indicatorCircleRadius, width: ColorWheel.indicatorCircleRadius * 2, height: ColorWheel.indicatorCircleRadius * 2)
        indicatorLayer.path = UIBezierPath(roundedRect: newRect, cornerRadius: ColorWheel.indicatorCircleRadius).cgPath
        self.indicators.append((indicatorLayer, newRect))
    }


    func touchHandlerForIndicators(_ touches: Set<UITouch>) {
        self.redraw()
        ColorWheel.indicatorCircleRadius = 18.0
        var point: CGPoint = CGPoint(x: 0, y: 0)
        if let touch = touches.first {
            point = touch.location(in: self)
        }

        let indicator = getIndicatorCoordinate(point)
        point = indicator.point

        for i in 0..<self.indicators.count {
            let indicator = self.indicators[i]
            if indicator.rect.contains(point) {
                changeIndicatorSize(indicator, index: i)
                return
            }
        }
        
        self.backgroundColor = .white
    }

    func changeIndicatorSize(_ model: (indicator: CAShapeLayer, rect: CGRect), index: Int) {
        delegate?.selection(UIColor.init(cgColor: model.indicator.fillColor!))
        self.backgroundColor = UIColor.init(cgColor: model.indicator.fillColor!)
        model.indicator.removeFromSuperlayer()
        let indicatorLayer = model.indicator
        let oldRect = model.rect
        let newRect = CGRect(x: oldRect.midX - ColorWheel.indicatorCircleRadius, y: oldRect.midY - ColorWheel.indicatorCircleRadius, width: ColorWheel.indicatorCircleRadius * 2, height: ColorWheel.indicatorCircleRadius * 2)
        indicatorLayer.path = UIBezierPath(roundedRect: newRect, cornerRadius: ColorWheel.indicatorCircleRadius).cgPath
        self.indicators[index].rect = newRect
        self.layer.addSublayer(indicatorLayer)
    }
}