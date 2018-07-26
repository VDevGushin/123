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

    @IBOutlet weak var collectionPercent: LinePercentageCollectionControl!
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
        self.initCollectionUpdate()
    }


    @IBAction func clear(_ sender: Any) {
        roundStatistic?.clear(with: true)
        rpC.clear(with: true)
        lineTes2.clear()
    }

    @IBAction func changeMode(_ sender: Any) {
        roundStatistic?.changeMode()
        rpC.changeMode()
        lineTes2.changeMode()
        collectionPercent.changeMode()
    }

    @IBAction func updateSingleSource(_ sender: Any) {
        //Когда идет выбор только по колличеству отвеченных
        //Участвует только 2 элемента в работе
        let values: Set<RoundPercentagesSource.PercentagesType> =
            [.rightAnswer(Int(arc4random_uniform(100))),
                    .needCheck(0),
                    .incorrectAnswer(0),
                    .skipped(0),
                    .notViewed(Int(arc4random_uniform(100)))]
        roundStatistic?.update(with: values)
        rpC.update(with: values)
        lineTes2.update(with: values)
    }

    @IBAction func updateStatistic(_ sender: Any) {
        let values: Set<RoundPercentagesSource.PercentagesType> =
            [.rightAnswer(Int(arc4random_uniform(100))),
                    .needCheck(Int(arc4random_uniform(100))),
                    .incorrectAnswer(Int(arc4random_uniform(100))),
                    .skipped(Int(arc4random_uniform(100))),
                    .notViewed(Int(arc4random_uniform(100)))]
        roundStatistic?.update(with: values)
        rpC.update(with: values)
        lineTes2.update(with: values)

        generateDataForCollectionLine()
    }

    @IBAction func changeColor(_ sender: Any) {
        lineTes2?.setColor(UIColor.random())
    }
}

fileprivate extension ViewController {
    func initCollectionUpdate() {
        let v1 = LinePercentagesSource()
        let v2 = LinePercentagesSource()
        let v3 = LinePercentagesSource()
        let v4 = LinePercentagesSource()
        let v5 = LinePercentagesSource()
        
        let source = [v1, v2, v3, v4, v5]
        self.collectionPercent.update(source: source)
    }
    
    func generateDataForCollectionLine() {
        let values: Set<RoundPercentagesSource.PercentagesType> =
            [.rightAnswer(Int(arc4random_uniform(100))),
                    .needCheck(Int(arc4random_uniform(100))),
                    .incorrectAnswer(Int(arc4random_uniform(100))),
                    .skipped(Int(arc4random_uniform(100))),
                    .notViewed(Int(arc4random_uniform(100)))]

        let v1 = LinePercentagesSource(with: values)
        let v2 = LinePercentagesSource(with: values)
        let v3 = LinePercentagesSource(with: values)
        let v4 = LinePercentagesSource(with: values)
        let v5 = LinePercentagesSource(with: values)

        let source = [v1, v2, v3, v4, v5]
        self.collectionPercent.update(source: source)
    }
}
