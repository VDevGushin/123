//
//  ViewController.swift
//  MyWork
//
//  Created by Vladislav Gushin on 06/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var isMultiMode = true
    @IBOutlet weak var collectionPercent: StatisticControl!
    @IBOutlet weak var timerControl: ETBTimerControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCollectionUpdate()

        timerControl.setupTime(min: 5, format: .short)
    }

    @IBAction func clear(_ sender: Any) {
        collectionPercent?.clear()
        timerControl.stop()
    }

    @IBAction func changeMode(_ sender: Any) {
        if !isMultiMode {
            collectionPercent.changeMode(with: .multiple)
        } else {
            collectionPercent.changeMode(with: .single)
        }
        isMultiMode = !isMultiMode
        timerControl.start()
    }

    @IBAction func updateStatistic(_ sender: Any) {
        let values: Set<RoundPercentagesSource.PercentagesType> =
            [.rightAnswer(Int(arc4random_uniform(100))),
                    .needCheck(Int(arc4random_uniform(100))),
                    .incorrectAnswer(Int(arc4random_uniform(100))),
                    .skipped(Int(arc4random_uniform(100))),
                    .notViewed(Int(arc4random_uniform(100)))]
        self.collectionPercent.updateGlobal(source: RoundPercentagesSource(with: values))
        var source = [LinePercentagesSource]()
        for _ in 1...10 {
            let values: Set<RoundPercentagesSource.PercentagesType> =
                [.rightAnswer(Int(arc4random_uniform(100))),
                        .needCheck(Int(arc4random_uniform(100))),
                        .incorrectAnswer(Int(arc4random_uniform(100))),
                        .skipped(Int(arc4random_uniform(100))),
                        .notViewed(Int(arc4random_uniform(100)))]
            source.append(LinePercentagesSource(with: values))
        }
        self.collectionPercent.updateVariants(source: source)
        timerControl.addTime(seconds: 60)
    }
}

fileprivate extension ViewController {
    func initCollectionUpdate() {
        var source = [LinePercentagesSource]()
        for _ in 1...10 {
            source.append(LinePercentagesSource())
        }
        self.collectionPercent.updateVariants(source: source)
    }

    func generateDataForCollectionLine() {
        var source = [LinePercentagesSource]()
        for _ in 1...10 {
            let values: Set<RoundPercentagesSource.PercentagesType> =
                [.rightAnswer(Int(arc4random_uniform(100))),
                        .needCheck(Int(arc4random_uniform(100))),
                        .incorrectAnswer(Int(arc4random_uniform(100))),
                        .skipped(Int(arc4random_uniform(100))),
                        .notViewed(Int(arc4random_uniform(100)))]
            source.append(LinePercentagesSource(with: values))
        }
        self.collectionPercent.updateVariants(source: source)
    }
}
