//
//  ImageSchemeUViewController.swift
//  UIPart
//
//  Created by Vladislav Gushin on 26/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class ImageSchemeUViewController: UIViewController {
    @IBOutlet weak var colorsTableView: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    let color: UIColor
    var colorScheme: UIColor.ColorScheme

    var dataSource: TableViewDataSource<ColorInfoModel>?

    init(color: UIColor) {
        self.color = color
        self.colorScheme = UIColor.ColorScheme.triad
        let bundle = Bundle(for: type(of: self))
        super.init(nibName: String(describing: ImageSchemeUViewController.self), bundle: bundle)
    }

    private func colorsComplete(_ colors: [ColorInfoModel]) {
        self.dataSource = .make(for: colors)
        self.colorsTableView?.dataSource = dataSource
        self.colorsTableView?.reloadData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.colorsTableView.backgroundColor = UIColor.clear
        self.colorsTableView.register(TableViewCell.self)
        self.colorsTableView.separatorStyle = .none
        self.colorsTableView.rowHeight = 100
        self.colorsTableView.delegate = self
        self.colorsTableView.showsHorizontalScrollIndicator = false
        self.colorsTableView.showsVerticalScrollIndicator = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.processColor()
    }

    private func processColor() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
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

            for color in colorScheme {
                source.append(ColorInfoModel(color: color, info: color.hexValue()))
            }
            source.insert(ColorInfoModel(color: wSelf.color, info: "\(scheme) - \(wSelf.color.hexValue())"), at: 0)
            DispatchQueue.main.async {
                wSelf.colorsComplete(source)
            }
        }
    }

    @IBAction func changeScheme(_ sender: Any) {
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
            ("Show color wheel",
             {
                 if let colors = self.dataSource?.models.map({ $0.color }) {
                     let schemeVC = ColorWheelViewController(colors: colors)
                     self.add(schemeVC)
                 }
             }),

        ]
        let selectPresenter = SelectPresenter(senderView: self.view, actions: actions, message: "Please select color scheme", title: "Scheme", style: .actionSheet)
        selectPresenter.present(in: self)
    }

    @IBAction func close(_ sender: Any) {
        self.removeWithAnimation()
    }
}

extension ImageSchemeUViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}
