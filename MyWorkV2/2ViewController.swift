//
//  2ViewController.swift
//  MyWorkV2
//
//  Created by Vladislav Gushin on 06/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class Loader {
    deinit { print("deinit loader") }
    func load(complete: @escaping () -> Void) {
        DispatchQueue.global().async {
            sleep(5)
            print(100)
            DispatchQueue.main.async {
                complete()
            }
        }
    }
}

class _ViewController: UIViewController {
    var test = "q234234"
    let loader = Loader()

    @IBOutlet weak var asdfasdfasdf: UILabel!
    
    @IBAction func dsafsdf(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

    deinit {
        print("deinit view conroller")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let context = (text: self.test, label: asdfasdfasdf)
        loader.load { 
            let d = context.text
            print("Complerte closure \(d)")
        }
        print("finish view did load")
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
