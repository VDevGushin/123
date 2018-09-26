//
//  ColorGetters.swift
//  UIPart
//
//  Created by Vladislav Gushin on 26/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

//MARK: - Percentage color getter
final class ColorPercentageGetter: IColorGetter {
    enum Detail: Int {
        case low = 0
        case standart = 1
        case high = 2
    }

    var isInWork: Bool = false
    var detail: Detail

    init(with details: Detail = .standart) {
        self.detail = details
    }

    func cancel() {
        isInWork.toggle()
    }

    func process(_ image: UIImage, completion: @escaping ([ColorInfoModel]) -> Void) {
        isInWork = true
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let wSelf = self else { return }
            if !wSelf.isInWork { return }
            let colors = NSDictionary.mainColors(in: image, detail: Int32(wSelf.detail.rawValue))
            guard let colorsUnwrap = colors else { return }
            var source = [ColorInfoModel]()
            let total = colorsUnwrap.reduce(0) { result, next in
                return result + (next.value as! Double)
            }
            for (color, persentage) in colorsUnwrap {
                let percent = (persentage as! Double) * 100 / total
                source.append(ColorInfoModel(color: color as! UIColor, info: "\(percent.rounded(toPlaces: 2))%"))
            }
            DispatchQueue.main.async {
                if !wSelf.isInWork { return }
                completion(source)
            }
        }
    }
}

//MARK: - Chameleon color getter
final class ChameleonImageGetter: IColorGetter {
    var isInWork: Bool = false
    func cancel() {
        isInWork.toggle()
    }

    func process(_ image: UIImage, completion: @escaping ([ColorInfoModel]) -> Void) {
        isInWork = true
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let wSelf = self else { return }
            if !wSelf.isInWork { return }
            let colors = ColorsFromImage(image, withFlatScheme: true)
            var source = [ColorInfoModel]()
            for color in colors {
                source.append(ColorInfoModel(color: color, info: color.hexValue()))
            }
            DispatchQueue.main.async {
                if !wSelf.isInWork { return }
                completion(source)
            }
        }
    }
}

//MARK: - Avarage color
final class AvarageColorImageGetter: IColorGetter {
    var isInWork: Bool = false
    func cancel() {
        isInWork.toggle()
    }

    func process(_ image: UIImage, completion: @escaping ([ColorInfoModel]) -> Void) {
        isInWork = true
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let wSelf = self else { return }
            if !wSelf.isInWork { return }
            let color = AverageColorFromImage(image)
            let source = [ColorInfoModel(color: color, info: color.hexValue())]
            DispatchQueue.main.async {
                if !wSelf.isInWork { return }
                completion(source)
            }
        }
    }
}

//MARK: - Most procentage color
final class AverageColorSupportPercentageGetter: IColorGetter {
    enum Detail: Int {
        case low = 0
        case standart = 1
        case high = 2
    }

    var isInWork: Bool = false
    var detail: Detail

    init(with details: Detail = .standart) {
        self.detail = details
    }

    func cancel() {
        isInWork.toggle()
    }

    func process(_ image: UIImage, completion: @escaping ([ColorInfoModel]) -> Void) {
        isInWork = true
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let wSelf = self else { return }
            if !wSelf.isInWork { return }
            var source = [ColorInfoModel]()
            let averageColor = AverageColorFromImage(image)
            source.append(ColorInfoModel(color: averageColor, info: averageColor.hexString()))

            DispatchQueue.main.async {
                if !wSelf.isInWork { return }
                completion(source)
            }
        }
    }
}
