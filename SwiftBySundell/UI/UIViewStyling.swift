//
//  UIViewStyling.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 07/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

// MARK: - The filled and rounded button

func filledAndRoundedButton1() {
    let filledButtonStyle: (UIButton) -> Void = {
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .red
    }

    let button = UIButton(frame: .zero)
    button.setTitle("My button", for: .normal)
    filledButtonStyle(button)
}

struct ViewStyle<T> {
    let makeStyle: (T) -> Void
}

extension ViewStyle {
    func compose(with style: ViewStyle<T>) -> ViewStyle<T> {
        return ViewStyle<T> {
            self.makeStyle($0)
            style.makeStyle($0)
        }
    }
}

func filledAndRoundedButton2() {
    let filled = ViewStyle<UIButton> {
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .red
    }

    let rounded = ViewStyle<UIButton> {
        $0.layer.cornerRadius = 4.0
    }

    let button = UIButton(frame: .zero)
    filled.makeStyle(button)
    rounded.makeStyle(button)

    let roundedAndFilled = filled.compose(with: rounded)
    roundedAndFilled.makeStyle(button)
}

// MARK: - Improvements
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

func filledAndRoundedButton3() {
    func style<T>(_ object: T, with style: ViewStyle<T>) {
        style.makeStyle(object)
    }

    let button = UIButton(frame: .zero)
    ViewStyle<UIButton>.roundedAndFilled.makeStyle(button)

    style(button, with: .roundedAndFilled)
}

// MARK: - Protocols to the rescue

protocol Stylable {
    init()
}

extension Stylable {
    init(style: ViewStyle<Self>) {
        self.init()
        apply(style)
    }

    func apply(_ style: ViewStyle<Self>) {
        style.makeStyle(self)
    }
}

extension UIView: Stylable { }

func filledAndRoundedButton4() {
    let button = UIButton(frame: .zero)
    button.apply(.roundedAndFilled)

    _ = ViewStyle<UILabel> {
        $0.textAlignment = .center
    }

    _ = UIButton(style: .roundedAndFilled)
}
