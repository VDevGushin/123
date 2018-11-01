//
//  ChatBaseViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 30/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class ChatBaseViewController: UIViewController {
    let viewTitle: String
    let navigator: ChatCoordinator

    init(navigator: ChatCoordinator,
         title: String,
         nibName: String,
         bundle: Bundle) {

        self.viewTitle = title
        self.navigator = navigator
        super.init(nibName: nibName, bundle: bundle)
        self.navigationItem.title = title
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildUI()
    }

    func buildUI() {
        //#error("You need to override this method")
        fatalError("Not implemented method")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: self.view.window)
    }
}
