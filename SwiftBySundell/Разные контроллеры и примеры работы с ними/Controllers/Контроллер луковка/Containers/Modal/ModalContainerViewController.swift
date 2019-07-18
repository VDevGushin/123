//
//  ModalContainerViewController.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 18/07/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class ModalContainerViewController: UIViewController, Storyboardable, ViewSpecificController {
    typealias RootView = ModalContainerView

    var viewTitle: String?
    var navigator: AppCoordinator!

    public override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    public func embedController(_ controller: UIViewController) {
        self.insertFullframeChildController(controller, index: 0)
    }

    @IBAction private func onCloseAction(_ sender: Any) {
        self.navigator.back()
    }
}

extension UIViewController {
    func wrapInModalContainer() -> ModalContainerViewController {
        let modalController = ModalContainerViewController.instantiateInitialFromStoryboard()
        modalController.embedController(self)
        return modalController
    }
}

extension ModalContainerViewController {
    static func makeVC(title: String, coordinator: AppCoordinator) -> ModalContainerViewController {
        let contentController = NewYearContentViewController.instantiateInitialFromStoryboard()
        let onboardingController = OnboardingViewControllerNew.instantiateInitialFromStoryboard()
        onboardingController.embedController(contentController, actionsDatasource: contentController)
        let vc = onboardingController.wrapInModalContainer()
        vc.viewTitle = title
        vc.navigationItem.title = title
        vc.navigator = coordinator
        return vc
    }
}
