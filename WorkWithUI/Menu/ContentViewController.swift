//
//  ContentViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 17/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

protocol IContentOffsetProtocol: class {
    func newHeight(_ value: CGFloat)
    func headerHeght() -> (headerHeight: CGFloat, needHeight: CGFloat)
}

class ChildRoot: UIViewController, UIScrollViewDelegate {
    var delegate: IContentOffsetProtocol?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = delegate?.headerHeght() else { return }
        var headerHeight = header.headerHeight
        if scrollView.contentOffset.y < 0 {
            headerHeight += abs(scrollView.contentOffset.y)
            if headerHeight >= header.needHeight {
                headerHeight = header.needHeight
            }
            self.delegate?.newHeight(headerHeight)
        } else if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < header.needHeight {
            headerHeight = header.needHeight - scrollView.contentOffset.y
            if headerHeight < 0 { headerHeight = 0 }
            self.delegate?.newHeight(headerHeight)
        }
    }
}

class ContentViewController: ChildRoot, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var tableView: UITableView!
    private let source = Array.init(repeating: 1, count: 100)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = 150
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
