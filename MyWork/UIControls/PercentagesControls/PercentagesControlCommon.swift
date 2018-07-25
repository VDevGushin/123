//
//  PercentagesControlCommon.swift
//  MyWork
//
//  Created by Vladislav Gushin on 25/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
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

    func setValue(with types: Set<RoundPercentagesSource.RoundPercentagesType>) {
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
    enum RoundPercentagesType: Hashable {
        case rightAnswer(Double)
        case needCheck(Double)
        case incorrectAnswer(Double)
        case skipped(Double)
        case notViewed(Double)

        private var hashValueStr: String {
            switch self {
            case .rightAnswer: return "rightAnswer"
            case .needCheck: return "needCheck"
            case .incorrectAnswer: return "incorrectAnswer"
            case .skipped: return "skipped"
            case .notViewed: return "notViewed"
            }
        }

        var hashValue: Int {
            return self.hashValueStr.hash
        }

        static func == (lhs: RoundPercentagesSource.RoundPercentagesType, rhs: RoundPercentagesSource.RoundPercentagesType) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
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
