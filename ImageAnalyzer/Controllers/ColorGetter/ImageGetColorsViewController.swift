//
//  ImageGetColorsViewController.swift
//  ImageAnalyzer
//
//  Created by Vladislav Gushin on 30/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

public extension TableViewDataSource where Model == ColorInfoModel {
    static func make(for colors: [ColorInfoModel], reuseIdentifier: UITableViewCell.Type = ColorTableViewCell.self) -> Self {
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
    var dataSource: TableViewDataSource<ColorInfoModel>?
    
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
        self.colorsTableView.backgroundColor = UIColor.clear
        self.colorsTableView.register(ColorTableViewCell.self)
        self.colorsTableView.separatorStyle = .none
        self.colorsTableView.rowHeight = 100
        self.colorsTableView.showsHorizontalScrollIndicator = false
        self.colorsTableView.showsVerticalScrollIndicator = false
        self.colorsTableView.delegate = self
        self.loadingIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.colorGetter.process(image) { [weak self] result in
            self?.colorsComplete(result)
        }
    }
    
    private func colorsComplete(_ colors: [ColorInfoModel]) {
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true
        self.dataSource = .make(for: colors)
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
