//
//  DayViewController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 06/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class DayViewController: CoordinatorViewController {
    @IBOutlet private weak var scrollView : UIScrollView!
    @IBOutlet private weak var stackView : UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        let today = Date()
        let calendarVC = CalendarDemoViewController(date: today)
        
        add(calendarVC)
        add(SummaryViewController(date: today))
        add(SleepViewController(date: today))
    }
}


extension DayViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        stackView.addArrangedSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove(_ child: UIViewController) {
        guard child.parent != nil else { return }
        child.willMove(toParent: nil)
        stackView.removeArrangedSubview(child.view)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}

