//
//  ImageColorViewController.swift
//  UIPart
//
//  Created by Vladislav Gushin on 25/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class ImageColorViewController: UIViewController {
    deinit {
        print("Deinit ImageColorViewController")
    }
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var colorsTableView: UITableView!
    let image: UIImage
    let colorGetter: IColorGetter
    var dataSource: TableViewDataSource<ColorInfoModel>?

    private func colorsComplete(_ colors: [ColorInfoModel]) {
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true
        self.dataSource = .make(for: colors)
        self.colorsTableView?.dataSource = dataSource
        self.colorsTableView?.reloadData()
    }

    init(image: UIImage, colorGetter: @autoclosure () -> IColorGetter) {
        self.image = image
        self.colorGetter = colorGetter()
        let bundle = Bundle(for: type(of: self))
        super.init(nibName: String(describing: ImageColorViewController.self), bundle: bundle)
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
        self.colorsTableView.delegate = self
        self.loadingIndicator.startAnimating()
    }

    @IBAction func closeColors(_ sender: Any) {
        self.colorGetter.cancel()
        self.removeWithAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.colorGetter.process(image) { [weak self] result in
            self?.colorsComplete(result)
        }
    }
}

extension ImageColorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let color = self.dataSource?.models[indexPath.row].color {
            let schemeVC = ColorWheelViewController(color: color)
            self.add(schemeVC)
        }
    }
}
