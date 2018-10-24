//
//  CalendarViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 22/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
   
    @IBOutlet weak var calendarView: CalendarView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let source: [CalendarModel.CalendarSheduleItem] = [
            ([24, 10, 2018], UIView()),
            ([2018, 10, 25], UIView()),
            ([2018, 10, 26], UIView()),
            ([2018, 10, 27], UIView()),
            ([2018, 10, 28], UIView()),
            ([2018, 10, 29], UIView()),
            ([2018, 10, 30], UIView()),
            ([2018, 10, 31], UIView()),
            ([2018, 11, 1], UIView()),
            ([2018, 11, 2], UIView()),
            ([2018, 11, 3], UIView()),
            ([2018, 11, 4], UIView()),
            ([2018, 11, 5], UIView()),
            ([2018, 11, 6], UIView()),
            ([2018, 11, 7], UIView()),
            ([2018, 11, 8], UIView()),
        ]
        self.calendarView.update(with: source)
    }

    @IBAction func exit(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
