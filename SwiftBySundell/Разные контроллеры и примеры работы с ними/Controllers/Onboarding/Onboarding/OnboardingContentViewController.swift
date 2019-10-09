//
//  OnboardingContentViewViewController.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 09.10.2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class OnboardingContentViewController: UIViewController {
    private let model: OnboardingContentModel
    let pageIndex: Int

    init(with model: OnboardingContentModel, pageIndex: Int) {
        self.model = model
        self.pageIndex = pageIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupNextButton(with title: String, action: () -> Void) {
        print(#function)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = model.color ?? .white
    }
}
