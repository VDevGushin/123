//
//  ScrollRootViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 17/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

//Fabrica
class ChildViewControllers {
    func getContentViewController() -> BaseContentController {
        return ContentViewController(nibName: "ContentViewController", bundle: nil)
    }
}

protocol LibraryRootController {
    var headerHeight: NSLayoutConstraint! { get }
    var headerHeightConstant: CGFloat { get }
}

extension LibraryRootController {
    var headerHeightConstant: CGFloat { return 500.0 }
}

class ScrollRootViewController: UIViewController, LibraryRootController, ContentControllerProtocol {
    private lazy var fabric = ChildViewControllers()
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet private weak var header: UIView!
    @IBOutlet private weak var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerHeight.constant = self.headerHeightConstant

        let contentVC = fabric.getContentViewController()
        contentVC.delegate = self
        self.changeChild(old: nil, new: contentVC)
    }

    private func changeChild(old: UIViewController?, new: UIViewController) {
        old?.remove(from: self.contentView)
        self.add(new, to: self.contentView)
    }

    func newHeight(_ value: CGFloat) {
        self.headerHeight.constant = value
        self.view.layoutIfNeeded()
    }

    func headerHeght() -> (updateHeight: CGFloat, neededHeight: CGFloat) {
        return (headerHeight.constant, self.headerHeightConstant)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Test"
        self.navigationController?.navigationBar.tintColor = .red
    }
    
    func resetHeader() {
        self.headerHeight.constant = self.headerHeightConstant
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension UIViewController {
    func add(_ child: UIViewController, to view: UIView) {
        addChild(child)
        view.addSubview(child.view)
        child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        child.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        child.didMove(toParent: self)
    }

    func remove(from view: UIView) {
        guard parent != nil else { return }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
