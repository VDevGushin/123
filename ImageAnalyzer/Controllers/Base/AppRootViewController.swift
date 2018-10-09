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
    let navigator: Coordinator

    init(navigator: Coordinator,
         title: String,
         nibName: String,
         bundle: Bundle) {

        self.viewTitle = title
        self.navigator = navigator
        super.init(nibName: nibName, bundle: bundle)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildUI()
    }

    func buildUI() { fatalError("Not implemented method") }
}
