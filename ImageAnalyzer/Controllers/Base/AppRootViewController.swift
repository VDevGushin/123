//
//  AppRootViewController.swift
//  ImageAnalyzer
//
//  Created by Vladislav Gushin on 30/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class AppRootViewController: UIViewController {
    let viewTitle: String

    init(title: String, nibName: String, bundle: Bundle) {
        self.viewTitle = title
        super.init(nibName: nibName, bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let navBar = self.navigationController?.navigationBar {
            navBar.layer.backgroundColor = UIColor.white.cgColor
            self.navigationItem.title = viewTitle
        }
        self.buildUI()
    }
    
    func buildUI() {}
}
