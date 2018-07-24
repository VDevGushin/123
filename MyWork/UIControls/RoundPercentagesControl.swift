
//
//  RoundPercentagesControl.swift
//  MyWork
//
//  Created by Vladislav Gushin on 24/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import Charts

enum RoundPercentagesControlMode {
    case single
    case multiple
}

class RoundPercentagesSource {
    private let rightAnswer: RoundPercentagesData
    private let needCheck: RoundPercentagesData
    private let incorrectAnswer: RoundPercentagesData
    private let skipped: RoundPercentagesData
    private let notViewed: RoundPercentagesData

    init() {
        self.rightAnswer = RoundPercentagesData(index: 0, color: UIColor(.rightAnswer), title: "Правильный ответ")
        self.needCheck = RoundPercentagesData(index: 1, color: UIColor(.needCheck), title: "Требует проверки")
        self.incorrectAnswer = RoundPercentagesData(index: 2, color: UIColor(.incorrectAnswer), title: "Неправельный ответ")
        self.skipped = RoundPercentagesData(index: 3, color: UIColor(.skipped), title: "Пропущено")
        self.notViewed = RoundPercentagesData(index: 4, color: UIColor(.notViewed), title: "Не просмотренно")
    }

    func setValue(with types: [RoundPercentagesType]) {
        for type in types {
            switch type {
            case .rightAnswer(let value):
                self.rightAnswer.value = value
            case .needCheck(let value):
                self.needCheck.value = value
            case .incorrectAnswer(let value):
                self.incorrectAnswer.value = value
            case .skipped(let value):
                self.skipped.value = value
            case .notViewed(let value):
                self.notViewed.value = value
            }
        }
    }

    func getData(mode: RoundPercentagesControlMode) -> PieChartData {
        let set = PieChartDataSet(values: self.source(mode: mode), label: "")
        set.colors = self.colors(mode: mode)
        set.drawIconsEnabled = false
        set.sliceSpace = 0
        return PieChartData(dataSet: set)
    }

    func getPercent(mode: RoundPercentagesControlMode) -> String {
        let total: Double = self.source(mode: mode).reduce(0) {
            $0 + $1.value
        }
        if total == 0 {
            return "\(total)%"
        }
        let result = Int(100.0 - ((100.0 * self.notViewed.value) / total))
        return "\(result)%"
    }
}

extension RoundPercentagesSource {
    enum RoundPercentagesType {
        case rightAnswer(Double)
        case needCheck(Double)
        case incorrectAnswer(Double)
        case skipped(Double)
        case notViewed(Double)
    }
    class RoundPercentagesData {
        let index: Int
        let color: UIColor
        let title: String
        var value: Double
        init(index: Int, color: UIColor, title: String, value: Double = 0.0) {
            self.index = index
            self.color = color
            self.title = title
            self.value = value
        }
    }
}

fileprivate extension RoundPercentagesSource {
    func colors(mode: RoundPercentagesControlMode) -> [UIColor] {
        let source = getSource(mode: mode)
        return source.map {
            $0.color
        }
    }

    func source(mode: RoundPercentagesControlMode) -> [PieChartDataEntry] {
        let source = getSource(mode: mode)
        var result = [PieChartDataEntry]()
        for i in 0..<source.count {
            result.append(PieChartDataEntry(value: source[i].value, label: source[i].title))
        }
        return result
    }

    func getSource(mode: RoundPercentagesControlMode) -> [RoundPercentagesData] {
        var source = [RoundPercentagesData]()
        switch mode {
        case .multiple:
            source = [self.rightAnswer, self.needCheck, self.incorrectAnswer, self.skipped, self.notViewed]
        case .single:
            source = [self.rightAnswer, self.notViewed]
        }
        return source
    }
}


@IBDesignable
class RoundPercentagesControl: UIView {
    private let xibName = String(describing: RoundPercentagesControl.self)
    @IBOutlet weak var pieChartView: PieChartView!
    let dataSource = RoundPercentagesSource()
    var mode = RoundPercentagesControlMode.multiple {
        didSet {
            self.refresh(pieChartView: self.pieChartView)
        }
    }
    var view: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

fileprivate extension RoundPercentagesControl {
    func setup() {
        self.backgroundColor = UIColor.white
        view = loadFromNib()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        self.setup(pieChartView: self.pieChartView)
    }

    func loadFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.xibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
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


        let values: [RoundPercentagesSource.RoundPercentagesType] =
            [.rightAnswer(0),
                    .needCheck(0),
                    .incorrectAnswer(0),
                    .skipped(0),
                    .notViewed(1)]
        self.dataSource.setValue(with: values)
        refresh(pieChartView: self.pieChartView)
    }

    func refresh(pieChartView chartView: PieChartView) {
        defer { chartView.animate(yAxisDuration: 0.2, easingOption: .easeOutBack) }
        switch self.mode {
        case .multiple:
            chartView.legend.enabled = true
        case .single:
            chartView.legend.enabled = false
        }
        pieChartView.data = dataSource.getData(mode: mode)
        let centerText = NSMutableAttributedString(string: dataSource.getPercent(mode: mode))
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        centerText.setAttributes([.font: UIFont(name: "HelveticaNeue-Light", size: 20)!,
                                         .paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        chartView.centerAttributedText = centerText

        pieChartView.highlightValues(nil)
        for set in pieChartView.data!.dataSets {
            set.drawValuesEnabled = !set.drawValuesEnabled
        }

    }

    @IBAction func changeMode(_ sender: Any) {
        switch mode {
        case .multiple:
            mode = .single
        case .single:
            mode = .multiple
        }
    }

    @IBAction func refresh(_ sender: Any) {
        let values: [RoundPercentagesSource.RoundPercentagesType] =
            [.rightAnswer(Double(arc4random_uniform(100) + 100 / 5)),
                    .needCheck(Double(arc4random_uniform(100) + 100 / 5)),
                    .incorrectAnswer(Double(arc4random_uniform(100) + 100 / 5)),
                    .skipped(Double(arc4random_uniform(100) + 100 / 5)),
                    .notViewed(Double(arc4random_uniform(100) + 100 / 5))]
        self.dataSource.setValue(with: values)
        refresh(pieChartView: self.pieChartView)
    }
}
