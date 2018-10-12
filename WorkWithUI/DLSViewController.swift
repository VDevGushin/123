//
//  DLSViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 15/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class DLSViewController: UIViewController {
    @IBOutlet private weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        label.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide

        //standart api
//        NSLayoutConstraint.activate([
//            label.topAnchor.constraint(
//                equalToSystemSpacingBelow: guide.topAnchor,
//                multiplier: 20),
//
//            label.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
//
//            label.widthAnchor.constraint(
//                lessThanOrEqualTo: guide.widthAnchor,
//                constant: 0)]
//        )

        //using proxy
//        let proxy = LayoutProxy(view: label)
//        proxy.top.equal(to: guide.topAnchor, offsetBy: 20)
//        proxy.leading.equal(to: guide.leadingAnchor)
//        proxy.width.equal(to: guide.widthAnchor)

//        //using uivuew extension
        label.layout {
            $0.top.equal(to: guide.topAnchor, offsetBy: 20)
            $0.leading.equal(to: guide.leadingAnchor)
            $0.width.equal(to: guide.widthAnchor)
        }
//
//
//        label.layout {
//            $0.top == guide.topAnchor
//            $0.leading == guide.leadingAnchor
//            $0.width <= guide.widthAnchor
//        }
    }
}
