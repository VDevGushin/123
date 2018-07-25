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

    @IBOutlet weak var lineTes: LinePercentagesControl!
    @IBOutlet weak var lineTes2: LinePercentagesControl!
    private var roundStatistic: RoundPercentageViewController? {
        guard let vc = childViewControllers.first as? RoundPercentageViewController else {
            return nil
        }
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        lineTes2.changeMode()
    }


    @IBAction func clear(_ sender: Any) {
        roundStatistic?.clear(with: true)
        rpC.clear(with: true)
        lineTes.clear()
        lineTes2.clear()
    }

    @IBAction func changeMode(_ sender: Any) {
        roundStatistic?.changeMode()
        rpC.changeMode()
        lineTes.changeMode()
        lineTes2.changeMode()
    }
    @IBAction func updateStatistic(_ sender: Any) {
        let values: Set<RoundPercentagesSource.RoundPercentagesType> =
            [.rightAnswer(Int(arc4random_uniform(100))),
                    .needCheck(Int(arc4random_uniform(100))),
                    .incorrectAnswer(Int(arc4random_uniform(100))),
                    .skipped(Int(arc4random_uniform(100))),
                    .notViewed(Int(arc4random_uniform(100)))]

        roundStatistic?.update(with: values)
        rpC.update(with: values)
        lineTes.update(with: values)
        lineTes2.update(with: values)
    }
}

