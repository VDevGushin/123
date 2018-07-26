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
//Статические типы данных
class PercentagesSource {
    fileprivate var rightAnswer: PercentagesData
    fileprivate var needCheck: PercentagesData
    fileprivate var incorrectAnswer: PercentagesData
    fileprivate var skipped: PercentagesData
    fileprivate var notViewed: PercentagesData
    fileprivate var baseColor: UIColor
    init(baseColor: UIColor = UIColor(.rightAnswer)) {
        self.baseColor = baseColor
        self.rightAnswer = PercentagesData(index: 0, color: baseColor, title: PercentagesTypeTitle.rightAnswer.value)
        self.needCheck = PercentagesData(index: 1, color: UIColor(.needCheck), title: PercentagesTypeTitle.needCheck.value)
        self.incorrectAnswer = PercentagesData(index: 2, color: UIColor(.incorrectAnswer), title: PercentagesTypeTitle.incorrectAnswer.value)
        self.skipped = PercentagesData(index: 3, color: UIColor(.skipped), title: PercentagesTypeTitle.skipped.value)
        self.notViewed = PercentagesData(index: 4, color: UIColor(.notViewed), title: PercentagesTypeTitle.notViewed.value)
    }

    func setValue(with types: Set<PercentagesSource.PercentagesType>) {
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
    enum PercentagesTypeTitle: String {
        case rightAnswer = "Правильный ответ"
        case needCheck = "Требует проверки"
        case incorrectAnswer = "Неправельный ответ"
        case skipped = "Пропущено"
        case notViewed = "Не просмотренно"
        var value: String {
            return self.rawValue
        }
    }

    enum PercentagesType: Hashable {
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

        static func == (lhs: PercentagesSource.PercentagesType, rhs: PercentagesSource.PercentagesType) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
    }

    class PercentagesData {
        let index: Int
        var color: UIColor
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
        self.setColors(mode: mode)
        source = [self.rightAnswer, self.needCheck, self.incorrectAnswer, self.skipped, self.notViewed]
        return source
    }

    func colors(mode: RoundPercentagesControlMode) -> [UIColor] {
        let source = getSource(mode: mode)
        return source.map {
            $0.color
        }
    }

    func setColors(mode: RoundPercentagesControlMode) {
        switch mode {
        case .multiple:
            self.rightAnswer.color = UIColor(.rightAnswer)
            self.needCheck.color = UIColor(.needCheck)
            self.incorrectAnswer.color = UIColor(.incorrectAnswer)
            self.skipped.color = UIColor(.skipped)
            self.notViewed.color = UIColor(.notViewed)
        case .single:
            self.rightAnswer.color = self.baseColor
            self.needCheck.color = self.rightAnswer.color
            self.incorrectAnswer.color = self.rightAnswer.color
            self.skipped.color = self.rightAnswer.color }
    }
}

//MARK: - Round control
//Класс для работы с контролом - круглый пай
class RoundPercentagesSource: PercentagesSource {
    func getData(mode: RoundPercentagesControlMode) -> PieChartData {
        let set = PieChartDataSet(values: self.source(mode: mode), label: "")
        set.colors = self.colors(mode: mode)
        set.drawIconsEnabled = false
        set.sliceSpace = 0
        return PieChartData(dataSet: set)
    }

    private func source(mode: RoundPercentagesControlMode) -> [PieChartDataEntry] {
        let source = getSource(mode: mode)
        var result = [PieChartDataEntry]()
        for i in 0..<source.count {
            result.append(PieChartDataEntry(value: Double(source[i].value), label: source[i].title))
        }
        return result
    }
}

//MARK: - Line control
//Класс для работы с контролом - цветная прямая линия
class LinePercentagesSource: PercentagesSource {
    override init(baseColor: UIColor = UIColor(.rightAnswer)) {
        super.init(baseColor: baseColor)
        self.clearAll()
    }


    convenience init(with source: Set<PercentagesSource.PercentagesType>,
                     baseColor: UIColor = UIColor(.rightAnswer)) {
        self.init(baseColor: baseColor)
        self.setValue(with: source)
    }

    func clearAll() {
        self.rightAnswer = PercentagesData(index: 0, color: baseColor, title: PercentagesTypeTitle.rightAnswer.value, value: 0)
        self.needCheck = PercentagesData(index: 1, color: UIColor(.needCheck), title: PercentagesTypeTitle.needCheck.value, value: 0)
        self.incorrectAnswer = PercentagesData(index: 2, color: UIColor(.incorrectAnswer), title: PercentagesTypeTitle.incorrectAnswer.value, value: 0)
        self.skipped = PercentagesData(index: 3, color: UIColor(.skipped), title: PercentagesTypeTitle.skipped.value, value: 0)
        self.notViewed = PercentagesData(index: 4, color: UIColor(.notViewed), title: PercentagesTypeTitle.notViewed.value, value: 1)
    }

    func getSet() -> Set<PercentagesSource.PercentagesType> {
        return [PercentagesSource.PercentagesType.rightAnswer(self.rightAnswer.value),
            PercentagesSource.PercentagesType.needCheck(self.needCheck.value),
            PercentagesSource.PercentagesType.incorrectAnswer(self.incorrectAnswer.value),
            PercentagesSource.PercentagesType.skipped(self.skipped.value),
            PercentagesSource.PercentagesType.notViewed(self.notViewed.value)]
    }

    func setStyle(with color: UIColor) {
        self.baseColor = color
    }

    func count(mode: RoundPercentagesControlMode) -> Int {
        return getSource(mode: mode).count
    }

    func getData(mode: RoundPercentagesControlMode) -> [PercentagesData] {
        return getSource(mode: mode)
    }
}

extension LinePercentagesSource {
    enum Variant {
        case value(Int)
        var value: String {
            switch self {
            case .value(let number):
                return "Вариант \(number)"
            }
        }
    }
}
