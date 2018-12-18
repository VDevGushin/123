//
//  ScrollRootViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 17/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

protocol IRoot {
    var headerHeight: NSLayoutConstraint! { get }
    var headerHeightConstant: CGFloat { get }
}

class ChildViewControllers {
    func getContentViewController() -> ChildRoot {
        return ContentViewController.init(nibName: "ContentViewController", bundle: nil)
    }
}

class ScrollRootViewController: UIViewController, IRoot, IContentOffsetProtocol {
    private lazy var fabric = ChildViewControllers()

    var headerHeightConstant: CGFloat = 150.0
    @IBOutlet weak var headerHeight: NSLayoutConstraint!

    @IBOutlet private weak var header: UIView!
    @IBOutlet private weak var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
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

    func headerHeght() -> (headerHeight: CGFloat, needHeight: CGFloat) {
        return (headerHeight.constant, self.headerHeightConstant)
    }
}

extension UIViewController {
    func add(_ child: UIViewController, to view: UIView) {
        addChild(child)
        view.addSubview(child.view)
        child.view.isUserInteractionEnabled = true
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
