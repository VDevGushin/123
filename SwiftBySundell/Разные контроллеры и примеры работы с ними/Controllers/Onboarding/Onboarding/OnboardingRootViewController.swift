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
    let imageURL: String?
    let title: String?
    let subTitle: String?

    init(color: UIColor?, imageURL: String?, title: String?, subTitle: String?) {
        self.imageURL = imageURL
        self.title = title
        self.subTitle = subTitle
        self.color = color
    }
}

protocol OnboardingRootViewControllerDelegate: class {
    func alertOnboardingSkipped(_ currentStep: Int, maxStep: Int)
    func alertOnboardingCompleted()
    func alertOnboardingNext(_ nextStep: Int)
}


class OnboardingRootViewController: UIViewController {
    private var skipButton: UIButton?
    private var pageControl: UIPageControl?
    private var pageViewController: UIPageViewController?

    private var source = [OnboardingContentModel]()
    weak var delegate: OnboardingRootViewControllerDelegate?

    private var maxStep: Int
    private var currentStep: Int
    private var isCompleted = false

    init(with source: [OnboardingContentModel]) {
        self.maxStep = source.count
        self.currentStep = 0
        super.init(nibName: nil, bundle: nil)
        self.source = source
        self.modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupPageViewController()
        self.configurePageControl()
        self.setupSkipButton()
    }
}

fileprivate extension OnboardingRootViewController {
    func getControllerBy(index: Int) -> OnboardingContentViewController? {
        guard index <= source.count - 1 else { return nil }
        return OnboardingContentViewController(with: source[index], pageIndex: index)
    }

    func setupPageViewController() {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

        guard let pageViewController = self.pageViewController,
            let initVC = getControllerBy(index: 0) else { return }

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
        pageControl.pageIndicatorTintColor = Settings.colorPageIndicator
        pageControl.currentPageIndicatorTintColor = Settings.colorCurrentPageIndicator
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

    func setupSkipButton() {
        self.skipButton = UIButton()
        guard let skipButton = self.skipButton else { return }
        skipButton.setTitle("Skip", for: .normal)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.addTarget(self, action: #selector(self.skipAction), for: .touchUpInside)
        self.view.addSubview(skipButton)
        let margins = view.safeAreaLayoutGuide
        skipButton.heightAnchor.constraint(equalToConstant: 55.0).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        skipButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 12).isActive = true
        skipButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 12).isActive = true
    }

    @objc private func skipAction() {
        self.dismiss(animated: true)
        self.delegate?.alertOnboardingSkipped(self.currentStep, maxStep: self.maxStep)
    }
}

extension OnboardingRootViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard var index = (viewController as? OnboardingContentViewController)?.pageIndex else {
            return nil
        }

        if(index == 0) { return nil }//getVCBy(index: source.count - 1) }
        index -= 1
        return getControllerBy(index: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard var index = (viewController as? OnboardingContentViewController)?.pageIndex else {
            return nil
        }

        index += 1
        if(index == source.count) { return nil }//getVCBy(index: 0) }
        return getControllerBy(index: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let pageContentViewController = pageViewController.viewControllers?.first as? OnboardingContentViewController else {
            return
        }

        let index = pageContentViewController.pageIndex
        self.currentStep = index + 1
        self.delegate?.alertOnboardingNext(self.currentStep)

        if self.currentStep == self.maxStep {
            self.isCompleted = true
            self.delegate?.alertOnboardingCompleted()
            pageContentViewController.setupNextButton(with: "close") { }
        }

        pageContentViewController.setupNextButton(with: "Next") { }

//        if pageControl.currentPage == source.count - 1 {
//            self.alertview.buttonBottom.setTitle(alertview.titleGotItButton, for: UIControlState())
//        } else {
//            self.alertview.buttonBottom.setTitle(alertview.titleSkipButton, for: UIControlState())
//        }
        self.pageControl?.currentPage = index
    }
}

fileprivate extension OnboardingRootViewController {
    struct Settings {
        static let colorPageIndicator = UIColor(red: 171 / 255, green: 177 / 255, blue: 196 / 255, alpha: 1.0)
        static let colorCurrentPageIndicator = UIColor(red: 118 / 255, green: 125 / 255, blue: 152 / 255, alpha: 1.0)
    }
}
