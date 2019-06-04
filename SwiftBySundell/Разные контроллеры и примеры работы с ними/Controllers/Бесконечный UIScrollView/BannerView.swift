//
//  BannerView.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 30/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

struct BannerViewConfiguration {
    var pagingDuration = 1.0
    var enableSelection = true
    
}

class BannerView: UIView {
    // BannerView DataSources (1)
    private var itemAtIndex: ((_ bannerView: BannerView, _ index: Int) -> UIView)!
    private var numberOfItems: Int = 0

    private let scrollView: UIScrollView = {
        let sc = UIScrollView(frame: .zero)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.isPagingEnabled = true
        return sc
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func reloadData(configuration:BannerViewConfiguration?, numberOfItems: Int,
        itemAtIndex: @escaping (_ bannerView: BannerView, _ index: Int) -> UIView) {
        self.itemAtIndex = itemAtIndex
        self.numberOfItems = numberOfItems
        self.reloadScrollView()
    }

    private func setUpUI() {
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        scrollView.delegate = self
        self.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
    }

    private func reloadScrollView() {
        guard self.numberOfItems > 0 else { return }

        let firstItem: UIView = self.itemAtIndex(self, 0)

        if self.numberOfItems == 1 {
            self.addViewToIndex(view: firstItem, index: 0)
            return scrollView.isScrollEnabled = false
        }

        self.addViewToIndex(view: firstItem, index: numberOfItems + 1)
        let lastItem: UIView = self.itemAtIndex(self, numberOfItems - 1)
        self.addViewToIndex(view: lastItem, index: 0)

        for index in 0..<self.numberOfItems {
            let item: UIView = self.itemAtIndex(self, index)
            self.addViewToIndex(view: item, index: index + 1)
        }

        scrollView.contentSize = CGSize(width: CGFloat(numberOfItems + 2) * scrollView.frame.size.width, height: scrollView.frame.size.height)
        scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width, y: self.scrollView.contentOffset.y)
    }

    private func addViewToIndex(view: UIView, index: Int) {
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        view.frame = CGRect(x: CGFloat(index) * scrollView.frame.size.width, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
    }
}

extension BannerView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage: Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        if currentPage == 0 {
            self.scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width * CGFloat(numberOfItems), y: scrollView.contentOffset.y)
        }
        else if currentPage == numberOfItems {
            self.scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }
    }
}
