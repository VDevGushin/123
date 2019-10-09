//
//  OnboardingViewController.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 09/10/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class OnboardingViewController: CoordinatorViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            let source = [OnboardingContentModel(color: .red, imageURL: nil, title: nil, subTitle: nil),
                OnboardingContentModel(color: .green, imageURL: nil, title: nil, subTitle: nil),
                OnboardingContentModel(color: .yellow, imageURL: nil, title: nil, subTitle: nil)]

            let oVC = OnboardingRootViewController(with: source)
            oVC.delegate = self
            self.present(oVC, animated: false)
        }
    }
}

extension OnboardingViewController: OnboardingRootViewControllerDelegate {
    func alertOnboardingSkipped(_ currentStep: Int, maxStep: Int) {
        print("Skip step \(currentStep), maxStep \(maxStep)")
    }

    func alertOnboardingCompleted() {
        print("Complete")
    }

    func alertOnboardingNext(_ nextStep: Int) {
        print("Next step \(nextStep)")
    }
}
