
//
//  RoundPercentagesControl.swift
//  MyWork
//
//  Created by Vladislav Gushin on 24/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import Charts

@IBDesignable
class RoundPercentagesControl: UIView {
    private let xibName = String(describing: RoundPercentagesControl.self)
    private let dataSource = RoundPercentagesSource()
    var pieChartView: PieChartView!

    fileprivate var mode = RoundPercentagesControlMode.single {
        didSet {
            self.refresh(pieChartView: self.pieChartView)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        pieChartView.layoutSubviews()
        pieChartView.updateConstraints()
    }
}

extension RoundPercentagesControl {
    func update(with source: Set<RoundPercentagesSource.PercentagesType>) {
        self.dataSource.setValue(with: source)
        refresh(pieChartView: self.pieChartView)
    }

    func clear(with animation: Bool = false) {
        defer { if animation { self.pieChartView.animate(yAxisDuration: 1.4, easingOption: .easeOutBack) } }
        let values: Set<RoundPercentagesSource.PercentagesType> = [.rightAnswer(0), .needCheck(0), .incorrectAnswer(0), .skipped(0), .notViewed(1)]
        self.dataSource.setValue(with: values)
        refresh(pieChartView: self.pieChartView)
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

fileprivate extension RoundPercentagesControl {
    func setup() {
        self.pieChartView = loadFromNib()
        self.pieChartView.frame = bounds
        self.pieChartView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(pieChartView)
        self.setup(pieChartView: self.pieChartView)
    }

    func loadFromNib() -> PieChartView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.xibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? PieChartView
        return view
    }

    func setup(pieChartView chartView: PieChartView) {
        chartView.drawEntryLabelsEnabled = false
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.85
        chartView.transparentCircleRadiusPercent = 0.0
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 5, top: 5, right: 5, bottom: 5)
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = false
        chartView.drawCenterTextEnabled = true
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        let legend = chartView.legend
        legend.enabled = true
        legend.form = .circle
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .center
        legend.orientation = .vertical
        legend.xEntrySpace = 0
        legend.yEntrySpace = 10
        legend.yOffset = 0
        chartView.noDataText = "О%"
        self.clear()
        self.pieChartView.updateConstraints()
    }

    func refresh(pieChartView chartView: PieChartView) {
        switch self.mode {
        case .multiple:
            chartView.legend.enabled = true
        case .single:
            chartView.legend.enabled = false
        }
        let centerText = NSMutableAttributedString(string: dataSource.getPercent(mode: mode))
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        centerText.setAttributes(
            [.font: UIFont(name: "HelveticaNeue-Light", size: 20)!,
                                             .paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        chartView.centerAttributedText = centerText
        pieChartView.data = dataSource.getData(mode: mode)
        pieChartView.highlightValues(nil)
        for set in pieChartView.data!.dataSets {
            set.drawValuesEnabled = !set.drawValuesEnabled
        }
    }
}
