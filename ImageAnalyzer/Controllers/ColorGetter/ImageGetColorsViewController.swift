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
    @IBOutlet private weak var colorsTableView: UITableView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!

    fileprivate let image: UIImage
    fileprivate let colorGetter: IColorGetter
    fileprivate var dataSource: TableViewDataSource<(ColorInfoModel, ColorInfoModel?)>?
    fileprivate var colors: [ColorInfoModel]?
    fileprivate var isGradientCells = false

    init(navigator: Coordinator, image: UIImage, colorGetter: @autoclosure () -> IColorGetter) {
        self.image = image
        self.colorGetter = colorGetter()
        super.init(navigator: navigator, title: AppText.ImageGetColorsViewController.title.text, nibName: String(describing: ImageGetColorsViewController.self), bundle: Bundle(for: type(of: self)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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

    fileprivate func changeView() {
        self.isGradientCells.toggle()
        self.makeColors(isGradientCells: self.isGradientCells)
    }

    private func colorsComplete(_ colors: [ColorInfoModel]) {
        self.colors = colors
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true
        self.makeColors(isGradientCells: self.isGradientCells)
    }

    private func makeColors(isGradientCells: Bool) {
        guard let colors = self.colors else { return }
        DispatchQueue.global(qos: .userInitiated).async {
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

            DispatchQueue.main.async {
                self.dataSource = .make(for: source)
                self.colorsTableView?.dataSource = self.dataSource
                self.colorsTableView?.reloadData()
            }
        }
    }

    override func buildUI() {
        let button1 = UIBarButtonItem.init(title: "view", style: .done, target: self, action: #selector(changeViewHandler))
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
}

fileprivate extension ImageGetColorsViewController {
    @objc private func changeViewHandler() {
        self.changeView()
    }
}

//MARK: - UITableViewDelegate
extension ImageGetColorsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let color = self.dataSource?.models[indexPath.row].0.color else { return }
        self.navigator.navigate(to: .imageColorsScheme(colors: color))
    }
}
