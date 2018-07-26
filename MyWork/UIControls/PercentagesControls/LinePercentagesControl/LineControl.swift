//
//  LineControl.swift
//  MyWork
//
//  Created by Vladislav Gushin on 26/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

protocol LineControlDelegate: class {
    func updatePercents(value: String)
}

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
class LineControl: UIView {
    fileprivate var mode = RoundPercentagesControlMode.multiple {
        didSet {
            refresh()
        }
    }

    weak var delegate: LineControlDelegate?
    private let dataSource = LinePercentagesSource()

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

extension LineControl {
    func setColor(_ color: UIColor) {
        self.dataSource.setStyle(with: color)
        refresh()
    }

    func update(with source: Set<RoundPercentagesSource.PercentagesType>) {
        self.dataSource.setValue(with: source)
        refresh()
    }

    func clear() {
        let values: Set<RoundPercentagesSource.PercentagesType> = [.rightAnswer(0), .needCheck(0), .incorrectAnswer(0), .skipped(0), .notViewed(1)]
        self.dataSource.setValue(with: values)
        refresh()
    }

    func changeMode() {
        switch mode {
        case .multiple:
            mode = .single
        case .single:
            mode = .multiple
        }
    }
}

fileprivate extension LineControl {
    func refresh() {
        setNeedsDisplay()
        self.delegate?.updatePercents(value: self.dataSource.getPercent(mode: self.mode))
    }

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

    func barChartRectangle() -> CGRect {
        let rect = CGRect(x: 0,
                          y: 0,
                          width: bounds.size.width, height: bounds.size.height)
        return rect
    }

    func barChartLegendRectangle() -> CGRect {
        let barchartRect = barChartRectangle()
        let rect = barchartRect.offsetBy(dx: 0.0, dy: -(barchartRect.size.height + Constants.marginSize))
        return rect
    }

    func drawBarGraphInContext(context: CGContext?) {
        let barChartRect = barChartRectangle()
        drawRoundedRect(rect: barChartRect, inContext: context,
                        radius: Constants.barChartCornerRadius,
                        borderColor: UIColor(UIColor.ColorType.notViewed).cgColor,
                        fillColor: UIColor(UIColor.ColorType.notViewed).cgColor)
        let source = dataSource.getData(mode: self.mode)
        var clipRect = barChartRect
        let total = self.dataSource.getTotal(mode: mode)
        for data in source {
            let value = CGFloat(data.value) * barChartRect.width / CGFloat(total)
            let clipWidth = value < barChartRect.width ? value : barChartRect.width
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

