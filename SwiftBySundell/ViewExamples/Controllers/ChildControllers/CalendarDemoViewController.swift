//
//  CalendarDemoViewController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 06/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class CalendarDemoViewController: UIViewController {

    @IBOutlet private weak var dayLable: UILabel!
    private let date: Date

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dayLable.text = self.date.debugDescription
    }

    init(date: Date) {
        self.date = date
        super.init(nibName: "CalendarDemoViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
