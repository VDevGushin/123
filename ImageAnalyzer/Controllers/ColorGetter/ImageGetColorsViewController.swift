//
//  ImageGetColorsViewController.swift
//  ImageAnalyzer
//
//  Created by Vladislav Gushin on 30/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

public extension TableViewDataSource where Model == (ColorInfoModel, ColorInfoModel?) {
    static func make(for colors: [(ColorInfoModel, ColorInfoModel?)], reuseIdentifier: UITableViewCell.Type = ColorTableViewCell.self) -> Self {
        return self.init(models: colors, reuseIdentifier: reuseIdentifier) { (model, cell) in
            guard let cell = cell as? ColorTableViewCell else { return }
            cell.selectionStyle = .none
            cell.setColor(with: model)
        }
    }
}

class ImageGetColorsViewController: AppRootViewController {
    @IBOutlet weak var colorsTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    let image: UIImage
    let colorGetter: IColorGetter
    var dataSource: TableViewDataSource<(ColorInfoModel, ColorInfoModel?)>?
    var colors: [ColorInfoModel]?
    private var isGradientCells = false

    init(image: UIImage, colorGetter: @autoclosure () -> IColorGetter) {
        self.image = image
        self.colorGetter = colorGetter()
        let bundle = Bundle(for: type(of: self))
        super.init(title: "Image colors", nibName: String(describing: ImageGetColorsViewController.self), bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let button1 = UIBarButtonItem.init(title: "view", style: .done, target: self,
                                           action: #selector(changeView))
        self.navigationItem.rightBarButtonItems = [button1]
        self.colorsTableView.backgroundColor = UIColor.clear
        self.colorsTableView.register(ColorTableViewCell.self)
        self.colorsTableView.separatorStyle = .none
        self.colorsTableView.rowHeight = 100
        self.colorsTableView.showsHorizontalScrollIndicator = false
        self.colorsTableView.showsVerticalScrollIndicator = false
        self.colorsTableView.delegate = self
        self.loadingIndicator.startAnimating()
    }

    @objc func changeView() {
        self.isGradientCells.toggle()
        self.makeColors(isGradientCells: self.isGradientCells)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.colorGetter.process(image) { [weak self] result in
            self?.colorsComplete(result)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.colorGetter.cancel()
    }

    private func colorsComplete(_ colors: [ColorInfoModel]) {
        self.colors = colors
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true
        self.makeColors(isGradientCells: self.isGradientCells)
    }

    private func makeColors(isGradientCells: Bool) {
        guard let colors = self.colors else { return }
        var source = [(ColorInfoModel, ColorInfoModel?)]()
        if isGradientCells {
            for i in 0..<colors.count {
                let color1 = colors[i]
                var color2: ColorInfoModel? = nil
                if i < colors.count - 1 {
                    color2 = colors[i + 1]
                }
                source.append((color1, color2))
            }
        } else {
            for i in 0..<colors.count {
                let color1 = colors[i]
                source.append((color1, nil))
            }
        }
        self.dataSource = .make(for: source)
        self.colorsTableView?.dataSource = dataSource
        self.colorsTableView?.reloadData()
    }
}

extension ImageGetColorsViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let color = self.dataSource?.models[indexPath.row].color {
//            let schemeVC = ColorWheelViewController(color: color)
//            self.add(schemeVC)
//        }
//    }
}
