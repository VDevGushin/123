//
//  CapturingObjectsInClosures.swift
//  MyWork
//
//  Created by Vladislav Gushin on 06/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate final class ClosureDownloader {
    typealias Complete = () -> Void
    func loadData(complete: Complete) {
        complete()
    }
}

fileprivate final class TestClosureVC: UIViewController {
    let loader = ClosureDownloader()
    weak var titleT: UILabel?
    weak var subTitle: UILabel?
    weak var name: UILabel?
    weak var index: UILabel?

    func test() {
        //Variant 1
        self.loader.loadData { [weak self] in
            guard let wSelf = self else { return }
            print(wSelf.titleT?.text ?? "")
            print(wSelf.subTitle?.text ?? "")
            print(wSelf.name?.text ?? "")
            print(wSelf.index?.text ?? "")
        }

        //Variant 2
        let context = (title: self.titleT?.text ?? "",
                       subTitle: self.subTitle?.text ?? "",
                       name: self.name?.text ?? "",
                       index: self.index?.text ?? "")

        self.loader.loadData {
            print(context.title)
            print(context.subTitle)
            print(context.name)
            print(context.index)
        }
    }
}
