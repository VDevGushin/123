//
//  DayViewController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 06/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class DayViewController: StackViewController {
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
