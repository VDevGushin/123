//
//  OnboardingViewController.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 09/10/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
import paper_onboarding

/**Storyboard

Create a new UIView inheriting from PaperOnboarding

Set dataSource in attribute inspector*/

class OnboardingViewController: CoordinatorViewController, PaperOnboardingDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func openMyOnboardingAction(_ sender: Any) {
        let source = [OnboardingContentModel(color: .red, imageURL: nil, title: nil, subTitle: nil),
            OnboardingContentModel(color: .green, imageURL: nil, title: nil, subTitle: nil),
            OnboardingContentModel(color: .yellow, imageURL: nil, title: nil, subTitle: nil)]

        let oVC = OnboardingRootViewController(with: source)
        oVC.delegate = self
        self.present(oVC, animated: false)
    }

    @IBAction func openPodOnboarding(_ sender: Any) {
        let onboarding = PaperOnboarding()
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        // add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                attribute: attribute,
                relatedBy: .equal,
                toItem: view,
                attribute: attribute,
                multiplier: 1,
                constant: 0)
            view.addConstraint(constraint)
        }
    }

    func onboardingItem(at index: Int) -> OnboardingItemInfo {

        return [OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Key"),
            title: "Hotels",
            description: "All hotels and hostels are sorted by hospitality rating",
            pageIcon: #imageLiteral(resourceName: "Key"),
            color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
            titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: .systemFont(ofSize: 12), descriptionFont: .systemFont(ofSize: 12)),

            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Key"),
                title: "Banks",
                description: "We carefully verify all banks before add them into the app",
                pageIcon: #imageLiteral(resourceName: "Key"),
                color: UIColor(red: 0.40, green: 0.69, blue: 0.71, alpha: 1.00),
                titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: .systemFont(ofSize: 12), descriptionFont: .systemFont(ofSize: 12)),

            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Key"),
                title: "Stores",
                description: "All local stores are categorized for your convenience",
                pageIcon: #imageLiteral(resourceName: "Key"),
                color: UIColor(red: 0.61, green: 0.56, blue: 0.74, alpha: 1.00),
                titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: .systemFont(ofSize: 12), descriptionFont: .systemFont(ofSize: 12)),

        ][index]
    }

    func onboardingItemsCount() -> Int {
        return 3
    }

    func onboardingConfigurationItem(item: OnboardingContentViewItem, index: Int) {
//        item.titleLabel?.backgroundColor = .red()
//        item.descriptionLabel?.backgroundColor = .redColor()
//        item.imageView = ...
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
