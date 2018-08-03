//
//  TreeViewController.swift
//  MyWork
//
//  Created by Vladislav Gushin on 03/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class TreeViewController: UIViewController {

    @IBOutlet weak var vControll: ETBVariantsControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        var source = [VariantModel]()
        for i in 0...10 {
            let model = VariantModel(variantNumber: i, questions: [
                "Вопрос 1", "Вопрос 1", "Вопрос 1", "Вопрос 1", "Вопрос 1", "Вопрос 1", "Вопрос 1"
            ])
            source.append(model)
        }

        vControll.update(source: source)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
