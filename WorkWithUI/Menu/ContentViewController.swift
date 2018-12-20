//
//  ContentViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 17/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

protocol ContentControllerProtocol: class {
    func newHeight(_ value: CGFloat)
    func headerHeght() -> (updateHeight: CGFloat, neededHeight: CGFloat)
    func resetHeader()
}

class BaseContentController: UIViewController, UIScrollViewDelegate {
    private let displayPercentage : CGFloat = 20.0
    var delegate: ContentControllerProtocol?
    private var lastContentOffset: CGFloat = 0
    private weak var navController: UINavigationController?
    private var barIsInAnination = false
    override func viewDidLoad() {
        self.navController = self.parent?.navigationController
        self.navController?.navigationBar.isTranslucent = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = delegate?.headerHeght() else { return }
        let isHidden = self.lastContentOffset < scrollView.contentOffset.y
        self.navigationBar(isHidden: isHidden, scrollView: scrollView)
        var newHeight = header.updateHeight
        if scrollView.contentOffset.y < 0 {
            newHeight += abs(scrollView.contentOffset.y)
            let p = header.updateHeight * 100 / header.neededHeight
            if p >= displayPercentage {
                self.delegate?.resetHeader()
                return
            }
            if newHeight >= header.neededHeight { newHeight = header.neededHeight }
            self.delegate?.newHeight(newHeight)
        } else if scrollView.contentOffset.y > 0 {
            newHeight -= scrollView.contentOffset.y / 100
            if newHeight < 0 { newHeight = 0 }
            self.delegate?.newHeight(newHeight)
        }
    }

    private func navigationBar(isHidden: Bool, scrollView: UIScrollView) {
        guard let header = delegate?.headerHeght(), !self.barIsInAnination else { return }
        self.barIsInAnination = true
        defer {
            self.lastContentOffset = scrollView.contentOffset.y
            self.barIsInAnination = false
        }

        if header.updateHeight >= header.neededHeight {
            if navController?.navigationBar.isHidden != false {
                navController?.setNavigationBarHidden(false, animated: true)
            }
        } else if !scrollView.isAtBottom {
            if navController?.navigationBar.isHidden != isHidden && scrollView.contentOffset.y != 0 {
                navController?.setNavigationBarHidden(isHidden, animated: true)
            }
        }
    }
}

class ContentViewController: BaseContentController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var tableView: UITableView!
    private let source = Array.init(repeating: 1, count: 100)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = 100
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        if indexPath.row == 0 {
            cell.backgroundColor = .yellow
        } else {
            cell.backgroundColor = .red
        }
        return cell
    }
}

fileprivate extension UIScrollView {
    var isAtTop: Bool { return contentOffset.y <= verticalOffsetForTop }

    var isAtBottom: Bool { return contentOffset.y >= verticalOffsetForBottom }

    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }

    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}
