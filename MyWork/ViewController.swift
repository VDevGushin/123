//
//  ViewController.swift
//  MyWork
//
//  Created by Vladislav Gushin on 06/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var vcContaiter: UIView!
    @IBOutlet weak var rpC: RoundPercentagesControl!
    
    private var roundStatistic: RoundPercentageViewController? {
        guard let vc = childViewControllers.first as? RoundPercentageViewController else {
            return nil
        }
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func clear(_ sender: Any) {
        roundStatistic?.clear(with: true)
        rpC.clear(with: true)
    }

    @IBAction func changeMode(_ sender: Any) {
        roundStatistic?.changeMode()
        rpC.changeMode()
    }
    @IBAction func updateStatistic(_ sender: Any) {
        let values: Set<RoundPercentagesSource.RoundPercentagesType> =
            [.rightAnswer(Double(arc4random_uniform(100) + 100 / 5)),
                    .needCheck(Double(arc4random_uniform(100) + 100 / 5)),
                    .incorrectAnswer(Double(arc4random_uniform(100) + 100 / 5)),
                    .skipped(Double(arc4random_uniform(100) + 100 / 5)),
                    .notViewed(Double(arc4random_uniform(100) + 100 / 5))]
        roundStatistic?.update(with: values)
        rpC.update(with: values)
    }
}

