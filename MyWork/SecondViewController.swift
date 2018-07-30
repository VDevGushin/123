//
//  SecondViewController.swift
//  MyWork
//
//  Created by Vladislav Gushin on 30/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var personStatisticControl: PersonStatisticControl!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func update(_ sender: Any) {
        var source = [Person]()
        for _ in 1...10 {
            let person = Person(name: "Test Student", variant: .value(Int(arc4random_uniform(100))), statistic:
                RoundPercentagesSource(with: [.rightAnswer(Int(arc4random_uniform(100))), .notViewed(Int(arc4random_uniform(100))) ]))
            source.append(person)
        }
        self.personStatisticControl.update(source: source)
    }

    @IBAction func clear(_ sender: Any) {
        self.personStatisticControl.clear()
    }
}
