//
//  LocalizationKitViewController.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 10.10.2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
import Localize_Swift

class LocalizationKitViewController: CoordinatorViewController {
   
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var changeButton: UIButton!
    
    @IBOutlet weak var resetButtin: UIButton!
    
    var actionSheet: UIAlertController!
    let availableLanguages = Localize.availableLanguages(true)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func changeAction(_ sender: Any) {
        actionSheet = UIAlertController(title: nil, message: "Switch Language", preferredStyle: .actionSheet)
        for language in availableLanguages {
            let displayName = Localize.displayNameForLanguage(language)
            let languageAction = UIAlertAction(title: displayName, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                Localize.setCurrentLanguage(language)
            })
            actionSheet.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }

    @IBAction func resetAction(_ sender: Any) {
        Localize.resetCurrentLanguageToDefault()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
