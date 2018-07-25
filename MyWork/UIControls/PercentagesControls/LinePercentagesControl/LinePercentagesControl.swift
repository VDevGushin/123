//
//  LinePercentagesControl.swift
//  MyWork
//
//  Created by Vladislav Gushin on 25/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let barHeight: CGFloat = 30.0
    static let barMinHeight: CGFloat = 20.0
    static let barMaxHeight: CGFloat = 40.0
    static let marginSize: CGFloat = 20.0
    static let pieChartWidthPercentage: CGFloat = 1.0 / 3.0
    static let pieChartBorderWidth: CGFloat = 1.0
    static let pieChartMinRadius: CGFloat = 30.0
    static let pieChartGradientAngle: CGFloat = 90.0
    static let barChartCornerRadius: CGFloat = 4.0
    static let barChartLegendSquareSize: CGFloat = 8.0
    static let legendTextMargin: CGFloat = 5.0
}

@IBDesignable
class LinePercentagesControl: UIView {
    var source = [TestClass]() {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        UIColor.white.setFill()
        UIRectFill(bounds)

        super.draw(rect)

        let context = UIGraphicsGetCurrentContext()
        drawBarGraphInContext(context: context)
    }

    @IBInspectable var barHeight: CGFloat = Constants.barHeight {
        didSet {
            barHeight = max(min(barHeight, Constants.barMaxHeight), Constants.barMinHeight)
        }
    }
}

extension LinePercentagesControl {
    func drawRoundedRect(rect: CGRect, inContext context: CGContext?,
                         radius: CGFloat, borderColor: CGColor, fillColor: CGColor) {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.minY),
                    tangent2End: CGPoint(x: rect.maxX, y: rect.maxY), radius: radius)
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.maxY),
                    tangent2End: CGPoint(x: rect.minX, y: rect.maxY), radius: radius)
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.maxY),
                    tangent2End: CGPoint(x: rect.minX, y: rect.minY), radius: radius)
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.minY),
                    tangent2End: CGPoint(x: rect.maxX, y: rect.minY), radius: radius)
        path.closeSubpath()
        context?.setLineWidth(1.0)
        context?.setFillColor(fillColor)
        context?.setStrokeColor(borderColor)
        context?.addPath(path)
        context?.drawPath(using: .fillStroke)
    }

    func pieChartRectangle() -> CGRect {
        let width = bounds.size.width * Constants.pieChartWidthPercentage - 2 * Constants.marginSize
        let height = bounds.size.height - 2 * Constants.marginSize
        let diameter = max(min(width, height), Constants.pieChartMinRadius)
        let rect = CGRect(x: Constants.marginSize,
                          y: bounds.midY - diameter / 2.0,
                          width: diameter, height: diameter)
        return rect
    }

    func barChartRectangle() -> CGRect {
        let width = bounds.size.width - Constants.marginSize * 2
        let rect = CGRect(x: Constants.marginSize,
                          y: Constants.marginSize,
                          width: width, height: barHeight)
        return rect
    }

    // 3
    func barChartLegendRectangle() -> CGRect {
        let barchartRect = barChartRectangle()
        let rect = barchartRect.offsetBy(dx: 0.0, dy: -(barchartRect.size.height + Constants.marginSize))
        return rect
    }

    class TestClass {
        var percent: Double
        var color: UIColor
        init(value: Double, _ color: UIColor) {
            self.percent = value
            self.color = color
        }
    }

    func setSource() {
        let data1 = TestClass(value: Double(arc4random_uniform(10)) / 10.0, UIColor(UIColor.ColorType.incorrectAnswer))
        let data2 = TestClass(value: Double(arc4random_uniform(10)) / 10.0, UIColor(UIColor.ColorType.needCheck))
        let data4 = TestClass(value: Double(arc4random_uniform(10)) / 10.0, UIColor(UIColor.ColorType.rightAnswer))
        let data5 = TestClass(value: Double(arc4random_uniform(10)) / 10.0, UIColor(UIColor.ColorType.skipped))
        source = [data1, data2, data4, data5]
    }


    func drawBarGraphInContext(context: CGContext?) {
        let barChartRect = barChartRectangle()
        drawRoundedRect(rect: barChartRect, inContext: context,
                        radius: Constants.barChartCornerRadius,
                        borderColor: UIColor(UIColor.ColorType.notViewed).cgColor,
                        fillColor: UIColor(UIColor.ColorType.notViewed).cgColor)


        if source.count > 0 {
            var clipRect = barChartRect
            for data in source {
                let clipWidth = floor(barChartRect.width * CGFloat(data.percent))
                clipRect.size.width = clipWidth
                context?.saveGState()
                context?.clip(to: clipRect)
                drawRoundedRect(rect: barChartRect, inContext: context,
                                radius: Constants.barChartCornerRadius,
                                borderColor: data.color.cgColor,
                                fillColor: data.color.cgColor)
                context?.restoreGState()
                clipRect.origin.x = clipRect.maxX
            }
        }
    }
}

