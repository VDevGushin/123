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

//=======================

extension ViewStyle where T: UIButton {
    static var filled: ViewStyle<UIButton> {
        return ViewStyle<UIButton> {
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .red
        }
    }

    static var rounded: ViewStyle<UIButton> {
        return ViewStyle<UIButton> {
            $0.layer.cornerRadius = 4.0
        }
    }
    
    static var roundedAndFilled: ViewStyle<UIButton> {
        return filled.compose(with: rounded)
    }
}

//=======================

extension UIView: Stylable { }

func filledAndRoundedButton() {
    let button = UIButton(frame: .zero)
    button.apply(.roundedAndFilled)
    _ = UIButton(style: .roundedAndFilled)
}
