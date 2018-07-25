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
//MARK: - Base
class PercentagesSource {
    fileprivate var rightAnswer: PercentagesData
    fileprivate var needCheck: PercentagesData
    fileprivate var incorrectAnswer: PercentagesData
    fileprivate var skipped: PercentagesData
    fileprivate var notViewed: PercentagesData

    init() {
        self.rightAnswer = PercentagesData(index: 0, color: UIColor(.rightAnswer), title: "Правильный ответ")
        self.needCheck = PercentagesData(index: 1, color: UIColor(.needCheck), title: "Требует проверки")
        self.incorrectAnswer = PercentagesData(index: 2, color: UIColor(.incorrectAnswer), title: "Неправельный ответ")
        self.skipped = PercentagesData(index: 3, color: UIColor(.skipped), title: "Пропущено")
        self.notViewed = PercentagesData(index: 4, color: UIColor(.notViewed), title: "Не просмотренно")
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
    
    func getPercent(mode: RoundPercentagesControlMode) -> String {
        let total = getTotal(mode: mode)
        if total == 0 {
            return "\(total)%"
        }
        let result = 100 - (100 * self.notViewed.value / total)
        return "\(result)%"
    }
    
    func getTotal(mode: RoundPercentagesControlMode) -> Int {
        return self.getSource(mode: mode).reduce(0) {
            $0 + $1.value
        }
    }
}

extension PercentagesSource {
    enum RoundPercentagesType: Hashable {
        case rightAnswer(Int)
        case needCheck(Int)
        case incorrectAnswer(Int)
        case skipped(Int)
        case notViewed(Int)

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

    class PercentagesData {
        let index: Int
        let color: UIColor
        let title: String
        var value: Int
        init(index: Int, color: UIColor, title: String, value: Int = 0) {
            switch value {
            case 0 ... 100:
                self.index = index
                self.color = color
                self.title = title
                self.value = value
            default:
                fatalError("out of range")
            }
        }
    }
}

fileprivate extension PercentagesSource {
    func getSource(mode: RoundPercentagesControlMode) -> [PercentagesData] {
        var source = [PercentagesData]()
        switch mode {
        case .multiple:
            source = [self.rightAnswer, self.needCheck, self.incorrectAnswer, self.skipped, self.notViewed]
        case .single:
            source = [self.rightAnswer, self.notViewed]
        }
        return source
    }

    func colors(mode: RoundPercentagesControlMode) -> [UIColor] {
        let source = getSource(mode: mode)
        return source.map {
            $0.color
        }
    }
}

//MARK: - Round control
class RoundPercentagesSource: PercentagesSource {
    func getData(mode: RoundPercentagesControlMode) -> PieChartData {
        let set = PieChartDataSet(values: self.source(mode: mode), label: "")
        set.colors = self.colors(mode: mode)
        set.drawIconsEnabled = false
        set.sliceSpace = 0
        return PieChartData(dataSet: set)
    }
}

fileprivate extension RoundPercentagesSource {
    func source(mode: RoundPercentagesControlMode) -> [PieChartDataEntry] {
        let source = getSource(mode: mode)
        var result = [PieChartDataEntry]()
        for i in 0..<source.count {
            result.append(PieChartDataEntry(value: Double(source[i].value), label: source[i].title))
        }
        return result
    }
}

//MARK: - Line control
class LinePercentagesSource: PercentagesSource {
    override init() {
        super.init()
        self.rightAnswer = PercentagesData(index: 0, color: UIColor(.rightAnswer), title: "Правильный ответ", value: 0)
        self.needCheck = PercentagesData(index: 1, color: UIColor(.needCheck), title: "Требует проверки", value: 0)
        self.incorrectAnswer = PercentagesData(index: 2, color: UIColor(.incorrectAnswer), title: "Неправельный ответ", value: 0)
        self.skipped = PercentagesData(index: 3, color: UIColor(.skipped), title: "Пропущено", value: 0)
        self.notViewed = PercentagesData(index: 4, color: UIColor(.notViewed), title: "Не просмотренно", value: 1)
    }

    func count(mode: RoundPercentagesControlMode) -> Int {
        return getSource(mode: mode).count
    }

    func getData(mode: RoundPercentagesControlMode) -> [PercentagesData] {
        return getSource(mode: mode)
    }
}
