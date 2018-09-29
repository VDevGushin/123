//
//  ColorWheelViewController.swift
//  UIPart
//
//  Created by Vladislav Gushin on 28/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

extension ColorWheelViewController: ColorsWheelDelegate, UICollectionViewDelegate {
    func selection(color: UIColor) {
      //  self.view.backgroundColor = color
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let color = self.dataSource?.models[indexPath.row].color {
            self.colorView.selectColor(color)
        }
    }
}

class ColorWheelViewController: UIViewController {
    @IBOutlet weak var gradient: GradientView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var colorView: ColorsWheel!
    var dataSource: CollectionViewDataSource<ColorInfoModel>?
    let color: UIColor
    var colorScheme: UIColor.ColorScheme

    init(color: UIColor) {
        self.color = color
        self.colorScheme = UIColor.ColorScheme.triad
        let bundle = Bundle(for: type(of: self))
        super.init(nibName: String(describing: ColorWheelViewController.self), bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.colorView.delegate = self
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.delegate = self
        self.collectionView.register(ColorCollectionViewCell.self)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.processColor()
    }

    private func colorsComplete(_ colors: [ColorInfoModel]) {
        self.dataSource = .make(for: colors)
        self.collectionView?.dataSource = dataSource
        self.collectionView?.reloadData()
        if let colors = dataSource?.models.map({ $0.color }) {
            colorView.setColors(colors)
        }
        
        self.gradient.setGradientBackGround(colors: self.dataSource?.models.map({$0.color}))
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
        ]
        let selectPresenter = SelectPresenter(senderView: self.view, actions: actions, message: "Please select color scheme", title: "Scheme", style: .actionSheet)
        selectPresenter.present(in: self)
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
            source += colorScheme.map({ ColorInfoModel(color: $0, info: $0.hexValue()) })
            source.insert(ColorInfoModel(color: wSelf.color, info: "\(scheme) - \(wSelf.color.hexValue())"), at: 0)
            DispatchQueue.main.async {
                wSelf.colorsComplete(source)
            }
        }
    }

    @IBAction func closeView(_ sender: Any) {
        self.removeWithAnimation()
    }
}
