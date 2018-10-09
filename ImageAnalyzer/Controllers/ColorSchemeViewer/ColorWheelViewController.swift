//
//  ColorWheelViewController.swift
//  ImageAnalyzer
//
//  Created by Vladislav Gushin on 09/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

class ColorWheelViewController: AppRootViewController {
//    @IBOutlet private weak var colorsWheel: ColorsWheel!
    @IBOutlet weak var colorsWheel: ColorsWheel!
    let color: UIColor
    var colorScheme: UIColor.ColorScheme

    init(navigator: Coordinator, color: UIColor) {
        self.color = color
        self.colorScheme = UIColor.ColorScheme.triad
        super.init(navigator: navigator, title: AppText.ImageGetColorsViewController.title.text, nibName: String(describing: ColorWheelViewController.self), bundle: Bundle(for: type(of: self)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.colorsWheel.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.processColor()
    }

    override func buildUI() {
        let button1 = UIBarButtonItem.init(title: "view", style: .done, target: self, action: #selector(changeSchemeHandler))
        self.navigationItem.rightBarButtonItems = [button1]
    }

    @objc private func changeSchemeHandler(_ sender: Any) {
        let actions = [
            ("Triad",
             { self.colorScheme = .triad
                 self.processColor() }),
            ("Analagous",
             { self.colorScheme = .analagous
                 self.processColor() }),
            ("Complementary",
             { self.colorScheme = .complementary
                 self.processColor() }),
            ("Monochromatic",
             { self.colorScheme = .monochromatic
                 self.processColor() }),
        ]
        let selectPresenter = SelectionPresenter(senderView: self.view, actions: actions, message: "Please select color scheme", title: "Scheme", style: .actionSheet)
        selectPresenter.present(in: self)
    }

}

extension ColorWheelViewController: ColorsWheelDelegate {
    func selection(color: UIColor) {
        //  self.view.backgroundColor = color
    }
}

fileprivate extension ColorWheelViewController {
    func processColor() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let wSelf = self else { return }
            var source = [ColorInfoModel]()
            let colorScheme = wSelf.color.colorScheme(wSelf.colorScheme)
            var scheme = ""
            switch wSelf.colorScheme {
            case .analagous:
                scheme = "analagous"
            case .complementary:
                scheme = "complementary"
            case .monochromatic:
                scheme = "monochromatic"
            case .triad:
                scheme = "triad"
            }
            source += colorScheme.map({ ColorInfoModel(color: $0, info: $0.hexValue()) })
            source.insert(ColorInfoModel(color: wSelf.color, info: "\(scheme) - \(wSelf.color.hexValue())"), at: 0)
            DispatchQueue.main.async {
                wSelf.colorsComplete(source)
            }
        }
    }

    private func colorsComplete(_ colors: [ColorInfoModel]) {
        let colors = colors.map({ $0.color })
        self.colorsWheel.setColors(colors)
    }
}
