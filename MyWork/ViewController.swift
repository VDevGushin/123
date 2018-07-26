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
    @IBOutlet weak var rpC: RoundPercentagesControl!
    @IBOutlet weak var collectionPercent: LinePercentageCollectionControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCollectionUpdate()
    }


    @IBAction func clear(_ sender: Any) {
        rpC.clear(with: true)
        collectionPercent?.clear()
    }

    @IBAction func changeMode(_ sender: Any) {
        rpC.changeMode()

        if !isMultiMode {
            collectionPercent.changeMode(with: .multiple)
        } else {
            collectionPercent.changeMode(with: .single)
        }
        isMultiMode = !isMultiMode
    }

    @IBAction func updateStatistic(_ sender: Any) {
        let values: Set<RoundPercentagesSource.PercentagesType> =
            [.rightAnswer(Int(arc4random_uniform(100))),
                    .needCheck(Int(arc4random_uniform(100))),
                    .incorrectAnswer(Int(arc4random_uniform(100))),
                    .skipped(Int(arc4random_uniform(100))),
                    .notViewed(Int(arc4random_uniform(100)))]
        rpC.update(with: values)
        generateDataForCollectionLine()
    }
}

fileprivate extension ViewController {
    func initCollectionUpdate() {
        var source = [LinePercentagesSource]()
        for _ in 1...999 {
            source.append(LinePercentagesSource())
        }
        self.collectionPercent.update(source: source)
    }

    func generateDataForCollectionLine() {
        var source = [LinePercentagesSource]()
        for _ in 1...999 {
            let values: Set<RoundPercentagesSource.PercentagesType> =
                [.rightAnswer(Int(arc4random_uniform(100))),
                        .needCheck(Int(arc4random_uniform(100))),
                        .incorrectAnswer(Int(arc4random_uniform(100))),
                        .skipped(Int(arc4random_uniform(100))),
                        .notViewed(Int(arc4random_uniform(100)))]
            source.append(LinePercentagesSource(with: values))
        }
        self.collectionPercent.update(source: source)
    }
}
