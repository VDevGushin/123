//
//  ViewController.swift
//  MyWorkV2
//
//  Created by Vladislav Gushin on 05/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let s1 = "23.10.1989"
        let d1 = Date.getDate(s1)
        dump(d1)
        let s2 = "1989.10.23"
        let d2 = Date.getDate(s2)
        dump(d2)
        let s3 = "1989-10-23"
        let d3 = Date.getDate(s3)
        dump(d3)
        let s4 = "23-10-1989"
        let d4 = Date.getDate(s4)
        dump(d4)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

