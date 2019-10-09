//
//  OnboardingContentViewController.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 09.10.2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class OnboardingContentModel {
    let color: UIColor?
    let image: UIImage?
    let title: String?
    let subTitle: String?

    init(color: UIColor?, image: UIImage?, title: String?, subTitle: String?) {
        self.image = image
        self.title = title
        self.subTitle = subTitle
        self.color = color
    }
}

class OnboardingRootViewController: UIViewController {
    private let colorPageIndicator = UIColor(red: 171 / 255, green: 177 / 255, blue: 196 / 255, alpha: 1.0)
    private let colorCurrentPageIndicator = UIColor(red: 118 / 255, green: 125 / 255, blue: 152 / 255, alpha: 1.0)

    private var pageControl: UIPageControl?
    private var pageViewController: UIPageViewController?

    private var source = [OnboardingContentModel]()

    init(with source: [OnboardingContentModel]) {
        super.init(nibName: nil, bundle: nil)
        self.source = source
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupPageViewController()
        configurePageControl()
    }
}

fileprivate extension OnboardingRootViewController {
    func getVCBy(index: Int) -> OnboardingContentViewController? {
        guard index <= source.count - 1 else { return nil }
        return OnboardingContentViewController(with: source[index], pageIndex: index)
    }

    func setupPageViewController() {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

        guard let pageViewController = self.pageViewController,
            let initVC = getVCBy(index: 0) else { return }

        pageViewController.view.backgroundColor = UIColor.clear

        if #available(iOS 9.0, *) {
            let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [OnboardingContentViewController.self])
            pageControl.pageIndicatorTintColor = UIColor.clear
            pageControl.currentPageIndicatorTintColor = UIColor.clear
        }

        pageViewController.dataSource = self
        pageViewController.delegate = self

        self.pageViewController?.setViewControllers([initVC], direction: .forward, animated: false, completion: nil)

        view.addSubview(pageViewController.view)
        let margins = view.safeAreaLayoutGuide

        pageViewController.view.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        pageViewController.view.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        pageViewController.didMove(toParent: self)

        self.addChild(pageViewController)
    }

    func configurePageControl() {
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        guard let pageControl = self.pageControl else {
            return
        }
        pageControl.backgroundColor = UIColor.clear
        pageControl.pageIndicatorTintColor = colorPageIndicator
        pageControl.currentPageIndicatorTintColor = colorCurrentPageIndicator
        pageControl.numberOfPages = source.count
        pageControl.currentPage = 0
        pageControl.isEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pageControl)

        let margins = view.safeAreaLayoutGuide
        pageControl.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20.0).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
    }
}

extension OnboardingRootViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! OnboardingContentViewController).pageIndex
        if(index == 0) { return getVCBy(index: source.count - 1) }
        index -= 1
        return getVCBy(index: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! OnboardingContentViewController).pageIndex
        index += 1
        if(index == source.count) { return getVCBy(index: 0) }
        return getVCBy(index: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0] as! OnboardingContentViewController
        let index = pageContentViewController.pageIndex
        self.pageControl?.currentPage = index
    }
}
