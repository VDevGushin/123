//
//  OnboardingContentViewController.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 09.10.2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class OnboardingContentModel {
    let index: Int
    let color: UIColor?
    let image: UIImage?
    let title: String?
    let subTitle: String?

    init(index: Int, color: UIColor?, image: UIImage?, title: String?, subTitle: String?) {
        self.image = image
        self.title = title
        self.subTitle = subTitle
        self.color = color
        self.index = index
    }
}

class OnboardingContentViewController: UIViewController {
    // private weak var pageControll: UIPageControl?
    var pageViewController: UIPageViewController?

    var source = [OnboardingContentModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setup(_ source: [OnboardingContentModel]) {
        self.source = source
        setupPageViewController()
    }

    func getVCBy(index: Int) -> OnboardingContentViewViewController? {
        guard index <= source.count - 1 else {
            return nil
        }

        return OnboardingContentViewViewController(with: source[index])
    }
}

extension OnboardingContentViewController {
    func setupPageViewController() {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

        guard let pageViewController = self.pageViewController,
            let initVC = getVCBy(index: 0) else { return }

        pageViewController.view.backgroundColor = UIColor.clear

        if #available(iOS 9.0, *) {
            let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [OnboardingContentViewViewController.self])
            pageControl.pageIndicatorTintColor = UIColor.clear
            pageControl.currentPageIndicatorTintColor = UIColor.clear

        }

        pageViewController.dataSource = self
        pageViewController.delegate = self

        self.pageViewController?.setViewControllers([initVC], direction: .forward, animated: false, completion: nil)

        self.view.addSubview(pageViewController.view)
        pageViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        pageViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        pageViewController.didMove(toParent: self)
        self.addChild(pageViewController)
    }
}

extension OnboardingContentViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! OnboardingContentViewViewController).pageIndex
        if(index == 0) { return getVCBy(index: source.count - 1) }
        index -= 1
        return getVCBy(index: index)

    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! OnboardingContentViewViewController).pageIndex
        index += 1
        if(index == source.count) { return getVCBy(index: 0) }
        return getVCBy(index: index)
    }
}
