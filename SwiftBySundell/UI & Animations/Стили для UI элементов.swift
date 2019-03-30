//
//  UIViewStyling.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 07/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

// Протокол для проброса замыкания чтобы конфигурировать view
struct ViewStyle<T> {
    let configurate: (T) -> Void
}
extension ViewStyle {
    //для совмещения несколькоих стилей
    func compose(with style: ViewStyle<T>) -> ViewStyle<T> {
        return ViewStyle<T> {
            self.configurate($0)
            style.configurate($0)
        }
    }
}

//=======================

protocol Stylable { init() }

extension Stylable {
    init(style: ViewStyle<Self>) {
        self.init()
        apply(style)
    }
    func apply(_ style: ViewStyle<Self>) {
        style.configurate(self)
    }
}

extension ViewStyle where T: UIButton {

    static var filled: ViewStyle<T> {
        return ViewStyle<T> {
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .red
        }
    }

    static var rounded: ViewStyle<T> {
        return ViewStyle<T> {
            $0.layer.cornerRadius = 4.0
        }
    }

    static func rounded(rad: CGFloat) -> ViewStyle<T> {
        return ViewStyle<T> {
            $0.layer.cornerRadius = rad
        }
    }

    static var roundedAndFilled: ViewStyle<T> {
        return filled.compose(with: rounded)
    }
}

extension ViewStyle where T: UICollectionView {
    static func rounded(rad: CGFloat) -> ViewStyle<T> {
        return ViewStyle<T> {
            $0.layer.cornerRadius = rad
        }
    }
}
//=======================

extension UIView: Stylable { }

func filledAndRoundedButton() {
    let button = UIButton(frame: .zero)
    button.apply(.rounded(rad: 8))



    _ = UIButton(style: .roundedAndFilled)

    let collection = UICollectionView(frame: .zero)
    collection.apply(.rounded(rad: 8))
}
