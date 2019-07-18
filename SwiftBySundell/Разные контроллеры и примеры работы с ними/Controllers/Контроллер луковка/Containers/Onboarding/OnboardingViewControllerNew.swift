//
//  OnboardingViewController.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 18/07/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

protocol OnboardingViewControllerDatasource {
    var supportingViews: [UIView] { get }
}

final class OnboardingViewControllerNew: UIViewController, Storyboardable, ViewSpecificController {
    typealias RootView = OnboardingView

    var supportingViews: [UIView] = [] {
        didSet {
            for view in supportingViews {
                self.view().stackView.addArrangedSubview(view)
            }
        }
    }

    public func embedController(_ controller: UIViewController, actionsDatasource: OnboardingViewControllerDatasource) {

        self.insertFullframeChildController(controller,
            toView: self.view().contentContainerView,
            index: 0)

        //add subviews to stack
        self.supportingViews = actionsDatasource.supportingViews
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let buttonsDatasource = segue.destination as? OnboardingViewControllerDatasource {
            self.supportingViews = buttonsDatasource.supportingViews
        }
    }
}
