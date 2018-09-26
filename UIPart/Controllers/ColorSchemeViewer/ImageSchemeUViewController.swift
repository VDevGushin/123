//
//  ImageSchemeUViewController.swift
//  UIPart
//
//  Created by Vladislav Gushin on 26/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate extension TableViewDataSource where Model == ColorInfoModel {
    static func make(for colors: [ColorInfoModel], reuseIdentifier: UITableViewCell.Type = TableViewCell.self) -> Self {
        return self.init(models: colors, reuseIdentifier: reuseIdentifier) { (model, cell) in
            guard let cell = cell as? TableViewCell else { return }
            cell.selectionStyle = .none
            cell.setInfo(model.info)
            cell.setColor(model.color)
        }
    }
}

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
            source.append(ColorInfoModel(color: wSelf.color, info: "\(scheme) - \(wSelf.color.hexValue())"))
            for color in colorScheme {
                source.append(ColorInfoModel(color: color, info: color.hexValue()))
            }
            DispatchQueue.main.async {
                wSelf.colorsComplete(source)
            }
        }
    }

    @IBAction func changeScheme(_ sender: Any) {
        let alert = UIAlertController(title: "Scheme", message: "Please select color scheme", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "complementary", style: .default, handler: { (UIAlertAction)in
            self.colorScheme = .complementary
            self.processColor()
        }))

        alert.addAction(UIAlertAction(title: "monochromatic", style: .default, handler: { (UIAlertAction)in
            self.colorScheme = .monochromatic
            self.processColor()
        }))

        alert.addAction(UIAlertAction(title: "triad", style: .default, handler: { (UIAlertAction)in
            self.colorScheme = .triad
            self.processColor()
        }))

        alert.addAction(UIAlertAction(title: "analagous", style: .default, handler: { (UIAlertAction)in
            self.colorScheme = .analagous
            self.processColor()
        }))

        present(alert, animated: true, completion: nil)
    }

    @IBAction func close(_ sender: Any) {
        self.removeWithAnimation()
    }
}
