//
//  ViewController.swift
//  MyWorkV2
//
//  Created by Vladislav Gushin on 05/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var ttt: UILabel!
    let tcs = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "testID")
    override func viewDidLoad() {
        super.viewDidLoad()
        add(tcs)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}
