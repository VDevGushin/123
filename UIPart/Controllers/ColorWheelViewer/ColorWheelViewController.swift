//
//  ColorWheelViewController.swift
//  UIPart
//
//  Created by Vladislav Gushin on 28/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class ColorWheelViewController: UIViewController, ColorsWheelDelegate {

    func selection(color: UIColor) {
        self.view.backgroundColor = color
    }

    @IBOutlet weak var colorView: ColorsWheel!
    let colors: [UIColor]
    init(colors: [UIColor]) {
        self.colors = colors
        let bundle = Bundle(for: type(of: self))
        super.init(nibName: String(describing: ColorWheelViewController.self), bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.colorView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        colorView.setColors(colors)
    }

    @IBAction func close(_ sender: Any) {
        self.removeWithAnimation()
    }
}
