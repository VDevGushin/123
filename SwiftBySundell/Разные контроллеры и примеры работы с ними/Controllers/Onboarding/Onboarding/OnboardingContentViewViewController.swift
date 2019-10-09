//
//  OnboardingContentViewViewController.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 09.10.2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class OnboardingContentViewViewController: UIViewController {
    private let model: OnboardingContentModel
    var pageIndex: Int

    init(with model: OnboardingContentModel) {
        self.model = model
        self.pageIndex = model.index
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = model.color!
    }
}
