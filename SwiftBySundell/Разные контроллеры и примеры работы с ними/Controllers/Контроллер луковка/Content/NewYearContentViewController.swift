//
//  NewYearContentViewController.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 18/07/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class NewYearContentViewController: UIViewController, ViewSpecificController, Storyboardable {
    typealias RootView = NewYearContentView
    
    override func loadView() {
        super.loadView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @IBAction func doneButtonDidPress(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension NewYearContentViewController: OnboardingViewControllerDatasource {
    var supportingViews: [UIView] {
        return [view().doneButton]
    }
}
