//
//  ColorWheelViewController.swift
//  UIPart
//
//  Created by Vladislav Gushin on 27/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class ColorWheelViewController: UIViewController {
    @IBOutlet weak var color: ColorsWheel!
    let colors: [UIColor]

    init(colors: [UIColor]) {
        self.colors = colors
        let bundle = Bundle(for: type(of: self))
        super.init(nibName: String(describing: ColorWheelViewController.self), bundle: bundle)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.removeWithAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        color.setColors(self.colors)
    }
}
