//
//  ColorGetters.swift
//  UIPart
//
//  Created by Vladislav Gushin on 26/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

//MARK: - Simple color getter
final class SimpleImageGetter: IColorGetter {
    var isInWork: Bool = false
    func cancel() {
        isInWork.toggle()
    }

    func process(_ image: UIImage, completion: @escaping ([ColorInfoModel]) -> Void) {
        isInWork = true
        DispatchQueue.global(qos: .utility).async {
            let colors = image.getColors()
            DispatchQueue.main.async {
                let c1 = ColorInfoModel(color: colors.background, info: "Background")
                let c2 = ColorInfoModel(color: colors.detail, info: "Detail")
                let c3 = ColorInfoModel(color: colors.primary, info: "Primary")
                let c4 = ColorInfoModel(color: colors.secondary, info: "Secondary")
                completion([c1, c2, c3, c4])
            }
        }
    }
}

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
            let colors = NSDictionary.mainColours(in: image, detail: Int32(wSelf.detail.rawValue))
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
            let colors = ColorsFromImage(image, withFlatScheme: false)
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
